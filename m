Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYFLT1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYFLT1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbYFLT1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:27:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755537AbYFLT1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:27:19 -0400
Date: Thu, 12 Jun 2008 12:27:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: g.liakhovetski@gmx.de, linux-kernel@vger.kernel.org
Subject: Re: [WARNING] local_bh_enable with irqs disabled:
Message-Id: <20080612122708.eb7c1837.akpm@linux-foundation.org>
In-Reply-To: <200806121200.03424.david-b@pacbell.net>
References: <Pine.LNX.4.64.0806031529520.21106@axis700.grange>
	<Pine.LNX.4.64.0806060751240.14536@axis700.grange>
	<20080605234136.189895a5.akpm@linux-foundation.org>
	<200806121200.03424.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 12:00:03 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 05 June 2008, you wrote:
> > On Fri, 6 Jun 2008 08:11:23 +0200 (CEST) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > 
> > > > Which kernel version are you running?
> > > 
> > > Sorry, this was a 2.6.26-rc3 based kernel with the gpio-sysfs patch from 
> > > David, e.g., http://marc.info/?l=linux-kernel&m=121107105300923&w=2,
> > > which introduces a call to device_unregister via gpiochip_unexport(chip); 
> > > in gpiochip_remove. 
> > 
> > OK, thanks.
> > 
> > That's quite buggy and would have generated so many runtime warnings in
> > a "developer" setup (rofl) that I look at Documentation/SubmitChecklist
> > and just weep.
> > 
> > I'll drop it.
> 
> That seems excessive.  I observe a locking bug with a trivial fix;
> happened because *one* code path (rmmod -- not often used with GPIOs
> once they work) couldn't be tested on most of my test rigs.  It would
> produce *ONE* runtime warning on that code path.
> 
> Other than missing one test case, the only other significant issue
> from SubmitChecklist is that the Documentation/ABI update needs to
> hold up until this merges to mainline, since one part of it includes
> the date where that interface became available.
> 
> So ... what else were you thinking was trouble?
> 

The patch had a great string of sysfs operations and mutex-takings all
happening under spinlock.  Obviously all that code hadn't been tested.
I didn't take the time to sit down and analyse where it was all happening.
