Return-Path: <linux-kernel-owner+w=401wt.eu-S935958AbXFFVXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935958AbXFFVXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934915AbXFFVXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:23:03 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:60725 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934830AbXFFVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:23:01 -0400
Date: Wed, 6 Jun 2007 23:24:16 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070606212414.GD6497@enneenne.com>
References: <20070605072501.GA15273@enneenne.com> <20070606132934.18606a17.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606132934.18606a17.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [RFC] PPS: Implementing LinuxPPS API with new syscalls
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 01:29:34PM -0700, Andrew Morton wrote:

> >    asmlinkage long sys_time_pps_find(int cmd, int __user *source,
> >                                           char __user *name, int namelen,
> >                                           char __user *path, int pathlen);

Try to find a PPS source into the system giving one of its feature.

With cmd==PPS_FIND_SRC we check for a PPS source with index number
equal to *source, if *source==-1 we just ask for the first PPS source
defined into the system.

With cmd=PPS_FIND_PATH we check for a PPS source with path name equal
to path.

Selected source is returned into *source and PPS source info are
placed into path and name arrays.

> >    asmlinkage long sys_time_pps_getparams(int source,
> >                                           struct pps_params __user *params);

struct pps_params {
        int api_version;                /* API version # */
        int mode;                       /* mode bits */
        union pps_timeu assert_off_tu;  /* offset compensation for assert */
        union pps_timeu clear_off_tu;   /* offset compensation for clear */
};

Given a PPS source index returns its parameters setting.

> >    asmlinkage long sys_time_pps_setparams(int source,
> >                                           const struct pps_params __user *params);

Sets PPS source parameters.

> >    asmlinkage long sys_time_pps_getcap(int source, int __user *mode);

Given a	PPS source index returns its functioning modes.

> >    asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
> >                                           struct pps_info __user *info,
> >                                           const struct timespec __user *timeout);

struct pps_info {
        unsigned long assert_sequence;  /* seq. num. of assert event */
        unsigned long clear_sequence;   /* seq. num. of clear event */
        union pps_timeu assert_tu;      /* time of assert event */
        union pps_timeu clear_tu;       /* time of clear event */
        int current_mode;               /* current mode bits */
};

Given a PPS source index, a time format and, optionally, a timeout
time returns PPS time data.

Further info on these structs can be get on RFC 2783.

Apart sys_time_pps_find() the other syscalls derive directly from RFC
2783 suggestions.

I hope these info are enough... :)

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
