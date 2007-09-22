Return-Path: <linux-kernel-owner+w=401wt.eu-S1762891AbXIVG4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762891AbXIVG4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXIVG4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:56:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:64622 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757836AbXIVG4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DgMdY3J5im/rgr8ERB51KaRDoQ7tZEMOGglZQhAuaCU4RVL5hzWiU/HsByhqiYTOdrpulycXGVd8vmxfhfwhmlxBZoiPNbUQd69eXBYhCgpyHl3CqYKNjE0BQ/DkiutFCbA6BmQ61mHjNV/JuAEyUua6XYAB/7A3mppmZ/rzfLA=
Message-ID: <86802c440709212356v498610cfo589b45a0bfc76dd6@mail.gmail.com>
Date: Fri, 21 Sep 2007 23:56:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [9/50] i386: validate against ACPI motherboard resources
Cc: hancockr@shaw.ca, rajesh.shah@intel.com, jbarnes@virtuousgeek.org,
       greg@kroah.com, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709221231.836138000@suse.de>
	 <20070921223207.7BBE71479D@wotan.suse.de>
	 <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On 9/21/07, Andi Kleen <ak@suse.de> wrote:
> >
> > From: Robert Hancock <hancockr@shaw.ca>
> >
> > This path adds validation of the MMCONFIG table against the ACPI reserved
> > motherboard resources.  If the MMCONFIG table is found to be reserved in
> > ACPI, we don't bother checking the E820 table.  The PCI Express firmware
> > spec apparently tells BIOS developers that reservation in ACPI is required
> > and E820 reservation is optional, so checking against ACPI first makes
> > sense.  Many BIOSes don't reserve the MMCONFIG region in E820 even though
> > it is perfectly functional, the existing check needlessly disables MMCONFIG
> > in these cases.
> >
> > In order to do this, MMCONFIG setup has been split into two phases.  If PCI
> > configuration type 1 is not available then MMCONFIG is enabled early as
> > before.  Otherwise, it is enabled later after the ACPI interpreter is
> > enabled, since we need to be able to execute control methods in order to
> > check the ACPI reserved resources.  Presently this is just triggered off
> > the end of ACPI interpreter initialization.
> >
> > There are a few other behavioral changes here:
> >
> > - Validate all MMCONFIG configurations provided, not just the first one.
> >
> > - Validate the entire required length of each configuration according to
> >   the provided ending bus number is reserved, not just the minimum required
> >   allocation.
> >
> > - Validate that the area is reserved even if we read it from the chipset
> >   directly and not from the MCFG table.  This catches the case where the
> >   BIOS didn't set the location properly in the chipset and has mapped it
> >   over other things it shouldn't have.
> >
> > This also cleans up the MMCONFIG initialization functions so that they
> > simply do nothing if MMCONFIG is not compiled in.
> >
> > Based on an original patch by Rajesh Shah from Intel.
> >
> > [akpm@linux-foundation.org: many fixes and cleanups]
> > Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> > Signed-off-by: Andi Kleen <ak@suse.de>
> > Cc: Rajesh Shah <rajesh.shah@intel.com>
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Andi Kleen <ak@suse.de>
> > Cc: Greg KH <greg@kroah.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Also the titile is misleading: it is x86 instead of i386.. because it
will affect x86_64 too.

YH
