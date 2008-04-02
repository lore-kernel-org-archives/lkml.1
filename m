Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbYDBRqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbYDBRqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbYDBRp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:45:58 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:52776 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYDBRp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:45:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYCAL9i80fEAmHGgWdsb2JhbACRTwEBECaaJA
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
Date: Wed, 2 Apr 2008 19:14:13 +0200
User-Agent: KMail/1.9.9
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Morton <akpm@google.com>
References: <20080330162006.GA6048@joi> <20080401171051.724a9f75@gaivota>
In-Reply-To: <20080401171051.724a9f75@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021914.13378.bonganilinux@mweb.co.za>
X-Original-Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
X-Spam-Score: 1.0 (+)
X-Spam-Score-Int: 10
X-Spam-Report: Spam detection software, running on the system "wbs-smtp-out-03.jhb.wbs.co.za", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	Postmaster for details.
	Content preview:  On Tuesday 01 April 2008 22:10:51 Mauro Carvalho Chehab wrote:
	> Hi Marcin > > On Sun, 30 Mar 2008 18:20:49 +0200 > > Marcin Slusarz <marcin.slusarz@gmail.com>
	wrote: > > Hi > > 2.6.25-rc7 kernel oopses on exec of "radio -c /dev/radio0".
	> > I bisected it down to: > > > > 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b
	is first bad commit > > commit 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b >
	> Author: Douglas Schilling Landgraf <dougsland@gmail.com> > > Date: Thu
	Dec 27 22:20:58 2007 -0300 > > > > V4L/DVB (6911): Converted bttv to use video_ioctl2
	> > > > Signed-off-by: Douglas Schilling Landgraf <dougsland@gmail.com> >
	> Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org> > > There
	are three patches that are meant to fix the bugs with radio. On the > tests
	I did here, they worked, but the Bongani still points that the fixes > didn't
	solve for him. > [...] 
	Content analysis details:   (1.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	0.1 RDNS_DYNAMIC           Delivered to trusted network by host with
	dynamic-looking rDNS
	0.9 AWL                    AWL: From: address is in the auto white-list
X-Scan-Signature: 6ce92838431613e5217205b064541735
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 22:10:51 Mauro Carvalho Chehab wrote:
> Hi Marcin
>
> On Sun, 30 Mar 2008 18:20:49 +0200
>
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > Hi
> > 2.6.25-rc7 kernel oopses on exec of "radio -c /dev/radio0".
> > I bisected it down to:
> >
> > 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b is first bad commit
> > commit 402aa76aa5e57801b4db5ccf8c7beea9f580bb1b
> > Author: Douglas Schilling Landgraf <dougsland@gmail.com>
> > Date:   Thu Dec 27 22:20:58 2007 -0300
> >
> >     V4L/DVB (6911): Converted bttv to use video_ioctl2
> >
> >     Signed-off-by: Douglas Schilling Landgraf <dougsland@gmail.com>
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>
> There are three patches that are meant to fix the bugs with radio. On the
> tests I did here, they worked, but the Bongani still points that the fixes
> didn't solve for him.
>

I decoded the oops that I got and found that the cause was the 
miss-application of  Robert Fitzsimons' patch. On the git version that I had, 
the radio_release function was not on the lines on that patch (I just saw 
the .rej file ;)

> On the tests I did here, the three patches seemed to work [1]. Maybe you
> could test with those patches and post us some results.
>

Those patches brings back both the TV and radio functionality, the tv 
functionality loss seem to have been lost when radio_release oopsed and 
didn't decrement btv->radio_user

> There are three patches meant to fix several issues caused by the
> conversion:
>
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;
>h=bdd38d9b5c6365ea004df6d8a183dd1344b4801f
> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;
>h=055a6282cabd311cf010a5a83f0494558504f7d0

These two above fixed it for me too

> http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;
>h=6e07ff78274752fe812a1e8bddb6013a278e62e8
>

I can't comment on this one since I don't use 32bit user-space

> Could you test please and give us some feedback?
>

I confirm that those patches fixed the bttv-driver for me, it was the 
misapplied patch that caused the Oops. Please push to Linus and I'll ask 
Rafael to close the bug as soon as it gets to mainline.

Thanx for all your work Mauro and the V4L developers.

