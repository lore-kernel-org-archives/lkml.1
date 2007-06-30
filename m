Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbXF3RMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbXF3RMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 13:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbXF3RMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 13:12:22 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:41458 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbXF3RMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 13:12:21 -0400
Date: Sat, 30 Jun 2007 19:13:40 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070630171340.GT13886@enneenne.com>
References: <20070628081538.GP13886@enneenne.com> <1183019474.1170.66.camel@pmac.infradead.org> <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183132548.1170.360.camel@pmac.infradead.org> <20070629163422.GP13886@enneenne.com> <1183135253.17622.5.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1183135253.17622.5.camel@shinybook.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 05:40:52PM +0100, David Woodhouse wrote:
> 
> Remember you have to support _both_ 32-bit and 64-bit system calls. You
> need to define struct compat_pps_info and struct compat_pps_params, and 
> you'll have to provide a compat wrapper for sys_time_pps_getparams() and
> sys_time_pps_setparams(). You'll also need to extend your
> compat_sys_time_pps_fetch() wrapper to handle the struct pps_info too.

At this point I'm seriously considfering your previous suggestion:

   Had you considered changing the API so that you don't need the
   compatibility wrapper at all? Could you take an integer number of
   µS or ms instead of a struct timespec?

Maybe I can define a special struct for exchanging time data as:

   struct pps_timedata_s {
      long sec;
      long nsec;
   }

and managing time data conversions at userland...

What do you think about that? :)

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
