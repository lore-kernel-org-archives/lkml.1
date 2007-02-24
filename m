Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbXBXTxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbXBXTxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 14:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933550AbXBXTxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 14:53:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933549AbXBXTxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 14:53:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.19: ACPI reports AC not present after resume from STD
Date: Sat, 24 Feb 2007 20:46:18 +0100
User-Agent: KMail/1.9.5
Cc: "Lebedev, Vladimir P" <vladimir.p.lebedev@intel.com>,
       "Karasyov, Konstantin A" <konstantin.a.karasyov@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org
References: <8E389A5F2FEABA4CB1DEC35A25CB39CE82FE9F@mssmsx411> <200702132116.05404.arvidjaar@mail.ru> <200702241255.02073.arvidjaar@mail.ru>
In-Reply-To: <200702241255.02073.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702242046.20216.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, 24 February 2007 10:55, Andrey Borzenkov wrote:
> On Вторник 13 февраля 2007, Andrey Borzenkov wrote:
> > On Четверг 07 декабря 2006, Lebedev, Vladimir P wrote:
> > > Please register new bug, attach acpidump and dmesg.
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=7995
> >
> > regards
> >
> 
> Well, this starts looking like ACPI is not at fault.
> 
> When reporting AC state ACPI just reads contents of system memory (I presume
> it gets updated by BIOS/ACPI when AC state changes). It looks like this
> memory area is restored during resume from STD. I updated mentioned bug
> report with more detailed description. Now if someone could suggest a way to
> catch if specific physical address gets saved/restored this would finally
> explain it.

First, if you want the reserved memory areas to be left alone by swsusp,
you need to mark them as 'nosave'.  On x86_64 this is done by the function
e820_mark_nosave_range() in arch/x86_64/kernel/e820.c that can be ported to
i386 with no problems.  However, we haven't found that very useful, so far,
since no one has ever reported any problems with the current approach,
which is to save and restore them.

Second, if you want to know if a suspicious page frame is saved by swsusp,
it's best to stick a test and a printk in kernel/power/pack_pfns() and
artificially fail the suspend, eg. by making swsusp_write() always return
an error.

> Gratefully waiting for patches to test :)

Sorry, no patches this time.  I have more urgent problem to fix. :-)

Greetings,
Rafael


> > > -----Original Message-----
> > > From: Alexey Starikovskiy [mailto:alexey.y.starikovskiy@linux.intel.com]
> > >
> > > Sent: Thursday, December 07, 2006 10:49 PM
> > > To: Rafael J. Wysocki
> > > Cc: Karasyov, Konstantin A; Andrey Borzenkov;
> > > linux-acpi@vger.kernel.org; Lebedev, Vladimir P
> > > Subject: Re: 2.6.19: ACPI reports AC not present after resume from STD
> > >
> > > Rafael J. Wysocki wrote:
> > > > Hi,
> > > >
> > > > On Thursday, 7 December 2006 19:57, Karasyov, Konstantin A wrote:
> > > >> Hi,
> > > >>
> > > >> Unfortunately, I cannot reproduce this bug on my system, but the
> > >
> > > problem
> > >
> > > >> could be solved by adding a resume handler for AC adapter device.
> > >
> > > Could
> > >
> > > >> you try the attached patch to see if it helps.
> > > >
> > > > I can reproduce it and the patch doesn't help.
> > > >
> > > > Greetings,
> > > > Rafael
> > >
> > > Any ACPI errors in dmesg?
> > >
> > > Regards,
> > >     Alex.
> 
> 
> 
> 

-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
