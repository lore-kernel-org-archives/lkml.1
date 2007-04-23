Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbXDWWxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbXDWWxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbXDWWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:53:09 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3728 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbXDWWxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:53:07 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: sendfile to nonblocking socket
Date: Mon, 23 Apr 2007 15:52:58 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEAJDEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <462D2177.1060609@amhost.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 23 Apr 2007 16:53:20 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 23 Apr 2007 16:53:21 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> As I see, nonblocking mode is enabled - sendfile sends less than asked.  
> But 2G via single 30 seconds sendfile call - this is blocking call. How 
> can I  avoid that?  I prefer sendfile as fastest way to send file 
> content to network socket. The problem with sendfile block on 
> nonblocking socket has place only when I'm using network connection, 
> that is faster than my hard disk, for example  gigabit NIC or localhost. 
> When I use 100Mbit NIC, which is slower, than my hard disk,  I got small 
> and fast sendfile calls without blocking.
> 
> My kernel is  Linux 2.6.20.3-grsec x86_64. I verified that also on 
> 2.6.18 - same results. Please advise.

You have a misunderstanding about the semantics of 'sendfile'. The 'sendfile' function is just a more efficient version of a read followed by a write. If you did a read followed by a write, it would block as well (in the read).

DS


