Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYBSOR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYBSOR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbYBSORG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:17:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52618 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbYBSORD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:17:03 -0500
Date: Tue, 19 Feb 2008 11:16:40 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
Message-ID: <20080219111640.409870a9@gaivota>
In-Reply-To: <200802190121.36280.bonganilinux@mweb.co.za>
References: <200802171036.19619.bonganilinux@mweb.co.za>
 <20080218131125.2857f7c7@gaivota>
 <200802182320.40732.bonganilinux@mweb.co.za>
 <200802190121.36280.bonganilinux@mweb.co.za>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.7; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 01:21:36 +0200
Bongani Hlope <bonganilinux@mweb.co.za> wrote:

> On Monday 18 February 2008 23:20:40 Bongani Hlope wrote:
> > On Monday 18 February 2008 18:11:25 Mauro Carvalho Chehab wrote:
> > > Have you tested Robert's patch?
> >
> > Sorry almost forgot, I have and it fixes the TV but not the radio.
> >
> > > I can't see anything wrong on bttv_g_tuner lock. I suspect that the
> > > divide error caused some bad effects at some data on bttv.
> >
> >  The problems don't seem related because one is caused by opening the
> > "radio" application, the divide error is caused by using a TV viewing
> > application (I tried fbtv)
> >
> > > I've already applied his fix to my -git tree:
> >
> > Thanx, I'll try to bisect
> 
> I tried to bisect but the V4L/DVB changes are not bisect friendly, on two 
> occursions I just selected "git bisect bad" because the bttv driver wouldn't 
> compile, so I couldn't pin-point what causes the oops and hang.
> 
> Here are some few observations I made though (I started bisecting between 
> 2.6.24 and 2.6.25-rc1, saved me ~1000 commits):
> 1. On the third bisect, there's no oops my PC just hangs a I can't use any 
> open terminals
> 2. When I reached the V4L/DVB changes, my PC did not hag or oops, the radio 
> just didn't work (something about invalid VID**AUD**). This made it harder to 
> bisect, because it is not working and not breaking so is it good or bad...

Bisecting this won't be that easy. The support for the depreciated V4L1 API
were removed from bttv driver. Now, it uses v4l1-compat module, that translates
a V4L1 call into a V4L2 one. I'll try to seek for troubles at the current code.


Cheers,
Mauro
