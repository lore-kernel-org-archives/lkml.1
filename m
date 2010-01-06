Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256Ab0AFUWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0AFUWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242Ab0AFUWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:22:53 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:18157 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab0AFUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:22:52 -0500
Date: Wed, 06 Jan 2010 15:22:30 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
In-reply-to: <20100106193608.GA21447@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1001061504110.4086@localhost.localdomain>
References: <20100104162114.GA30113@percival.namespace.at>
 <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
 <4B4225B3.8070705@zytor.com> <20100104174558.158cd512@infradead.org>
 <20100106143640.GB13984@srcf.ucam.org>
 <alpine.LFD.2.00.1001061321260.4086@localhost.localdomain>
 <20100106193608.GA21447@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > using _OSI is not "a similar method to Windows".
> > The BIOS does not need to invoke _OSI to determine if
> > it should expose a properly functioning ACPI reset or not.
> > Windows XP simply demanded it, and the box failed WHQL
> > if it did not work.
> 
> http://download.microsoft.com/download/7/E/7/7E7662CF-CBEA-470B-A97E-CE7CE0D98DC2/WinACPI_OSI.docx 
> was what I was referring to:
> 
> "By using the _OSI method, ASL writers can easily determine the version 
> of the ACPI interfaces that the host operating system supports. This 
> versioning method provides a solution for creating firmware that can 
> support future operating systems and enable the operating system to 
> change behavior based on the requested interface levels."
> 
> We know that this is used for deciding whether or not to block system IO 
> accesses, but it wouldn't surprise me if it's also used to determine 
> other functionality like whether or not the ACPI interface is used for 
> rebooting.

I've looked at _OSI use in over a hundred DSDTs and never
seen run-time re-configuration of reset support.

I do not think the BIOS has a run-time decision to make here.
If a box is designed to support Windows XP and newer, it is
likely that ACPI_RESET is simply valid and XP blindly uses it.
If reset fails, the box doesn't pass WHQL and the box is fixed.
If W2K is run on that box, ACPI_RESET is still valid, just that
W2K chooses to not write to it.

> > Further, there is no _guarantee_ that a BIOS will invoke _OSI
> > at all, let alone a _rule_ for what _OSI() strings the BIOS
> > will choose to query to trigger its Windows specific
> > compatibility hooks -- even if common practice is for
> > a desktop BIOS to evaluate _OSI strings in sequence
> > up throught he most recent version of Windows it
> > knows about...
> 
> It's effectively guaranteed if the system is validated with Windows.

today's common industry practice != future guarantee

We can't rely on blind use of _OSI to mean "new enough", since
it was supported back in W2K era.  That means we have to parse
the OSI strings.  But what happens when a BIOS writer decides to
evaluate _OSI("Windows Future") without evaluating any of the
old strings we know about?  We would disable ACPI reset on such
a future box?

thanks,
-Len

