Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYFPOuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYFPOuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYFPOtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:49:55 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:52363 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYFPOty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:49:54 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2008 10:49:53 EDT
X-AuditID: 0ac90647-a9f1fba000004aeb-8b-48567c2675a5
Date: Mon, 16 Jun 2008 23:43:52 +0900 (JST)
Message-Id: <20080616.234352.56004956.noboru.obata.ar@hitachi.com>
To: davidn@davidnewall.com
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org, noboru.obata.ar@hitachi.com
Subject: Re: Feedback on TCP: Make TCP_RTO_MAX a variable
From: Noboru OBATA <noboru.obata.ar@hitachi.com>
In-Reply-To: <4855823F.40208@davidnewall.com>
References: <4855823F.40208@davidnewall.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Last year, Obata Noboru sent a patch to permit adjustment of
> TCP_RTO_MAX, which I have found useful.  Refer to
> http://marc.info/?l=linux-netdev&m=118422471428855 for details.
> 
> A customer reported that their internet-connected POS terminals were
> regularly "freezing" for extended periods, sometimes for as long as a
> few minutes.  My analysis, such as it was, suggested that those
> occasions were caused by floods of packets directed towards the internet
> link at one end or the other (i.e. POS terminal or central server),
> leading to severe packet loss and maximum packet retransmit times during
> which no session data could be transmitted.  I believe those floods were
> caused by anonymous third parties scanning the internet, and attempting
> to break through my client's routers.  I also believe that to be an
> unavoidable social quality of the internet; I have to live with it.

I found your feedback interesting, David.

The wireless people gave me an similar feedback when I first
post the patch.  They said my patch helps TCP connections
recover from the bursty loss much faster than the normal TCP
behavior.  They found my patch useful because a packet loss on
wireless is not necessarily caused by link congestion, but
largely by temporary radio noize or handover between base
stations.

Your situtation seems to me that your connection itself does not
contribute the congestion, but other bursty incoming traffic
does.  So exponential back-off does not help the packet loss
substantially.

My motivation of the patch is different, however.  I wanted TCP
to retransmit the packet shortly after the failover of
underlying network.

I found it interesting that in all the cases where my patch
helps people, the TCP connection in question is not really a
part of congestion and has nothing to do with the packet loss
the connetion is experiencing.

Regards,

-- 
Noboru OBATA (noboru.obata.ar@hitachi.com)

