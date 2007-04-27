Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbXD0Cwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbXD0Cwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbXD0Cwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:52:32 -0400
Received: from aeimail.aei.ca ([206.123.6.84]:35701 "EHLO aeimail.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXD0Cwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:52:31 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [REPORT] First "glitch1" results, 2.6.21-rc7-git6-CFSv5 + SD  0.46
Date: Thu, 26 Apr 2007 22:52:17 -0400
User-Agent: KMail/1.9.5
Cc: Bill Davidsen <davidsen@tmr.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <462D2BDD.4040406@tmr.com> <46312116.1030506@tmr.com> <200704270856.17210.kernel@kolivas.org>
In-Reply-To: <200704270856.17210.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704262252.17963.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 18:56, Con Kolivas wrote:
> On Friday 27 April 2007 08:00, Bill Davidsen wrote:
> > Ingo Molnar wrote:
> > > * Ed Tomlinson <edt@aei.ca> wrote:
> > >>> SD 0.46		1-2 FPS
> > >>> cfs v5 nice -19	219-233 FPS
> > >>> cfs v5 nice 0 	1000-1996
> > >>
> > >>    cfs v5 nice -10  60-65 FPS
> > >
> > > the problem is, the glxgears portion of this test is an _inverse_
> > > testcase.
> > >
> > > The reason? glxgears on true 3D hardware will _not_ use X, it will
> > > directly use the 3D driver of the kernel. So by renicing X to -19 you
> > > give the xterms more chance to show stuff - the performance of the
> > > glxgears will 'degrade' - but that is what you asked for: glxgears is
> > > 'just another CPU hog' that competes with X, it's not a "true" X client.
> > >
> > > if you are after glxgears performance in this test then you'll get the
> > > best performance out of this by renicing X to +19 or even SCHED_BATCH.
> >
> > Several points on this...
> >
> > First, I don't think this is accelerated in the way you mean, the
> > machine is a test server, with motherboard video using the 945G video
> > driver. Given the limitations of the support in that setup, I don't
> > think it qualified as "true 3D hardware," although I guess I could try
> > using the vesafb version as a test.
> >
> > The 2nd thing I note is that on FC6 this scheduler seems to confuse
> > 'top' to some degree, since the glxgears is shown as taking 51% of the
> > CPU (one core), while the state breakdown shows about 73% in idle,
> > waitio, and int. image attached.
> 
> top by itself certainly cannot be trusted to give true representation of the 
> cpu usage I'm afraid. It's not as convoluted as, say, trying to track memory 
> usage of an application, but top's resolution being tied to HZ accounting 
> makes it not reliable in that regard.
> >
> > After I upgrade the kernel and cfs to the absolute latest I'll repeat
> > this, as well as test with vesafb, and my planned run under heavy load.
> 
> I have a problem with your test case Bill. Its behaviour would depend on how 
> gpu bound vs cpu bound vs accelerated vs non-accelerated your graphics card 
> is. I get completely different results to those of the other testers given 
> the different hardware configuration and I don't think my results are 
> valuable. My problem with this testcase is - What would you define 
> as "perfect" behaviour for your test case? It seems far too arbitrary.

Con,

One thing I did not mention in all this is that renicing the glxgears process to -10
gets SD to give about 1000FPS, indeed you get most of this performance at -5 too.
All in all SD does a very good job here.

Get well soon!
Ed
