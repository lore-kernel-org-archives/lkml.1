Return-Path: <linux-kernel-owner+w=401wt.eu-S933531AbXIKJCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbXIKJCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932272AbXIKJB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:01:59 -0400
Received: from www.osadl.org ([213.239.205.134]:47235 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932280AbXIKJB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:01:59 -0400
Subject: Re: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070911012005.4df3ddf4.akpm@linux-foundation.org>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	 <20070910144740.4eba2fda.akpm@linux-foundation.org>
	 <1189492636.25767.62.camel@chaos>
	 <20070911000001.30f8590b.akpm@linux-foundation.org>
	 <1189495400.25767.81.camel@chaos> <1189496840.22589.1.camel@chaos>
	 <20070911012005.4df3ddf4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 11:01:54 +0200
Message-Id: <1189501314.6262.4.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 01:20 -0700, Andrew Morton wrote:
> On Tue, 11 Sep 2007 09:47:20 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Tue, 2007-09-11 at 09:23 +0200, Thomas Gleixner wrote:
> > > > I went back to the original patch which I sent to Linus and it matches
> > > > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> > > > must have been something else in the tree which I tested which fixed the
> > > > bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> > > > 
> > > > Can you think what would cause the symptoms which I described?  
> > > 
> > > It seems that time is not updated. Timer interrupt not active or some
> > > other odd thing. I figure out what's going on when I find a box which
> > > exposes the problem.
> 
> 2.6.22-rc6-mm1's git-acpi.patch contains something which fixes this bug. 
> It's a quarter megabyte :( Presumably clockevents-fix-resume-logic.patch
> depended on something which was in that git-acpi.patch but which for some
> reason didn't get merged.  Ho hum, I'll take a look, see if I can spot it.
> 
> > Can you please try the following command line options:
> > 
> > nolapic_timer
> 
> Works
> 
> > nohz=off
> 
> Fails
> 
> 
> > highres=off
> 
> Fails
> 
> > nohz=off highres=off
> 
> Works

Ah. Adding your observation of the missing bit from the acpi stuff, I
think this must be related to the broadcast functionality.

Btw, 23-rc6 does not resume the Intel Video card on one of my laptops.
Sigh !

	tglx


