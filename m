Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab0BQKCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:02:38 -0500
Received: from compulab.co.il ([67.18.134.219]:47791 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004Ab0BQKCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:02:36 -0500
Message-ID: <4B7BBEE5.3040104@compulab.co.il>
Date: Wed, 17 Feb 2010 12:03:17 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
References: <4B73DAEE.5080400@compulab.co.il>	<4B73DB4B.40501@compulab.co.il>	<201002161157.47196.david-b@pacbell.net> <20100216224947.5c46ff86@hyperion.delvare>
In-Reply-To: <20100216224947.5c46ff86@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Tue, 16 Feb 2010 11:57:46 -0800, David Brownell wrote:
>> On Thursday 11 February 2010, Denis Turischev wrote:
>>> Intel Poulsbo (SCH) chipset LPC bridge controller contains several
>>> functions. Creating and MFD driver for the LPC bridge controller allows
>> Spelling nit: "Creating an" (not and).  Keyboard, brain, or edit fault.  ;)
>>
>>
>>> simultaneous use of SMBus and GPIO interfaces on the SCH.
>> This looks like the right way to package such southbridge level
>> componentry.  Maye not just these two interfaces, either.
>>
>> But ... how does this play with ACPI?  The last several Intel
>> systems I looked at seemed to expect ACPI to manage GPIOs and the
>> IRQs they may issue.  (He wrote, staring at an ICH8-system where
>> ACPI uses GPIOs to manage several buttons and LEDs.)
>>
>> It would seem error-prone to ignore that coupling on systems
>> with ACPI.  Linux has enough trouble sorting out issues caused
>> by buggy AML (ACPI bytecode) without introducing conflicts in
>> who manages which hardware resource (ACPI vs. operating system).
> 
> Might be a good idea to use acpi_check_resource_conflict() or similar
> before instantiating the platform devices.

May be it worth to add such resource check directly to mfd_add_device function?

> 
>> Of course, if ACPI weren't being used to hide such board-specific
>> details from operating systems, such issues would not exist.  But
>> such hiding is one of the basic goals of ACPI ... annoying.
> 
> Don't start me on this :(
> 

