Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZFICeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZFICeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 22:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbZFICdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 22:33:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757591AbZFICdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 22:33:53 -0400
Date: Mon, 8 Jun 2009 19:33:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v3] printk: add halt_delay parameter for printk delay in
  halt phase
Message-Id: <20090608193341.07e94b79.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0906081801j7169bec1ja1242dcea1aaba7d@mail.gmail.com>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
	<20090608081439.GB6372@elte.hu>
	<20090608012845.9c428525.akpm@linux-foundation.org>
	<a8e1da0906080142u62a45c47g2181a79addfb6168@mail.gmail.com>
	<20090608084807.GE6372@elte.hu>
	<20090608092607.8b331bf0.akpm@linux-foundation.org>
	<20090608171501.GA15399@elte.hu>
	<20090608143913.749e19c5.akpm@linux-foundation.org>
	<a8e1da0906081801j7169bec1ja1242dcea1aaba7d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 09:01:19 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> On Tue, Jun 9, 2009 at 5:39 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> > On Mon, 8 Jun 2009 19:15:01 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> > questions: is it possible for interrupts to be disabled at this
> >> > time? If so, can we get an NMI watchdog hit?
> >>
> >> no, we generally turn off the nmi watchdog during shutdown, disable
> >> the lapic and io-apic, etc.
> >
> > Is x86 the only architecture which implements an NMI watchdog?
> >
> >> > Is the softlockup detector still running and if so, can it
> >> > trigger?
> >>
> >> in (non-emergency) reboot, last i checked, we stopped all other CPUs
> >> first, and then killed the current one. There's no chance for the
> >> watchdog thread to run.
> >
> > OK, but... __See below.
> >
> >> Anyway ... you seem to be uncomfortable about this patch - should i
> >> delay it for now to let it all play out? We are close to the merge
> >> window.
> >
> > I'm OK - I'm just bouncing ideas and questions off you guys, to make sure
> > that we've thought this through all the way.
> >
> > Here's another: why is it a boot option rather than a runtime-tunable?
> > A /proc tweakable is generally preferable because it avoids the
> > oh-crap-i-forgot-to-edit-grub.conf thing. __And we could perhaps then
> > remove all those system_state tests: userspace sets printk_delay
> > immediately prior to running halt/reboot/etc?
> 
> Andrew, thanks your comments.
> I original intention is to use not boot options but sysfs interface.
> Do you perfer proc?

sysfs is OK, if there's a logical place for it.  /sys/kernel/, I suppose.

> without system_state testing we will have to consider the NMI watchdog
> and softlockup issue.

Yup.


