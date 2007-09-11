Return-Path: <linux-kernel-owner+w=401wt.eu-S1763165AbXIKKc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763165AbXIKKc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbXIKKcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:32:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbXIKKcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:32:18 -0400
Date: Tue, 11 Sep 2007 03:31:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070911033106.91e240df.akpm@linux-foundation.org>
In-Reply-To: <1189502164.6262.7.camel@chaos>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<20070910144740.4eba2fda.akpm@linux-foundation.org>
	<1189492636.25767.62.camel@chaos>
	<20070911000001.30f8590b.akpm@linux-foundation.org>
	<1189495400.25767.81.camel@chaos>
	<1189496840.22589.1.camel@chaos>
	<20070911012005.4df3ddf4.akpm@linux-foundation.org>
	<20070911013512.8d62220e.akpm@linux-foundation.org>
	<1189502164.6262.7.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 11:16:04 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 2007-09-11 at 01:35 -0700, Andrew Morton wrote:
> > On Tue, 11 Sep 2007 01:20:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Tue, 11 Sep 2007 09:47:20 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > > On Tue, 2007-09-11 at 09:23 +0200, Thomas Gleixner wrote:
> > > > > > I went back to the original patch which I sent to Linus and it matches
> > > > > > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> > > > > > must have been something else in the tree which I tested which fixed the
> > > > > > bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> > > > > > 
> > > > > > Can you think what would cause the symptoms which I described?  
> > > > > 
> > > > > It seems that time is not updated. Timer interrupt not active or some
> > > > > other odd thing. I figure out what's going on when I find a box which
> > > > > exposes the problem.
> > > 
> > > 2.6.22-rc6-mm1's git-acpi.patch contains something which fixes this bug. 
> > 
> > Len's current tree fixes it too.  Maybe we just need to merge the acpi tree?
> 
> Did you enable CONFIG_CPU_IDLE after you applied git-acpi to rc6 ?
> 

Nope.

Anyway, I've had it.  git seems a bit weird when it's trying to bisect down
to a point where code started to work correctly, rather than finding when
it failed (I just reversed "good" and "bad").  The acpi tree is littered
with build errors at various points and I just don't know which patch fixed
it - git-bisect seems to keep turning up junk.

Ho hum.  Maybe tomorrow I'll have a go at turning the acpi tree into a
series of flat patches and do it sanely.

