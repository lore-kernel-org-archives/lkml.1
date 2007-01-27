Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbXA0OxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbXA0OxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 09:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbXA0OxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 09:53:15 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:57215 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbXA0OxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 09:53:15 -0500
Date: Sat, 27 Jan 2007 15:51:42 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: vandrove@vc.cvut.cz
cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ncpfs and TCP vs UDP
In-Reply-To: <1169846450.45ba70b2698c2@imap.vc.cvut.cz>
Message-ID: <Pine.LNX.4.61.0701271550210.22295@yvahk01.tjqt.qr>
References: <45BA2437.4000803@drzeus.cx> <1169846450.45ba70b2698c2@imap.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 26 2007 22:20, vandrove@vc.cvut.cz wrote:
>Quoting Pierre Ossman <drzeus-list@drzeus.cx>:
>
>TCP is definitely preferred.  There are couple of reasons why you should
>prefer TCP:
>
>(1) There is server configuration option to disable NCP/UDP.  You cannot
>disable NCP/TCP that easily.
>
>(2) TCP (NCP over TCP) retransmits only missing data, and it can ask for
>retransmit much sooner as it knows what link latency is.  NCP/UDP can only ask
>for complete packet retransmission, and it has no good idea what's link
>latency because there is no ACK from server when it receives request - you can
>only resend after usual link latency + time for process request, so you'll
>wait longer for retransmit, and on retransmit you need to send again complete
>request (which can be 64KB of data if you use 64KB buffer size...)
>
>(3) To avoid problems with retransmits ncpfs uses default buffer size 60KB for
>TCP (SOCK_STREAM), while 1KB for UDP/IPX (it must be multiple of sector size,
>so using 1.4KB is not an option).  So if you read 1 page, you get 1
>request/reply when using TCP, but 4 requests/replies in UDP/IPX.  And as all
>this is fully synchronous, and for today's link latency is dominating factor,
>it will take 4 times longer...
[and (4)]

Well, probably the same reason as NFS over UDP is discouraged. See nfs(5)
section WARNINGS (in short: IP fragment ID can wrap quite fast on Gigabit)



	-`J'
-- 
