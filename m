Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbZE1AI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbZE1AI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbZE1AIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:08:21 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53573 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZE1AIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:08:20 -0400
Date: Thu, 28 May 2009 09:08:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <jw@emlix.com>, os@emlix.com, dhowells@redhat.com,
       rmk@arm.linux.org.uk, cooloney@kernel.org, geert@linux-m68k.org,
       vapier.adi@gmail.com, gerg@uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] flat: fix data sections alignment
Message-ID: <20090528000801.GA30594@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <jw@emlix.com>, os@emlix.com, dhowells@redhat.com,
	rmk@arm.linux.org.uk, cooloney@kernel.org, geert@linux-m68k.org,
	vapier.adi@gmail.com, gerg@uclinux.org,
	linux-kernel@vger.kernel.org
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com> <20090310073350.GH10393@linux-sh.org> <20090402135343.d18d17a5.akpm@linux-foundation.org> <20090409142553.GA3330@emlix.com> <20090505140847.GB25409@emlix.com> <20090527114955.GA23343@emlix.com> <20090527134357.601c3c87.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527134357.601c3c87.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 01:43:57PM -0700, Andrew Morton wrote:
> On Wed, 27 May 2009 13:49:56 +0200
> Johannes Weiner <jw@emlix.com> wrote:
> > On Tue, May 05, 2009 at 04:08:47PM +0200, Johannes Weiner wrote:
> > > On Thu, Apr 09, 2009 at 04:25:53PM +0200, Johannes Weiner wrote:
> > > > On Thu, Apr 02, 2009 at 01:53:43PM -0700, Andrew Morton wrote:
> > > > Paul and Mike had complaints.  Paul acked the last revision.  Mike?
> > > > We need this for upstream to compile on our configuration.
> 
> Who is Mike?
> 
> (A pox upon email clients which strip real names)
> 
> > > Can we get this merged?  Nobody complained.
> > 
> > <periodic echo-request>
> > 
> > What are the plans on this now?  I assume it drowned in other changes...
> > Is it too late to get this in .30 now?
> 
> The patch had a fairly shaky start and it's been unclear to me that
> everyone is happy with it and has tested it.
> 
>  arch/arm/include/asm/flat.h      |    3 --
>  arch/blackfin/include/asm/flat.h |    1 
>  arch/h8300/include/asm/flat.h    |    1 
>  arch/m32r/include/asm/flat.h     |    1 
>  arch/m68k/include/asm/flat.h     |    1 
>  arch/sh/include/asm/flat.h       |    1 
>  fs/binfmt_flat.c                 |   46 ++++++++++++++++++++++++++-------------
> 
> I guess ARM is the major architecture amongst that lot.  Have Russell
> and co had a decent look through this?
> 
The problem here is that the ARM nommu people seem to have disappeared
shortly after getting their changes merged. I see no activity within the
kernel for ARM nommu since 2006. Given that xtensa has a need for this in
its nommu port and people are working on it presently, there certainly
has to be a limit to how far we go in allowing an outdated and
effectively abandoned port from blocking progress. Perhaps Russell has a
more optimistic outlook on the future of ARM nommu, though.

The only architectures in that list presently active in the linux nommu
space in terms of development, support, and shipping products, are
blackfin, m68k, and sh. This too has been the case for years. Microblaze
has recently been added (which will also need the same change to its
flat.h), and it seems the xtensa folks are at least presently willing to
do more than the bare minimum to keep their port limping along.
