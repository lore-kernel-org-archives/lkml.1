Return-Path: <linux-kernel-owner+w=401wt.eu-S1751415AbXLYRRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbXLYRRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 12:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbXLYRRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 12:17:37 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:58638 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXLYRRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 12:17:35 -0500
Date: Tue, 25 Dec 2007 11:17:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
 suspend-to-RAM
In-reply-to: <200712251312.43478.carlos@strangeworlds.co.uk>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <47713B2B.3000105@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no>
 <200712250003.27570.carlos@strangeworlds.co.uk>
 <200712251426.14024.rjw@sisk.pl>
 <200712251312.43478.carlos@strangeworlds.co.uk>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Corbacho wrote:
> On Tuesday 25 December 2007 13:26:12 Rafael J. Wysocki wrote:
>> Well, citing from the ACPI 2.0 specification, section 9.1.6 Transitioning
>> from the Working to the Sleeping State (which is what we're discussing
>> here):
>>
>> 3. OSPM places all device drivers into their respective Dx state. If the
>> device is enabled for wake, it enters the Dx state associated with the wake
>> capability. If the device is not enabled to wake the system, it enters the
>> D3 state.
>> 4. OSPM executes the _PTS control method, passing an argument that
>> indicates the desired sleeping state (1, 2, 3, or 4 representing S1, S2,
>> S3, and S4).
>>
>> My opinion is that we should follow this part of the specification and so
>> we do.
> 
> This is that same section from ACPI 1.0B:
> 
> 3. The OS executes the Prepare To Sleep (_PTS) control method, passing an
> argument that indicates the desired sleeping state (1, 2, 3, or 4 representing
> S1, S2, S3, and S4).
> 
> 4. The OS places all device drivers into their respective Dx state. If the
> device is enabled for wakeup, it enters the Dx state associated with the 
> wakeup capability. If the device is not enabled to wakeup the system, it 
> enters the D3 state.
> 
> The DSDTs in question also claim ACPI 1.0 compatiblity.
> 
>> You're wrong, sorry.
> 
> No, I'm not entirely wrong - read the 1.0 spec, and read section 7.3.2 of the 
> ACPI 2.0 spec.
> 
> * ACPI 1.0 is very clear - we are breaking the 1.0 spec
> 
> * ACPI 2.0 is contradictory - section 7.3.2 repeats 1.0 ad verbatim (which is 
> what I quote in reply to Robert Hancock), but as you point out, 9.3.2 says 
> the opposite.
> 
> So, 1.0 and 3.0 are very clear and rather different on this, and 2.0 is 
> contradictory (and I presume this is one of the points ACPI 3.0 set out to 
> clean up).
> 
> I will rescind my point on ACPI 2.0 - I don't know what we should or shouldn't 
> be doing there, the spec is unclear.
> 
> But for ACPI 1.0, we are doing the wrong thing.

Correct me if I'm wrong, but it appears ACPI 1.0 wants _PTS called 
before any devices are suspended, ACPI 2.0 is contradictory, and ACPI 
3.0 says that you can't assume anything about device state. My guess is 
that unless Windows has different behavior depending on ACPI version, it 
probably has called _PTS before suspending devices all along. Therefore 
it would likely be safest to emulate that behavior, no?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

