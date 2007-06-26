Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbXFZSMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbXFZSMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbXFZSL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:11:57 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:45322 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbXFZSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:11:56 -0400
Date: Tue, 26 Jun 2007 20:13:19 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070626181319.GB13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com> <1182855427.12109.203.camel@pmac.infradead.org> <20070626170622.GA13886@enneenne.com> <1182879520.3263.19.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182879520.3263.19.camel@shinybook.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 06:38:40PM +0100, David Woodhouse wrote:

> That sounds like you're scared of using goto. Don't be :)

But it's not wrong... should I change it or not?

> I don't see this timepps.h of which you speak. If it's a _userspace_
> file, it cannot include <linux/pps.h> unless you actually add
> <linux/pps.h> to the list of files which are exported.
> 
> Run 'make headers_install' and observe that there is no file
> usr/include/linux/pps.h -- so there would be no /usr/include/linux/pps.h
> generated from your kernel tree. You need to add 'unifdef-y += pps.h' to
> include/linux/Kbuild for that to happen.

Is this right?

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 94cc04a..87f1e2c 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -290,6 +290,7 @@ unifdef-y += pmu.h
 unifdef-y += poll.h
 unifdef-y += ppp_defs.h
 unifdef-y += ppp-comp.h
+unifdef-y += pps.h
 unifdef-y += ptrace.h
 unifdef-y += qnx4_fs.h
 unifdef-y += quota.h

> 64-bit kernels can run 32-bit userspace programs. But some structures
> come out _differently_ between 32-bit and 64-bit compilation, so the
> system call needs a special 'compat' handler instead of just running the
> normal 64-bit system call.
> 
> The 'struct timespec' is one structure which is sometimes different for
> 32-bit vs. 64-bit, so any system call taking a 'struct timespec' must
> have a separate compat_sys_xxxx() to handle that. See something like
> compat_sys_clock_settime() in kernel/compat.c for an example (but don't
> use set_fs() like it does; just see how it handles the compat_timespec).

Ok, I'll take a look at it.

Thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
