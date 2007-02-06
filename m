Return-Path: <linux-kernel-owner+w=401wt.eu-S965416AbXBFUkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416AbXBFUkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXBFUkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:40:40 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:61746 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965416AbXBFUkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:40:39 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1170793206.3785.16.camel@chaos>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1>  <1170793206.3785.16.camel@chaos>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 12:40:37 -0800
Message-Id: <1170794437.3455.20.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 21:20 +0100, Thomas Gleixner wrote:
> On Tue, 2007-02-06 at 11:55 -0800, Daniel Walker wrote:
> > > What kind of artificial problem are you creating here ?
> >
> > I'm not trying to create anything .. However, as I said before
> > the /proc/interrupts "timer" entry doesn't work the same as it has in
> > other kernels.
> 
> Yes, it is different. Why are you insisting, that something is a problem
> just because it is different ?

In this case "different" goes into userspace .. So different could mean
userspace regression, which is something that we don't want. I have no
idea if any apps use /proc/interrupts , but it's possible since it's
been around for a long time.

The reason that I'm bringing it up at all is because people have ask me
"Why isn't my timer ticking??"

> > > > We could just remove the timer entry .
> > > 
> > > No we can't. The timer interrupt is setup and it does not go away, as we
> > > keep the PIT as a backup for the broken lapics.
> > 
> > Ok, how about adding the interrupts to the list which are driving the
> > timer ?
> 
> Uurg. /proc/interrupts has nothing to do with timers. It's interrupts
> statistics. See LOC entry for the lapic ones.

Your saying we can't remove it tho, if /proc/interrupts is not related
to timers why does the entry exist at all ? Your saying the LOC entry is
the new "timer" entry, but we still have the old "timer" entry ..

Getting confusing ..

It might be nicer to list all the registered clock event sources
in /proc/interrupts, with more descriptive names .. 

Why is it that HRT doesn't use the "timer" as a valid timer?

Daniel

