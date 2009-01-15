Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbZAOE6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbZAOE6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 23:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbZAOE6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 23:58:39 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47382
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbZAOE6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 23:58:38 -0500
Date: Wed, 14 Jan 2009 20:58:39 -0800 (PST)
Message-Id: <20090114.205839.20689555.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: akpm@linux-foundation.org, Volker.Lendecke@SerNet.DE,
       linux-kernel@vger.kernel.org, sfrench@us.ibm.com, jens.axboe@oracle.com,
       netdev@vger.kernel.org
Subject: Re: maximum buffer size for splice(2) tcp->pipe?
From: David Miller <davem@davemloft.net>
In-Reply-To: <496D25F8.2080505@cosmosbay.com>
References: <20090113123702.ad29cd13.akpm@linux-foundation.org>
	<496D2078.9080302@cosmosbay.com>
	<496D25F8.2080505@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 14 Jan 2009 00:38:32 +0100

> [PATCH] net: splice() from tcp to socket should take into account O_NONBLOCK
> 
> Instead of using SPLICE_F_NONBLOCK to select a non blocking mode both on
> source tcp socket and pipe destination, we use the underlying file flag (O_NONBLOCK)
> for selecting a non blocking socket.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

This needs at least some more thought.

It seems, for one thing, that this change will interfere with the
intentions of the code in splice_dirt_to_actor which goes:

	/*
	 * Don't block on output, we have to drain the direct pipe.
	 */
	sd->flags &= ~SPLICE_F_NONBLOCK;
