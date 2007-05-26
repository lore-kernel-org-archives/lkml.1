Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbXEZXCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbXEZXCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbXEZXCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:02:12 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4813 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbXEZXCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:02:10 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: epoll,threading
Date: Sat, 26 May 2007 16:01:36 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEJIEBAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <10815949.post@talk.nabble.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 26 May 2007 17:02:03 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 26 May 2007 17:02:05 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello all,
>
> I want to know in detail about , what the events (epoll or /dev/poll or
> select ) achieve in contrast to  thread per client.
>
> i can have a thread per client and use send and recv system call directly
> right? Why do i go for these event mechanisms?
>
> Please help me to understand this.

Aside from the obvious, consider a server that needs to do a little bit of
work on each of 1,000 clients on a single CPU system. With a
thread-per-client approach, 1,000 context switches will be needed. With an
epoll thread pool approach, none are needed and five or six are typical.

Both get you the major advantages of threading. You can take full advantage
of multiple CPUs. You can write code that blocks occasionally without
bringing the whole server down. A page fault doesn't stall your whole
server.

DS


