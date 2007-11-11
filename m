Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbXKKSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbXKKSxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbXKKSxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:53:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34857 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbXKKSxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:53:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
Date: Sun, 11 Nov 2007 20:10:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <200711052201.17150.arvidjaar@mail.ru> <200711111927.26540.rjw@sisk.pl> <200711112148.23133.arvidjaar@mail.ru>
In-Reply-To: <200711112148.23133.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711112010.24874.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 of November 2007, Andrey Borzenkov wrote:
> On Sunday 11 November 2007, Rafael J. Wysocki wrote:
> > On Sunday, 11 of November 2007, Andrey Borzenkov wrote:
> > > On Monday 05 November 2007, Andrey Borzenkov wrote:
> > > > Notice "hung" not "hangs". This happened so far only once - when low battery 
> > > > condition triggered suspend to disk. I was not able to reproduce it after 
> > > > this running on AC.
> > > > 
> > > > Just in case it rings the bell for someone. This is not suspend regression 
> > > > reported earlier by Jens - I do not even have SATA nor is using libata 
> > > > drivers.
> > > > 
> > > 
> > > This happened second time, now with 2.6.24-rc2. I have kpowersave configured
> > > to initiate suspend-to-disk on low battery. Suspend-to-disk is initiated,
> > > but system stops after Suspending console line. Suspend image is not created.
> > > 
> > > This did work before although I do not name exact version.
> > > 
> > > I am rather at loss how to proceed further ... any idea? dmesg and config
> > > attached just in case. The problem is that hibernation works when I initiate
> > > it manually ...
> > 
> > Have you tried it with the battery removed?
> > 
> > 
> 
> It works. Subjectively I have relatively long pause after first Suspending console
> message (where it hangs otherwise), according to dmesg timestamp it is about
> 1 second before next messages appear. Also last two times I tried it writeout
> of suspend image was really slow; it was both with and without battery. Reading
> on resume in really in order of magnitude faster.
> 
> But manual STD so far works both on AC (with or without battery) or on battery.
> 
> Of course it is possible that battery gets exhausted during STD, but system
> is not switched off. Rather I would suspect something like ACPI notification
> that comes during freeze ...

Frankly, I'm suspecting a deadlock in the ACPI code.

Please try to make kpowersave start hibernation a bit earlier and see what
happens.

What's your critical time now?
