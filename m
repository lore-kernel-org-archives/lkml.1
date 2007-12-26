Return-Path: <linux-kernel-owner+w=401wt.eu-S1752298AbXLZEbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbXLZEbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 23:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXLZEbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 23:31:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbXLZEbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 23:31:24 -0500
Date: Tue, 25 Dec 2007 20:29:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Robert Hancock <hancockr@shaw.ca>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
 suspend-to-RAM
In-Reply-To: <200712251926.51628.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.9999.0712252023290.21557@woody.linux-foundation.org>
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no> <200712251312.43478.carlos@strangeworlds.co.uk> <47713B2B.3000105@shaw.ca> <200712251926.51628.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 25 Dec 2007, Rafael J. Wysocki wrote:
> >
> > Correct me if I'm wrong, but it appears ACPI 1.0 wants _PTS called 
> > before any devices are suspended, ACPI 2.0 is contradictory, and ACPI 
> > 3.0 says that you can't assume anything about device state. My guess is 
> > that unless Windows has different behavior depending on ACPI version, it 
> > probably has called _PTS before suspending devices all along. Therefore 
> > it would likely be safest to emulate that behavior, no?
> 
> Well, I don't think so.

It would *definitely* always be safest to emulate what Windows does. 

> In fact ACPI 3.0 repeats the 2.0 wording in section 9.1.6 (so the current
> requirement seems to be to put devices into low power states before calling
> _PTS) and I _guess_ there was a change in the default behavior of Windows that
> caused the specification to be modified (I'd bet that was between 2000 and XP
> or something like this).

You seem to put a lot of trust in a piece of documentation.

Do you realize how those pieces of paper are written? They are written by 
people who have absolutely *nothing* to do with the actual implementation, 
and whose job it is to write documentation. And while the people who 
actually do the programming etc are supposed to help them, the two parties 
generally detest each other.

Technical writers hate the "real engineers" for not helping them, and the 
"real engineers" tend to dislike having to be pestered to explain their 
stuff and have to read through some document that isn't meant for them, 
but that they need to sign off on.

In other words: please do *not* expect that the documentation actually 
matches reality. You seem to think that the documentation came first 
and/or is quite accurate. That's not at all likely to be true.

> IMO, we should check which version of the specification we're supposed to
> follow, on the basis of FADT contents, for example, and follow this one.

No, we should try to figure out what Windows does. *If* windows checks the 
version, we should do that too. But we should absolutely *not* just assume 
that the documentation is an accurate picture of reality.

Does anybody know how we could find out? 

			Linus
