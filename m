Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXHMDPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXHMDPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934597AbXHMDO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:14:56 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2106 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764188AbXHMDOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:14:55 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <noring@nocrew.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: Improving read/write/close system call reliability when used with pthreads
Date: Sun, 12 Aug 2007 20:14:47 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEHMGBAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <A94120FD-315A-45B7-A8F4-8DC8DC21279E@nocrew.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 12 Aug 2007 20:15:26 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 12 Aug 2007 20:15:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 2) Do close reader fd, but what results can then applications
> reliably expect? What would be the sane intention of applications
> closing reader fd? Do programmers expect all of the current results?

> Fredrik

Since there's no atomic "unlock and read" function, any code that could ever
close a socket in one thread while another thread is blocked on read might
call close just before another thread blocks in read. Nothing stops another
thread from opening something, getting the same file descriptor, and then
allowing the thread to call "read" on the wrong file descriptor entirely.

Since this can never be made sane in general, I see little point in making
one variation of what can go wrong a bit saner. It is still irresponsible to
code like this.

DS


