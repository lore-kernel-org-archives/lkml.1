Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbXFZRFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbXFZRFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 13:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXFZRFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 13:05:06 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:44540 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXFZRFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 13:05:04 -0400
Date: Tue, 26 Jun 2007 19:06:22 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070626170622.GA13886@enneenne.com>
References: <20070626100628.GO24183@enneenne.com> <1182855427.12109.203.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182855427.12109.203.camel@pmac.infradead.org>
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

On Tue, Jun 26, 2007 at 11:57:07AM +0100, David Woodhouse wrote:
> 
> Your syscalls blindly dereference userspace pointers instead of using
> copy_{to,from} user.

I use access_ok() to test userspace addresses. It should be ok,
shouldn't it?

> Why did you split all your syscalls into two functions?
> 
> s/__FUNCTION__/__func__/

Just for an easy management of mutex locking.

> s/antennas/antennae/

Done. However I found other files in the kernel code with the same
error... ;)

> You seem to have added debugging messages mentioning 'serial8250' into
> serial_core.h

Yes! Fixed.

> You added <linux/pps.h> with #ifdef __KERNEL__ in it, but didn't export
> it to userspace. Why?

This file is called by timepps.h who exports the userland data.

> Your structures for userspace communication look OK -- I don't think you
> need special 32/64 compatibility for them. You do need it for the
> 'struct timespec' in sys_time_pps_fetch() though.

Mmm... can you please explain a bit what do you mean? Maybe just a
link...

> Must we have the ioctl-like interface to sys_time_pps_cmd()? If the

It seems to me stronger then other solutions...

> second argument is always 'struct pps_source_data_s *', why does the
> syscall pretend it's 'void *'?

Just to keep sys_time_pps_cmd() generic for future new commands.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
