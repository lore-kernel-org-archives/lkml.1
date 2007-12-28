Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbXL1A03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbXL1A03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXL1A0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:26:20 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:36274 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbXL1A0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:26:19 -0500
Date: Thu, 27 Dec 2007 18:25:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Suspend code ordering (again)
In-reply-to: <200712272100.20282.rjw@sisk.pl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Message-id: <47744291.30100@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no>
 <fa.XycBwhGuyvtVl/QW5HONqLwOags@ifi.uio.no> <4773E9EE.40107@shaw.ca>
 <200712272100.20282.rjw@sisk.pl>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>> Also, as was pointed out, pre-Vista versions of Windows follow ACPI 1.0 
>> and Vista follows 3.0, so 2.0 doesn't really matter since BIOS people 
>> won't test against it. 1.0 specifies that _PTS is to be called before 
>> suspending devices and 3.0 says that the AML must not depend on any 
>> specific device power state, so in both cases it should be safe to call 
>> _PTS before suspending, no?
> 
> Well, IMO, if we take one option only (whichever that is) and there are systems
> that follow the other one, they will likely break.
> 
> Apart from this, there are BIOSes that openly claim ACPI 2.0 support (for
> example, the one in my HP nx6325 does that) and they may actually prefer the
> post-ACPI-1.0 ordering even if they work with the pre-ACPI-2.0 one.

I doubt they would prefer the later ordering in any way that matters, if 
the Windows version they were designed for uses the earlier ordering.

It would be best if somebody could manage to find out what ordering 
Windows XP (and Windows Vista, for good measure) actually use, then we 
could just use that. Virtual machine trickery might be an option - the 
only complication being that it'll be using the DSDT for the fake 
machine and not the real one..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

