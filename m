Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZAMX2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZAMX2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZAMX17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:27:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46676
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755798AbZAMX16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:27:58 -0500
Date: Tue, 13 Jan 2009 15:27:59 -0800 (PST)
Message-Id: <20090113.152759.29875009.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: w@1wt.eu, ben@zeus.com, jarkao2@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <4966FC89.8040006@cosmosbay.com>
References: <4966F2F4.9080901@cosmosbay.com>
	<20090109070415.GA27758@1wt.eu>
	<4966FC89.8040006@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Fri, 09 Jan 2009 08:28:09 +0100

> If the application uses setsockopt(sock, SOL_SOCKET, SO_RCVLOWAT,
> [32768], 4), it would be good if kernel was smart enough and could
> reduce number of wakeups.

Right, and as I pointed out in previous replies the problem is
that splice() receive in TCP doesn't check the low water mark
at all.
