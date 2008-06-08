Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYFHS5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYFHS5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYFHS5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:57:11 -0400
Received: from wsip-70-184-212-2.om.om.cox.net ([70.184.212.2]:54912 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYFHS5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:57:10 -0400
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: bcm33xx port
Date: Sun, 8 Jun 2008 13:56:56 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
References: <200806072113.26433.luke@dashjr.org> <200806072332.06460.luke@dashjr.org> <Pine.LNX.4.55.0806081332560.15673@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806081332560.15673@cliff.in.clinika.pl>
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081357.02601.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 June 2008, Maciej W. Rozycki wrote:
> On Sat, 7 Jun 2008, Luke -Jr wrote:
> > VxWorks, including the boot loader, is not CFE as far as I am aware. If
> > you're referring to the "CFEv2" in the log, that appears to be the
> > default of a switch (eg, if Linux doesn't detect anything else).
>
>  That message is not included in the standard kernel -- how can I know it
> is meaningless?  As I wrote CFE is standard Broadcom firmware.

It's not? Guess it came from the bcm63xx patches OpenWrt has that I'm using as 
a base for this... Either way, it seems unlikely something claiming to 
be "VxWorks System Boot" is a standard firmware.

> > The calibration code was crashing, so I set it to a fixed 1 value.
> > Worst case, some code won't delay as long as it wants to, right?
>
>  That's grossly wrong.  If you need to preset it for the time being till
> you debug calibration, then for a MIPS processor assume one instruction
> per clock tick and two instructions per loop -- that may not be entirely
> correct, but is a good approximation.  Otherwise you risk peripheral
> devices are not driven correctly with all sorts of the nasty results.

Meaning this?
	preset_lpj = loops_per_jiffy = 2;

> > >  You have got something seriously broken -- __bzero traps exceptions on
> > > stores for graceful recovery as user addresses may be accessed as is
> > > the case here.  If the reserved instruction exception handler is
> > > reached, then clearly the store instruction is not the immediate cause.
> >
> > What else could it be?
>
>  Well, you've got the system and I have no crystal ball.  You have means
> to debug it.  See how control is passed to the RI exception.  Find which
> of the TLB exceptions happens and how it proceeds.  Etc...

Unfortunately, I don't understand how to "see how control is passed" or 
finding TLB exceptions... Could you point me in the right direction to learn 
about this?

On Sunday 08 June 2008, Kevin D. Kissell wrote:
> The universe of possible failures is large.  The two most likely categories
> are (a) configuring the build for a variant of the architecture (64-bit,
> MIPS32R2) that your hardware doesn't support - this is what Maciej was
> referring to,

CONFIG_CPU_MIPS32_R1=y

> and (b) control being transferred to a block of memory that isn't actually
> code, as can happen if exception vectors or global pointers-to-functions
> aren't set up correctly, or if the kernel stack is being corrupted.   When
> you say "the instruction in question is a store word", how do you know that? 

The RI error spits out a bunch of info, including epc which presumably points 
to the instruction causing the problem: ac85ffc0; this is 'sw a1,-64(a0)'

Luke
