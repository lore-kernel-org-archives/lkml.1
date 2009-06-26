Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbZFZLzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbZFZLzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbZFZLzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:55:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51184 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752885AbZFZLzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:55:35 -0400
Date: Fri, 26 Jun 2009 12:56:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626125653.5e30bae4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090626110429.GB12446@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com>
	<20090626071955.GG14078@elte.hu>
	<20090626101310.4110a290@lxorguk.ukuu.org.uk>
	<20090626093859.GA12571@elte.hu>
	<20090626111603.758ec7fb@lxorguk.ukuu.org.uk>
	<20090626110429.GB12446@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The flags are passed by the boot loader which is the one thing 
> > that knows what the platform is only deeply embedded hardware. See 
> > the ARM and PPC ports.
> 
> And? There's an obvious quality difference between various platform 
> enumeration methods - and we strive for the highest quality methods.

Good the boot loader knows precisely what it is running on

> Using boot flags is one of the lowest quality enumeration methods 

It's probably the most reliable. If you don't believe so then provide
data to back your assertion

> and the fact that there's precedence for it in other architectures 
> is not a technical reason to make the same mistakes on x86 too.

How about "they tried other methods and they didn't work"

> It is obviously relevant to the fact that the proposed patches here 
> (on which i commented) come for a platform with PCI support. Or do 
> you claim that Intel submitted this patch-set for PCI-less MIDs? 
> (this was not mentioned anywhere in the patches)

I claimed nothing of the sort Ingo. I pointed out your approach doesn't
actually work except for the PCI case. WHich means it doesn't even work
on a generic 486 ISA bus PC. Is that a single chip embedded device using
a licenced core from one of the 486 vendors or an ISA PC .. how do you
tell.

> That's very simple really - there's basically a very low number of 
> PCI configuration mechanisms/ports on x86, and the MIDs have no 
> reason to depart from that standard. There's two that matter in 
> practice, and it can all be safely probed.

You try one, that I/O address isn't mapped and you get a fatal machine
check. Exactly why is that reliable ?

> PCI is really essential to any modern architecture (precisely 
> because it's standard and well-known) and i doubt Intel will try to 
> engineer out PCI from its systems. If it happens i will comment on 
> that kind of braindamage in due course.

PCI is already obsolete.

> But, PCI IDs dont _have_ to be used - there's ample other 
> environmental space available via SFI, ACPI or EFI or old-and-proven 
> EBDA.

You only have an EBDA on a PC type machine. You only have ACPI on a PC
type machien. You only have EFI ona PCI type machine. So how will you
look for them when the generic whacky BIOS windows for 16bit DOS
compatibility that hold these things might be ROM or random chunks of
main memory ?

> > SFI doesn't indicate MRST
> 
> So do you claim that this particular patchset supports systems with 
> no SFI, no ACPI, just plain bootloader flags?

If you have the bootloader pass the information then that is one source
of it. It doesn't need to be the only one.

You are also pointlessly entangling MRST and platform identification.

Please separate out the following in your thinking

- How you implement   int platform = gee_what_the_hell_am_i_running_on()

and "ok so I'm a voyager, now what"

> Do you claim that the Intel patchset here deals with systems that 
> have no SFI and no ACPI? My question was very specific to this 
> patch-set. 

I'm trying to sort out the broader question.

It's called architecture - planning for the future, design. If you want
to be utterly narrow minded you can NIH about every platform but x86 and
pretend hardware won't exist that doesn't fit your predetermined vision.
If you don't plan for the future you get to write the arch code every new
hardware platform. Which is fun and you really want to spend your life
re-inventing this every six months no ?

> Non-x86 ultra-embedded might use crappier techniques but i'd expect 
> Intel has the resources to do better here. Using standard hardware 

What makes you think x86 ultra-embedded is solely an Intel thing. OLPC
isn't Intel for one although its still quite PCish.

> or firmware interfaces for that is far better in the x86 space and 
> we have no reason to depart from that really.

It isn't about departing from that, it's about supporting the future. If
you untangle this into two questions

- How do I identify this platform

- How do I run on lots of platforms without the code becoming a
  mess

it might make more progress.

The important one right now is the second question. Whether you set the
platform on dip switches or by PCI bus probing the interface doesn't
change. Its a function that returns a number.

The hardware interfaces don't exist in x86 unlike most other
architectures so that does need addressing properly and can't be deferred.

