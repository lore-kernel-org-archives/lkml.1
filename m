Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZG2Cq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZG2Cq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZG2Cq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:46:56 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:59277 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZG2Cq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:46:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wLi35boNmMmiC0kvHvIFeIE08305y2oofqGR2qu4rd1NOoHIXineDEewjozyAKp6Dq
         0h5+Y8eb8qfZlz1HeS4mjNcNlZE6T/L5XHs+gXlK0JcZ59FLJoWkaqzsU0dWf4gz5Jbz
         E7xV+6MoAs0xKAuQKdqqVDO3lETNmMdx9U0eY=
MIME-Version: 1.0
In-Reply-To: <20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	 <20090728160527.1da52682.akpm@linux-foundation.org>
	 <20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 28 Jul 2009 22:46:56 -0400
Message-ID: <525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
Subject: Re: [Bugme-new] [Bug 13850] New: reading /proc/kcore causes oops
From: Mike Smith <scgtrp@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What's layout of memory does your server have ?
The log I gave was from my desktop, so I'll assume you wanted that
instead of the server:
[mike: mike in ~]$ grep "System RAM" /proc/iomem
00010000-0009efff : System RAM
00100000-1dedffff : System RAM

> If so, can you please help work out where it crashed?
I didn't compile the kernel myself; it's the stock Arch Linux kernel,
which may explain the following useless output (this was the only file
I could find called vmlinux):
[mike: mike in /usr/src/linux-2.6.30-ARCH]$ addr2line -e vmlinux 0xc0224dd1
kcore.c:0
[mike: mike in /usr/src/linux-2.6.30-ARCH]$ gdb vmlinux
GNU gdb 6.8
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "i686-pc-linux-gnu"...
(no debugging symbols found)
(gdb) l *0xc0224dd1
No symbol table is loaded.  Use the "file" command.


I'll compile a minimal kernel later with debug symbols and see if I
can reproduce it on that.
