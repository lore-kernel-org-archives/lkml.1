Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZKNDEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZKNDEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbZKNDEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:04:22 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51257
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbZKNDEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:04:22 -0500
Date: Fri, 13 Nov 2009 19:04:38 -0800 (PST)
Message-Id: <20091113.190438.78469912.davem@davemloft.net>
To: gregory.haskins@gmail.com
Cc: herbert@gondor.apana.org.au, ghaskins@novell.com, mst@redhat.com,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC PATCH] net: add dataref destructor to sk_buff
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AFE08EF.2030308@gmail.com>
References: <4AF98A8C.9040201@novell.com>
	<20091114011229.GA18580@gondor.apana.org.au>
	<4AFE08EF.2030308@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <gregory.haskins@gmail.com>
Date: Fri, 13 Nov 2009 20:33:35 -0500

> Well, not with respect to the overall protocol, of course not.  But with
> respect to the buffer in question, it _has_ to be.  Or am I missing
> something?

sendfile() absolutely, and positively, is not.

Any entity can write to the pages being send via sendfile(), at will,
and those writes will show up in the packet stream if they occur
before the NIC DMA's the memory backed by those pages into it's
buffer.

There is zero data synchronization whatsoever, we don't lock the
pages, we don't block their usage while they are queued up in the
socket send queue, nothing like that.

The user returns long before it every hits the wire and there is zero
"notification" to the user that the pages in question for the
sendfile() request are no longer in use.

It seems that your understanding of how buffering and synchronization
works in the TCP stack has come out of a fairy tale :-)
