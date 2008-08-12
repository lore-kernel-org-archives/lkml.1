Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbYHLNKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbYHLNKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYHLNKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:10:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52306 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbYHLNKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:10:08 -0400
Date: Tue, 12 Aug 2008 16:08:23 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, fritz@isdn4linux.de, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [PATCH] ISDN: make ICN not auto-grab port 0x320
Message-ID: <20080812130823.GD13910@cs181140183.pp.htv.fi>
References: <489DD669.2090207@keyaccess.nl> <20080809215020.1bb602e7@lxorguk.ukuu.org.uk> <20080811164814.db41c20b.akpm@linux-foundation.org> <48A11952.6090203@keyaccess.nl> <20080811223043.9ad55c51.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080811223043.9ad55c51.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 10:30:43PM -0700, Andrew Morton wrote:
> On Tue, 12 Aug 2008 07:02:10 +0200 Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
> > On 12-08-08 01:48, Andrew Morton wrote:
> > 
> > > otoh it's a bit sad to break allyesconfig kernels - there is
> > > regression-testing value in being able to run such kernels.
> > > 
> > > I wonder if we can add a new boot option `allyesconfig-test' or
> > > something like that, and then, within the offending drivers, test that
> > > flag and take suitable avoiding action.
> > > 
> > > Or we could do it at compile-time - define
> > > CONFIG_ALLYESCONFIG_TESTING in some fashion.
> > 
> > Yes, latter I'd feel with the thing most against it that there aren't 
> > actually many that need it.
> 
> I think the boot option is the way, if at all.
> 
> Because the config option isn't very usable.  What's to stop someone
> from doing `make allyesconfig' and then menually editing the .config so
> it's no longer truly an allyesconfig .config?
> 
> otoh, if is't purely a manual setting rather than some automagic thing
> then it might be workable.  CONFIG_INGO :)

Write the required settings into a file and use KCONFIG_ALLCONFIG.

Our kconfig files are already complicated enough, and needlessly adding 
more complexity only increases the problems (which would in turn result 
in this Hungarian guy spreading his kconfig FUD even more often).

Tomorrow someone might want to boot an allyesconfig kernel on an old
Pentium-MMX, and the CONFIG_M686=y allyesconfig gives might break his 
boot - another special case in kconfig for an even more exotic use case?

Everyone doing randconfig builds knows that CONFIG_STANDALONE=n is not a 
good idea, and similarly someone trying to boot allyesconfig kernels 
might need a list of options he mustn't enable.

After all, we are not talking about stuff for normal users.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

