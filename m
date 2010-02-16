Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab0BPVty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 16:49:54 -0500
Received: from poutre.nerim.net ([62.4.16.124]:49589 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933264Ab0BPVtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 16:49:53 -0500
Date: Tue, 16 Feb 2010 22:49:47 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: Denis Turischev <denis@compulab.co.il>,
       LKML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
Message-ID: <20100216224947.5c46ff86@hyperion.delvare>
In-Reply-To: <201002161157.47196.david-b@pacbell.net>
References: <4B73DAEE.5080400@compulab.co.il>
	<4B73DB4B.40501@compulab.co.il>
	<201002161157.47196.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 11:57:46 -0800, David Brownell wrote:
> On Thursday 11 February 2010, Denis Turischev wrote:
> > Intel Poulsbo (SCH) chipset LPC bridge controller contains several
> > functions. Creating and MFD driver for the LPC bridge controller allows
> 
> Spelling nit: "Creating an" (not and).  Keyboard, brain, or edit fault.  ;)
> 
> 
> > simultaneous use of SMBus and GPIO interfaces on the SCH.
> 
> This looks like the right way to package such southbridge level
> componentry.  Maye not just these two interfaces, either.
> 
> But ... how does this play with ACPI?  The last several Intel
> systems I looked at seemed to expect ACPI to manage GPIOs and the
> IRQs they may issue.  (He wrote, staring at an ICH8-system where
> ACPI uses GPIOs to manage several buttons and LEDs.)
> 
> It would seem error-prone to ignore that coupling on systems
> with ACPI.  Linux has enough trouble sorting out issues caused
> by buggy AML (ACPI bytecode) without introducing conflicts in
> who manages which hardware resource (ACPI vs. operating system).

Might be a good idea to use acpi_check_resource_conflict() or similar
before instantiating the platform devices.

> Of course, if ACPI weren't being used to hide such board-specific
> details from operating systems, such issues would not exist.  But
> such hiding is one of the basic goals of ACPI ... annoying.

Don't start me on this :(

-- 
Jean Delvare
