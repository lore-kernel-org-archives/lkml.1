Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbXFXLPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbXFXLPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 07:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbXFXLPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 07:15:33 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:34437 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbXFXLPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 07:15:32 -0400
Date: Sun, 24 Jun 2007 13:15:21 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fbdev: uvesafb driver
Message-ID: <20070624111521.GA8042@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070623105243.GD12623@spock.one.pl> <20070623113557.f0295218.akpm@linux-foundation.org> <20070623232033.GB7148@spock.one.pl> <20070623163639.f6b4f20d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070623163639.f6b4f20d.akpm@linux-foundation.org>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 04:36:39PM -0700, Andrew Morton wrote:
> On Sun, 24 Jun 2007 01:20:33 +0200 Michal Januszewski <spock@gentoo.org> wrote:
> 
> > > > +config FB_UVESA
> > > > +	tristate "Userspace VESA VGA graphics support"
> > > > +	depends on FB && CONNECTOR
> > > 
> > > These dependencies are insufficient.
> > 
> > What exactly is missing here?  A dep on X86?
> 
> Yes.  From your other comments it appears that a dependency on X86_32 is
> needed.

X86_32 is only needed for a bunch of specific operations that make use of
the PMI.  The driver can work without those (it has already been tested
on X86_64, where PMI cannot be used).
 
> >  This would indicate the
> > arches on which the driver has actually been tested.  But which arches
> > are supported and which aren't is, in the end, up to the userspace helper.
> 
> The other architectures won't compile: they don't have mtrr.h

That was my mistake of not putting the mtrr.h include inside a #ifdef
CONFIG_MTRR.  After fixing that and a few other things you pointed out
in your previous message, I was able to successfully compile uvesafb for
PPC (using a cross-compiler).

Best regards,
Michal

