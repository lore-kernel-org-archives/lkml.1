Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYBWSTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYBWSTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbYBWSTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:19:19 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758524AbYBWSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:19:18 -0500
Date: Sat, 23 Feb 2008 10:18:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/6] regulator: regulator core.
Message-Id: <20080223101843.d7c001e7.akpm@linux-foundation.org>
In-Reply-To: <20080223095217.GA28356@flint.arm.linux.org.uk>
References: <1203527351.4071.92.camel@localhost.localdomain>
	<20080223000538.e1f086e1.akpm@linux-foundation.org>
	<20080223095217.GA28356@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 09:52:17 +0000 Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sat, Feb 23, 2008 at 12:05:38AM -0800, Andrew Morton wrote:
> > On Wed, 20 Feb 2008 17:09:11 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:
> > 
> > > This patch provides the regulator framework core. The core also provides a
> > > sysfs interface for userspace information.
> > > 
> > > ...
> > >
> > > +
> > > +/* We need to undef the current macro (from include/asm/current.h) otherwise
> > > + * our "current" sysfs entry becomes "(get_current())".
> > > + */
> > > +#undef current
> > 
> > err, no ;)  Please rename your stuff.
> 
> Renaming is not an option - "current" is an electronic term for which
> there is no alternative.

amps, milliamps, amperage (the latter of which I've always disliked)

>  The real problem is this __ATTR macro crap:
> 
> +       __ATTR(current, 0444, regulator_uA_show, NULL),

This interface would actually be *improved* if that sysfs file were named
"microamps" rather than "current".  Because its units become
self-documenting.  Similarly, s/voltage/millivolts/g

> #define __ATTR(_name,_mode,_show,_store) { \
> 	.attr = {.name = __stringify(_name), .mode = _mode },	\
> 	.show	= _show,					\
> 	.store	= _store,					\
> }
> 
> If __ATTR allowed the name to be passed as a string, instead of stupidly
> stringifying it, then this wouldn't be needed.  So I suggest that the
> #undef stands _until_ we fix this stupid macro.

yeah, macros suck.

>  Or we rename the
> "current" macro to something that doesn't clash with accepted scientific
> and engineering terminology.
