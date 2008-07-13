Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYGMUaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYGMUaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbYGMU3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:29:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbYGMU3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:29:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Date: Sun, 13 Jul 2008 22:32:00 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200807010148.02135.rjw@sisk.pl> <487A62B3.8010207@zytor.com> <487A63D2.9040006@firstfloor.org>
In-Reply-To: <487A63D2.9040006@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807132232.01489.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of July 2008, Andi Kleen wrote:
> H. Peter Anvin wrote:
> > Andi Kleen wrote:
> >>
> >> Hmm, but the change was not supposed to break the s3 bios. Something
> >> fishy is going on. It sounds like the s3 bios relies on some earlier
> >> segment register setup.
> >>
> >> If true this means the segment register reset would need to be moved
> >> later after S3 bios ran. Saving/restoring is unfortunately not possible
> >> because we cannot save/restore the hidden state loaded from the GDT
> >> earlier.
> >>
> > 
> > That really doesn't make sense, though.  The VESA BIOS has to be entered
> > in clean real mode; it's designed to be entered from reset, after all.
> > There is definitely something fishy going on, but I don't think this
> > particular aspect is it.
> 
> It probably switches to protected mode. I noticed this on my old
> Fujitsu laptop when I tried to make the S3 wakeup run in the s2ram x86 emulator
> and found it entered protected mode at some point, which x86emu
> didn't support.
> 
> I guess Lenovo is doing the same.
> 
> And that protected mode code relies on some GDT values that have been
> loaded earlier when the BIOS also went into protected mode.
> 
> It seems the BIOS programmers really don't like real mode anymore.
> Somehow understandable.

So should we check if we are in real mode at the entry point?

That would compilcate things a lot.

Thanks,
Rafael
