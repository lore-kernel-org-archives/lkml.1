Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbYBWJwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbYBWJwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYBWJwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:52:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40503 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbYBWJwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:52:41 -0500
Date: Sat, 23 Feb 2008 09:52:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/6] regulator: regulator core.
Message-ID: <20080223095217.GA28356@flint.arm.linux.org.uk>
References: <1203527351.4071.92.camel@localhost.localdomain> <20080223000538.e1f086e1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223000538.e1f086e1.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:05:38AM -0800, Andrew Morton wrote:
> On Wed, 20 Feb 2008 17:09:11 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:
> 
> > This patch provides the regulator framework core. The core also provides a
> > sysfs interface for userspace information.
> > 
> > ...
> >
> > +
> > +/* We need to undef the current macro (from include/asm/current.h) otherwise
> > + * our "current" sysfs entry becomes "(get_current())".
> > + */
> > +#undef current
> 
> err, no ;)  Please rename your stuff.

Renaming is not an option - "current" is an electronic term for which
there is no alternative.  The real problem is this __ATTR macro crap:

+       __ATTR(current, 0444, regulator_uA_show, NULL),

#define __ATTR(_name,_mode,_show,_store) { \
	.attr = {.name = __stringify(_name), .mode = _mode },	\
	.show	= _show,					\
	.store	= _store,					\
}

If __ATTR allowed the name to be passed as a string, instead of stupidly
stringifying it, then this wouldn't be needed.  So I suggest that the
#undef stands _until_ we fix this stupid macro.  Or we rename the
"current" macro to something that doesn't clash with accepted scientific
and engineering terminology.
