Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbXIYOEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbXIYOEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbXIYOEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:04:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34753 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbXIYOEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:04:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Date: Tue, 25 Sep 2007 16:18:05 +0200
User-Agent: KMail/1.9.5
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Damien Wyart <damien.wyart@free.fr>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
References: <20070925065109.GA3080@localhost.localdomain> <200709251525.11752.rjw@sisk.pl> <46F909E0.4020000@suse.de>
In-Reply-To: <46F909E0.4020000@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251618.06064.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 September 2007 15:15, Alexey Starikovskiy wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday, 25 September 2007 14:53, Alexey Starikovskiy wrote:
> >> Rafael J. Wysocki wrote:
> >>> On Tuesday, 25 September 2007 14:05, Alexey Starikovskiy wrote:
> >>>> Rafael J. Wysocki wrote:
> >>>>> On Tuesday, 25 September 2007 13:45, Rafael J. Wysocki wrote:
> >>>>>> On Tuesday, 25 September 2007 11:58, Damien Wyart wrote:
> >>>>>>>>> No, I do not have CONFIG_ACPI_SLEEP set,
> >>>>>>>>> because I do not have CONFIG_PM_SLEEP set,
> >>>>>>>>> because I do not want SUSPEND and/or HIBERNATION.
> >>>>>>>> Same answer from my side: I do not have CONFIG_ACPI_SLEEP for the same
> >>>>>>>> reason (and this worked fine without them in rc7). I do not think
> >>>>>>>> these settings should have changed between rc7 and rc8.
> >>>>>> Well, we haven't changed much.
> >>>>>>
> >>>>>>> Also, another test I just did: on another computer, rc8 is fine
> >>>>>>> regarding ACPI power off, even if CONFIG_ACPI_SLEEP is not set. I can
> >>>>>>> provide config if needed.
> >>>>>> On the box that fails to power off, can you please test -rc8 with these two
> >>>>>> commits reverted:
> >>>>>>
> >>>>>> commit 5a50fe709d527f31169263e36601dd83446d5744
> >>>>>> ACPI: suspend: consolidate handling of Sx states addendum
> >>>>>>
> >>>>>> commit f216cc3748a3a22c2b99390fddcdafa0583791a2
> >>>>>> ACPI: suspend: consolidate handling of Sx states.
> >>>>>>
> >>>>>> and see if it works?
> >>>>> If it does, please test the patch from this message
> >>>>>
> >>>>> http://marc.info/?l=linux-kernel&m=119052978117735&w=4
> >>>>>
> >>>>> on top of vanilla 2.6.23-rc8.
> >>>> You will need one more patch on top of just mentioned one.
> >>> Hm, why did you put acpi_target_sleep_state under CONFIG_SUSPEND?
> >>>
> >>> CONFIG_HIBERNATION needs acpi_target_sleep_state  too.
> >> Agree, attaching updated patch.
> > 
> > Well, please use "ifdef CONFIG_PM_SLEEP" instead of
> > "if defined(CONFIG_SUSPEND)||defined(CONFIG_HIBERNATION)",
> > as you did with the second block.
> I was thinking about that, but it seem to be less clear... 
> We need this variable only for suspend or hibernation, nothing else.
> with pm_sleep it is not visible at all.
> 
> Thoughts?

Well, PM_SLEEP is defined as (SUSPEND || HIBERNATION), please have a look
at kernel/power/Kconfig, and it was introduced exactly for the conditions like
this.

IOW, if we want something to be used for anything else than suspend or
hibernation, it shouldn't be defined under PM_SLEEP.

Greetings,
Rafael
