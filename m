Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZF3Ug3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZF3Ug3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZF3UgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:36:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165AbZF3UgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:36:21 -0400
Date: Tue, 30 Jun 2009 13:35:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
Message-Id: <20090630133550.bf34a0ba.akpm@linux-foundation.org>
In-Reply-To: <4A4A7364.1090108@oracle.com>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
	<54770.1246392952@turing-police.cc.vt.edu>
	<4A4A7364.1090108@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 13:19:48 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Valdis.Kletnieks@vt.edu wrote:

(I wasn't cc'ed?)

> > On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
> >> The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to
> > 
> > This dies with quilt 0.44, thusly:
> > 
> > Applying patch procfs-provide-stack-information-for-threads-v08.patch
> > can't find file to patch at input line 20
> > Perhaps you used the wrong -p or --strip option?
> > The text leading up to this was:
> > --------------------------
> > |From: Stefani Seibold <stefani@seibold.net>
> > |
> > |A patch to give a better overview of the userland application stack usage,
> > |especially for embedded linux.
> > |
> > |Currently you are only able to dump the main process/thread stack usage
> > |which is showed in /proc/pid/status by the "VmStk" Value.  But you get no
> > |information about the consumed stack memory of the the threads.
> > |
> > |There is an enhancement in the /proc/<pid>/{task/*,}/*maps and which marks
> > |the vm mapping where the thread stack pointer reside with "[thread stack
> > |xxxxxxxx]".  xxxxxxxx is the maximum size of stack.  This is a value
> > |information, because libpthread doesn't set the start of the stack to the
> > |top of the mapped area, depending of the pthread usage.
> > |
> > |A sample output of /proc/<pid>/task/<tid>/maps looks like:
> > |
> > |08048000-08049000 r-xp 00000000 03:00 8312       /opt/z
> > |08049000-0804a000 rw-p 00001000 03:00 8312       /opt/z

The next line is:

a7d12000-a7d13000 ---p 00000000 00:00 0

And I bet stupid patch(1) saw that "---" and decided that it was the
start of a diff.

Try adding `-u' to the patch(1) command?

I use something like

	patch -u -f -p1 --fuzz=1 -s
