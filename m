Return-Path: <linux-kernel-owner+w=401wt.eu-S934359AbXKPALn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359AbXKPALn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765576AbXKPALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:11:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37949 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764994AbXKPALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:11:16 -0500
Date: Thu, 15 Nov 2007 15:58:49 -0800
From: Greg KH <greg@kroah.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [patch 04/13] param_sysfs_builtin memchr argument fix
Message-ID: <20071115235849.GA5368@kroah.com>
References: <20071115042610.731859958@mini.kroah.org> <20071115060927.GE7602@kroah.com> <473C6FCF.6010501@redhat.com> <20071115175810.GC24531@suse.de> <473CB03D.6000404@redhat.com> <473CB82F.8060204@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473CB82F.8060204@web.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 10:20:47PM +0100, Jan Kiszka wrote:
> Chuck Ebbert wrote:
> > On 11/15/2007 12:58 PM, Greg KH wrote:
> >> On Thu, Nov 15, 2007 at 11:11:59AM -0500, Chuck Ebbert wrote:
> >>> On 11/15/2007 01:09 AM, Greg KH wrote:
> >>>> -stable review patch.  If anyone has any objections, please let us know.
> >>>>
> >>>> ------------------
> >>>> From: Dave Young <hidave.darkstar@gmail.com>
> >>>>
> >>>> patch faf8c714f4508207a9c81cc94dafc76ed6680b44 in mainline.
> >>>>
> >>>> If memchr argument is longer than strlen(kp->name), there will be some
> >>>> weird result.
> >>>>
> >>>> It will casuse duplicate filenames in sysfs for the "nousb".  kernel
> >>>> warning messages are as bellow:
> >>>>
> >>> Needs an additional fix:
> >>>
> >>> Commit:     22800a2830ec07e7cc5c837999890ac47cc7f5de
> >>> fix param_sysfs_builtin name length check
> >> That just went in yesterday, right?  If so, it will have to wait until
> >> the next -stable review cycle, unless it's totally broken without that
> >> change.
> >>
> >> Is it?
> >>
> > 
> > Yeah, pretty much AFAICT. Maybe Jan can say exactly what happened, but
> > it looks like the patch would cause more problems than it solves.
> > 
> 
> If you have a module parameter like
> "my_module.uses_long_parameter_names", Dave's patch caused it to be
> rejected if that module was built into the kernel, although "my_module"
> is far shorter than MAX_KBUILD_MODNAME, thus perfectly legal.
> 
> I noticed this with out-of-tree stuff, but I would bet in-tree users are
> affected as well. Hmm... e.g. "nf_conntrack.expect_hashsize" should not
> longer exist if nf_conntrack is non-modular.

Ok, that makes sense, I've added your patch to the queue to go into the
next release with this original patch.

thanks,

greg k-h
