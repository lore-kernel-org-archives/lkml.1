Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbXJSVkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbXJSVkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbXJSVjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:39:52 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33714 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbXJSVjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:39:51 -0400
Message-ID: <47192425.6020507@garzik.org>
Date: Fri, 19 Oct 2007 17:39:49 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.23] tasks stuck in running state?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On my main devel box, vanilla 2.6.23 on x86-64/Fedora-7, I'm seeing a 
certain behavior at least once a day.  I'll start a kernel build (make 
-sj5 on this box), and it will "hang" in the following way:

> 31003 ?        S      0:04 sshd: jgarzik@pts/0
> 31004 pts/0    Ss     0:02  \_ -bash
>  8280 pts/0    S+     0:00      \_ make ARCH=i386 -sj4
>  8690 pts/0    Z+     0:00          \_ [rm] <defunct>
>  8691 pts/0    S+     0:00          \_ /bin/sh -c cat include/config/kernel.release 2> /dev/null
>  8692 pts/0    R+     6:12              \_ cat include/config/kernel.release

Specifically, the symptom is a process, often a simple one like cat(1) 
or rm(1) or somewhere in check-headers, will stay in the running state, 
accumulating CPU time.

If I Ctrl-C the build, and start over, the build will normally -not- get 
stuck at the same point, but proceed to chew through one of a bazillion 
allmodconfig builds.

I also see this occasionally on my main workstation (also 
2.6.23/x86-64/Fedora-7), though not as frequently.

This is a new behavior since the new scheduler was merged... I think.

Nothing more concrete to report at this time.  I cannot easily reproduce 
the behavior, as it happens [apparently] randomly sometime during the 
day.  Generally, the files these programs are dealing with are -always- 
in the pagecache, if that makes any difference.

	Jeff


