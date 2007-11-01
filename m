Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXKAJkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXKAJkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbXKAJkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:40:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56767 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXKAJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:40:30 -0400
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
	CONFIG_VIDEO_SAA7146_VV=y
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>
In-Reply-To: <20071101090142.GA13009@elte.hu>
References: <20071026073736.GA24172@elte.hu>
	 <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net>
	 <20071101090142.GA13009@elte.hu>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 07:40:13 -0200
Message-Id: <1193910013.8587.28.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.1-1mdv2008.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Qui, 2007-11-01 at 10:01 +0100, Ingo Molnar wrote:
> * Trent Piepho <xyzzy@speakeasy.org> wrote:
> 
> > On Fri, 26 Oct 2007, Ingo Molnar wrote:
> > > the attached config (generated via make randconfig) fails to build due
> > > to the combination of these config entries:
> > >
> > >   CONFIG_VIDEO_DEV=m
> > >   CONFIG_VIDEO_SAA7146_VV=y
> > >
> > > i found no obvious Kconfig way to force VIDEO_SAA7146_VV to be modular
> > > when VIDEO_DEV is modular - is there a good solution for this?
> > 
> > I guess you didn't like my reply to your first message about this?
> > 
> > http://lkml.org/lkml/2007/10/7/145
> > 
> > kbuild support for modules used as libraries is really poor.  The only 
> > way to do is use select on the library module, and then have all the 
> > dependencies of the selectee be included in the selector, which must 
> > be done recursively so that any modules selected by the selectee have 
> > their dependencies added to the selector.
> 
> any patch for me to try? This bug is blocking automated randconfig 
> build-testing quite frequently so it's quite a showstopper.

Trent generated a patch for it. I'll update it soon my -git. You should
notice that there were one change at av7110 that need to be applied
before Trent's patch, otherwise the saa7146 stuff will be broken if V4L1
is not selected.

-- 
Cheers,
Mauro

