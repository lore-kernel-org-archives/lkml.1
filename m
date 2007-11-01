Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbXKAKfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbXKAKfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbXKAKe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:34:56 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:49094 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXKAKez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:34:55 -0400
Date: Thu, 1 Nov 2007 03:34:54 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Ingo Molnar <mingo@elte.hu>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Johannes Stezenbach <js@linuxtv.org>
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &	CONFIG_VIDEO_SAA7146_VV=y
In-Reply-To: <20071101090142.GA13009@elte.hu>
Message-ID: <Pine.LNX.4.58.0711010304490.18400@shell2.speakeasy.net>
References: <20071026073736.GA24172@elte.hu> <Pine.LNX.4.58.0710310458150.19072@shell4.speakeasy.net>
 <20071101090142.GA13009@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Ingo Molnar wrote:
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

For some time now I've thought the whole ttpci config/makefile setup
sucked.  I've finally gone though and redone it and fixed this problem too.

Here is the patch:  http://linuxtv.org/hg/v4l-dvb/rev/5320c2571183

All the rest of the selectors of VIDEO_SAA7146_VV are in the V4L menu,
which contains the necessary dependency on VIDEO_DEV.

Of course the real fix here would be have kbuild not force us to manually
add all the recursive dependencies of a selected module to the dependencies
of the module that selects it.
