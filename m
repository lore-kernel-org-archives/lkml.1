Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbXLYSHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbXLYSHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 13:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbXLYSHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 13:07:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbXLYSHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 13:07:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Tue, 25 Dec 2007 19:26:50 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no> <200712251312.43478.carlos@strangeworlds.co.uk> <47713B2B.3000105@shaw.ca>
In-Reply-To: <47713B2B.3000105@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712251926.51628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of December 2007, Robert Hancock wrote:
> Carlos Corbacho wrote:
> > On Tuesday 25 December 2007 13:26:12 Rafael J. Wysocki wrote:
> >> Well, citing from the ACPI 2.0 specification, section 9.1.6 Transitioning
> >> from the Working to the Sleeping State (which is what we're discussing
> >> here):
> >>
> >> 3. OSPM places all device drivers into their respective Dx state. If the
> >> device is enabled for wake, it enters the Dx state associated with the wake
> >> capability. If the device is not enabled to wake the system, it enters the
> >> D3 state.
> >> 4. OSPM executes the _PTS control method, passing an argument that
> >> indicates the desired sleeping state (1, 2, 3, or 4 representing S1, S2,
> >> S3, and S4).
> >>
> >> My opinion is that we should follow this part of the specification and so
> >> we do.
> > 
> > This is that same section from ACPI 1.0B:
> > 
> > 3. The OS executes the Prepare To Sleep (_PTS) control method, passing an
> > argument that indicates the desired sleeping state (1, 2, 3, or 4 representing
> > S1, S2, S3, and S4).
> > 
> > 4. The OS places all device drivers into their respective Dx state. If the
> > device is enabled for wakeup, it enters the Dx state associated with the 
> > wakeup capability. If the device is not enabled to wakeup the system, it 
> > enters the D3 state.
> > 
> > The DSDTs in question also claim ACPI 1.0 compatiblity.
> > 
> >> You're wrong, sorry.
> > 
> > No, I'm not entirely wrong - read the 1.0 spec, and read section 7.3.2 of the 
> > ACPI 2.0 spec.
> > 
> > * ACPI 1.0 is very clear - we are breaking the 1.0 spec
> > 
> > * ACPI 2.0 is contradictory - section 7.3.2 repeats 1.0 ad verbatim (which is 
> > what I quote in reply to Robert Hancock), but as you point out, 9.3.2 says 
> > the opposite.
> > 
> > So, 1.0 and 3.0 are very clear and rather different on this, and 2.0 is 
> > contradictory (and I presume this is one of the points ACPI 3.0 set out to 
> > clean up).
> > 
> > I will rescind my point on ACPI 2.0 - I don't know what we should or shouldn't 
> > be doing there, the spec is unclear.
> > 
> > But for ACPI 1.0, we are doing the wrong thing.
> 
> Correct me if I'm wrong, but it appears ACPI 1.0 wants _PTS called 
> before any devices are suspended, ACPI 2.0 is contradictory, and ACPI 
> 3.0 says that you can't assume anything about device state. My guess is 
> that unless Windows has different behavior depending on ACPI version, it 
> probably has called _PTS before suspending devices all along. Therefore 
> it would likely be safest to emulate that behavior, no?

Well, I don't think so.

In fact ACPI 3.0 repeats the 2.0 wording in section 9.1.6 (so the current
requirement seems to be to put devices into low power states before calling
_PTS) and I _guess_ there was a change in the default behavior of Windows that
caused the specification to be modified (I'd bet that was between 2000 and XP
or something like this).

IMO, we should check which version of the specification we're supposed to
follow, on the basis of FADT contents, for example, and follow this one.

Thanks,
Rafael
