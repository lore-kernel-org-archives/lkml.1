Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbXIWBeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbXIWBeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXIWBeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:34:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:26184 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbXIWBeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CrEZcjdHf1W5HAIuDSkJrqDJbGeakNEM/ul2IlaPd+CHb+6J3yTXPTSflKuLiNuMkpVkWhzPsZRISXgpqUJY6MeWJPHeBvxt/bHrV0+b0MrbgBJ3n3Fqr5rX26YhhViSyZRYIuAy29YsSssDFgl0QcGkHBDtxjFJ9Wz7R3+Iixw=
Message-ID: <86802c440709221834j12b0c27fl5435f1279397687@mail.gmail.com>
Date: Sat, 22 Sep 2007 18:34:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PATCH] [9/50] i386: validate against ACPI motherboard resources
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <ak@suse.de>,
       rajesh.shah@intel.com, jbarnes@virtuousgeek.org, greg@kroah.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F588D7.2030109@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709221231.836138000@suse.de>
	 <20070921223207.7BBE71479D@wotan.suse.de>
	 <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>
	 <46F542A4.9080207@shaw.ca> <1190484117.4035.71.camel@chaos>
	 <46F56208.90208@shaw.ca>
	 <86802c440709221340h2cbbf423y239f399ab5da815d@mail.gmail.com>
	 <46F588D7.2030109@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/22/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Yinghai Lu wrote:
> > On 9/22/07, Robert Hancock <hancockr@shaw.ca> wrote:
> >> Thomas Gleixner wrote:
> >>> On Sat, 2007-09-22 at 10:28 -0600, Robert Hancock wrote:
> >>>> Yinghai Lu wrote:
> >>>>> No!
> >>>>>
> >>>>> MMCONFIG will not work with acpi=off any more.
> >>>> I don't think this is unreasonable. The ACPI MCFG table is how we are
> >>>> supposed to learn about the area in the first place. If we can't get the
> >>>> table location via an approved mechanism, and can't validate it doesn't
> >>>> overlap with another memory reservation or something, I really don't
> >>>> think we should be using it.
> >>> We all know how correct ACPI tables are. Specifications are nice,
> >>> reality tells a different story.
> >> MMCONFIG can't be used without ACPI in any case unless we know where the
> >>   table is using chipset-specific knowledge (i.e. reading the registers
> >> directly). Doing that without being told that this area is really
> >> intended to be used, via the ACPI table, is dangerous, i.e. we don't
> >> necessarily know if the MMCONFIG is broken on the platform in some way
> >> we can't detect.
> >
> > the BIOS get these info from the chipset too.
> > for AMD Fam 10h opteron, we can read that MSR for MMCONFIG base.
> >
> >>>> I don't think it's much of an issue anyway - the chances that somebody
> >>>> will want to run without ACPI on a system with MCFG are pretty low given
> >>>> that you'll end up losing a bunch of functionality (not least of which
> >>>> is multi-cores).
> >>> acpi=off is an often used debug switch and it _is_ quite useful. Taking
> >>> away debug functionality is not a good idea.
> >> If someone has to turn ACPI off, disabling MMCONFIG is probably the
> >> least of their worries..
> >
> > MMCONFIG has nothing to do ACPI..., just becase MCFG in the ACPI, we
> > must use ACPI for MMCONFIG?
>
> config PCI_MMCONFIG
>           bool
>           depends on PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
>           default y
>
> We already depend on ACPI for MMCONFIG support at compile time. This
> patch does not change that.
>
> We could conceivably skip the validation if ACPI was disabled, though
> this would only make a difference in the few cases where we can detect
> the MMCONFIG area without it (looks like currently only Intel E7520 and
> 945, at least in mainline).

i added support for AMD Fam 10h NB, and that patch is in -mm.

I like to see pci_mmcfg_check_hostbridge is called before any acpi check up.

also in your pci_mmcfg_early_init, you may miss calling to
pci_mmcfg_insert_resource...

YH
