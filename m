Return-Path: <linux-kernel-owner+w=401wt.eu-S1751845AbXA3Wbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbXA3Wbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXA3Wbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:31:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:21899 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbXA3Wbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:31:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,259,1167638400"; 
   d="scan'208"; a="190858367:sNHT23603440"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ACPI C and P states on Conroe
Date: Tue, 30 Jan 2007 14:31:14 -0800
Message-ID: <EB12A50964762B4D8111D55B764A845401330C7E@scsmsx413.amr.corp.intel.com>
In-Reply-To: <45BF8181.1050600@dogpad.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ACPI C and P states on Conroe
Thread-Index: AcdEli3ySvAznfV3SqaDS6w2CuxaFwAJz4Cg
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Joe Harvell" <jharvell@dogpad.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Jan 2007 22:31:15.0536 (UTC) FILETIME=[5A73C500:01C744BE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


C0 is the state when processor is executing instruction.
C1-C3 is the state that kernel puts the CPU into when there is nothing
to run (idle loop).
C1 is supported by all processors and it is entered either by using
"hlt" or "mwait" instructions. You don't have to do anything to enable
this. It should be getting used already (unless you are using
"idle=poll" in which case C1 will not be used).
C2 and C3 however are not supported on all processors/platforms
typically. If it is supported, BIOS will export these states information
to OS, through ACPI and kernel acpi processor module will enable those
states. As long as you have CONFIG_ACPI_PROCESSOR enabled, this support
will be built in and should get enabled (if your platform supports this
feature). There are no magic setup to enable this. If present, you will
see info about these C-states here - /proc/acpi/processor/CPU*/power

-Venki

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Joe Harvell
>Sent: Tuesday, January 30, 2007 9:34 AM
>To: linux-kernel@vger.kernel.org
>Subject: ACPI C and P states on Conroe
>
>I am trying to enable all the power saving features I can on my Conroe 
>E6600.  After much searching on the web, I am a little confused about 
>the Linux kernel support for ACPI on the Conroe.
>
>Here is my setup:
>Intel Core2 Duo E6600
>Asus P5-B Deluxe board (Intel P965).
>I am running a Gentoo kernel based on 2.6.19.4.
>
>I have managed to enable EIST using cpufreq with the 
>speedstep-centrino 
>driver.  But my understanding from browsing the ACPI spec is that this 
>is still within C0, i.e. not much power savings.
>
>Here are my questions:
>
>1) For P states, which cpufreq driver should I be using?  I've heard 
>speedstep-centrino is deprecated (but only some aspects of it) 
>that are 
>being moved into acpi-cpufreq.  But I can't get acpi-cpufreq 
>to load in 
>my kernel version.  Also, I would have thought speedstep-ich would be 
>the driver, just based on the name.  How do I know (other than trying 
>all modules to see which one loads) which one I should be using?
>2) What kind of support for C1-C3 does the Conroe have?  The ACPI spec 
>says C2 and C3 require chipset support on the motherboard.  Does P965 
>have that.  Does it matter between boards (e.g. P5B)?
>3) What versions of the kernel support C1-C3 states?  What kernel 
>options are germane to this?  What libraries/tools are involved?
>
>---
>Joe Harvell
>-
>To unsubscribe from this list: send the line "unsubscribe 
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
