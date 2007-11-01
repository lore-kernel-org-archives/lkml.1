Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbXKAK6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbXKAK6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbXKAK6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:58:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38151 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064AbXKAK6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:58:04 -0400
Date: Thu, 1 Nov 2007 11:57:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
	CONFIG_VIDEO_SAA7146_VV=y
Message-ID: <20071101105738.GB28701@elte.hu>
References: <20071026073736.GA24172@elte.hu> <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net> <20071101090142.GA13009@elte.hu> <Pine.LNX.4.58.0711010304490.18400@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0711010304490.18400@shell2.speakeasy.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Trent Piepho <xyzzy@speakeasy.org> wrote:

> All the rest of the selectors of VIDEO_SAA7146_VV are in the V4L menu, 
> which contains the necessary dependency on VIDEO_DEV.
> 
> Of course the real fix here would be have kbuild not force us to 
> manually add all the recursive dependencies of a selected module to 
> the dependencies of the module that selects it.

very much agreed. We should not be forced to put in redundant 
information that Kconfig could figure out by itself. (The only 
constraint is that we must not create circular dependencies - but 
Kconfig is checking that already.)

> On Thu, 1 Nov 2007, Ingo Molnar wrote:
> > * Trent Piepho <xyzzy@speakeasy.org> wrote:
> >
> > > On Fri, 26 Oct 2007, Ingo Molnar wrote:
> > > > the attached config (generated via make randconfig) fails to build due
> > > > to the combination of these config entries:
> > > >
> > > >   CONFIG_VIDEO_DEV=m
> > > >   CONFIG_VIDEO_SAA7146_VV=y
> > > >
> > > > i found no obvious Kconfig way to force VIDEO_SAA7146_VV to be modular
> > > > when VIDEO_DEV is modular - is there a good solution for this?
> > >
> > > I guess you didn't like my reply to your first message about this?
> > >
> > > http://lkml.org/lkml/2007/10/7/145
> > >
> > > kbuild support for modules used as libraries is really poor.  The only
> > > way to do is use select on the library module, and then have all the
> > > dependencies of the selectee be included in the selector, which must
> > > be done recursively so that any modules selected by the selectee have
> > > their dependencies added to the selector.
> >
> > any patch for me to try? This bug is blocking automated randconfig
> > build-testing quite frequently so it's quite a showstopper.
> 
> For some time now I've thought the whole ttpci config/makefile setup 
> sucked.  I've finally gone though and redone it and fixed this problem 
> too.
> 
> Here is the patch: http://linuxtv.org/hg/v4l-dvb/rev/5320c2571183

the drivers/media/dvb/ttpci/Kconfig bits do not apply:

 $ q push
 Applying patch patches/dvb-fix-5320c2571183.patch
 patching file drivers/media/common/Kconfig
 patching file drivers/media/dvb/ttpci/Kconfig
 Hunk #1 FAILED at 1.
 Hunk #2 FAILED at 63.
 Hunk #4 FAILED at 99.
 Hunk #5 FAILED at 120.
 Hunk #6 FAILED at 142.
 5 out of 6 hunks FAILED -- rejects in file 
 drivers/media/dvb/ttpci/Kconfig
 patching file drivers/media/dvb/ttpci/Makefile
 Patch patches/dvb-fix-5320c2571183.patch does not apply (enforce with -f)

got a link to the dependent patch that i'm apparently missing?

	Ingo
