Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbXKAJCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbXKAJCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXKAJB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:01:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51341 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbXKAJB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:01:56 -0400
Date: Thu, 1 Nov 2007 10:01:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
	CONFIG_VIDEO_SAA7146_VV=y
Message-ID: <20071101090142.GA13009@elte.hu>
References: <20071026073736.GA24172@elte.hu> <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net>
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

> On Fri, 26 Oct 2007, Ingo Molnar wrote:
> > the attached config (generated via make randconfig) fails to build due
> > to the combination of these config entries:
> >
> >   CONFIG_VIDEO_DEV=m
> >   CONFIG_VIDEO_SAA7146_VV=y
> >
> > i found no obvious Kconfig way to force VIDEO_SAA7146_VV to be modular
> > when VIDEO_DEV is modular - is there a good solution for this?
> 
> I guess you didn't like my reply to your first message about this?
> 
> http://lkml.org/lkml/2007/10/7/145
> 
> kbuild support for modules used as libraries is really poor.  The only 
> way to do is use select on the library module, and then have all the 
> dependencies of the selectee be included in the selector, which must 
> be done recursively so that any modules selected by the selectee have 
> their dependencies added to the selector.

any patch for me to try? This bug is blocking automated randconfig 
build-testing quite frequently so it's quite a showstopper.

	Ingo
