Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXJYWoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXJYWoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXJYWor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:44:47 -0400
Received: from smtp.ono.com ([62.42.230.12]:47301 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755700AbXJYWoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:44:46 -0400
Date: Fri, 26 Oct 2007 00:44:34 +0200
From: "J.A. =?ISO-8859-1?Q?Magall=F3n?=" <jamagallon@ono.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Opteron box and 4Gb memory
Message-ID: <20071026004434.50c73dd3@werewolf>
In-Reply-To: <47211172.9070606@zytor.com>
References: <20071025230904.03d5f46a@werewolf>
	<47211172.9070606@zytor.com>
X-Mailer: Claws Mail 3.0.2cvs101 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 14:58:10 -0700, "H. Peter Anvin" <hpa@zytor.com> wrote:

> J.A. Magallon wrote:
> > Hi...
> > 
> > I have some Quad-Opteron boxes with 4Gb memory and two of them are
> > running two different Linux distros.
> > 
> > Box one sees 4Gb of memory, but box two just sees 3.
> > Their mtrr setups are different:
> > 
> > Why ? Is it a bios setup problem ? A kernel problem ?
> > grep HIGHMEN in configs for both kernels does not give anything, so
> > I still understand less this thing...
> > 
> 
> It would depend on how the BIOS programmed the memory controllers.  For 
> 32-bit (and lots of device) compatibility, a memory hole is required 
> below 4 GB.  Not all memory controllers can remap memory in the 3-4 GB 
> range above the 4 GB memory; I'm not sure if that varies with the 
> different Opteron processors.

I have collected several pieces of info around the internet...

- Some people uses this options in the BIOS:
	Node interleave: off
	Bank interleave: auto
	SW memory hole: disable
	HW memory hole: enable
	MTRR: Continuous

- Node Memory Interleaving DISABLES NUMA and generally is a bad thing

- MTRR setting -should be set to "discrete" for Linux, and probably for Windows too.

- This is what SuperMicro's tech support said about 2.96GB vs. 4GB.

"This is as expected, as soon as you set "software memory hole" to disabled,
you also disable option ROM remapping functionality, this option normally
remaps used option rom (option rom= raid bios, lan pxe ; usb legacy, bioses
on add-on cards, etc) in the 4GB region, so no basis memory is lost, while
this feature is now disabled the option rom space occupies the space between
3 and 4 GB which results in lower main memory availability.
There is no solution or work around for this phenomenon"

so software memory hole enabled might be needed to get all 4GB to show up

>From mobo manual:

Software Memory Hole
When "Enabled", allows software memory remapping around the memory
hole. Options are Enabled and Disabled.

Hardware Memory Hole
When "Enabled", allows software memory remapping around the memory
hole. Options are Enabled and Disabled. Note: this is only supported by
Rev E0 processors and above.
( I have two Opteron 275 processors, no idea about revision)

So _my_ conclussion is:

	Node interleave: off    (numa mode)
	Bank interleave: auto
	SW memory hole: disable |
	HW memory hole: enable  | allow remapping
	MTRR: Discrete          |

But then, do I need to enable NUMA options in the kernel ?

> 
> Also, if you run a 32-bit distribution, you need to have HIGHMEM_64G 
> enabled in the kernel.
> 

I run a 64 bit one, then I don't need anything, isn't it ? That's why I
don't see any _HIGHMEM in the kernel configs...

Some day I will understand this crappy BIOS thing (or burn a photo of its
inventor...).
Why can't we have OpenFirmware PC's, like my MacPro  and Sparcs ?

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam01 (gcc 4.2.2 20070909 (4.2.2-0.RC.1mdv2008.0)) SMP PREEMPT
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
