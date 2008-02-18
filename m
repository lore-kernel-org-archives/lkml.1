Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbYBRXVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbYBRXVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYBRXVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:21:45 -0500
Received: from mail-09.jhb.wbs.co.za ([196.2.97.6]:22098 "EHLO
	mail-09.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYBRXVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:21:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAKqhuUfEAmHFlWdsb2JhbACQVQEBAQEHChEYnBI
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
Date: Tue, 19 Feb 2008 01:21:36 +0200
User-Agent: KMail/1.9.8
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <200802171036.19619.bonganilinux@mweb.co.za> <20080218131125.2857f7c7@gaivota> <200802182320.40732.bonganilinux@mweb.co.za>
In-Reply-To: <200802182320.40732.bonganilinux@mweb.co.za>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802190121.36280.bonganilinux@mweb.co.za>
X-Original-Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
X-Spam-Score: 0.1 (/)
X-Spam-Score-Int: 1
X-Spam-Report: Spam detection software, running on the system "wbs-smtp-out-02.jhb.wbs.co.za", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	Postmaster for details.
	Content preview:  On Monday 18 February 2008 23:20:40 Bongani Hlope wrote: >
	On Monday 18 February 2008 18:11:25 Mauro Carvalho Chehab wrote: > > Have
	you tested Robert's patch? > > Sorry almost forgot, I have and it fixes the
	TV but not the radio. > > > I can't see anything wrong on bttv_g_tuner lock.
	I suspect that the > > divide error caused some bad effects at some data
	on bttv. > > The problems don't seem related because one is caused by opening
	the > "radio" application, the divide error is caused by using a TV viewing
	> application (I tried fbtv) > > > I've already applied his fix to my -git
	tree: > > Thanx, I'll try to bisect [...] 
	Content analysis details:   (0.1 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	0.1 RDNS_DYNAMIC           Delivered to trusted network by host with
	dynamic-looking rDNS
X-Scan-Signature: eba1db0d6422c21c22a9aa66e327e6ef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008 23:20:40 Bongani Hlope wrote:
> On Monday 18 February 2008 18:11:25 Mauro Carvalho Chehab wrote:
> > Have you tested Robert's patch?
>
> Sorry almost forgot, I have and it fixes the TV but not the radio.
>
> > I can't see anything wrong on bttv_g_tuner lock. I suspect that the
> > divide error caused some bad effects at some data on bttv.
>
>  The problems don't seem related because one is caused by opening the
> "radio" application, the divide error is caused by using a TV viewing
> application (I tried fbtv)
>
> > I've already applied his fix to my -git tree:
>
> Thanx, I'll try to bisect

I tried to bisect but the V4L/DVB changes are not bisect friendly, on two 
occursions I just selected "git bisect bad" because the bttv driver wouldn't 
compile, so I couldn't pin-point what causes the oops and hang.

Here are some few observations I made though (I started bisecting between 
2.6.24 and 2.6.25-rc1, saved me ~1000 commits):
1. On the third bisect, there's no oops my PC just hangs a I can't use any 
open terminals
2. When I reached the V4L/DVB changes, my PC did not hag or oops, the radio 
just didn't work (something about invalid VID**AUD**). This made it harder to 
bisect, because it is not working and not breaking so is it good or bad...

Cheers
