Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbZFYQUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbZFYQUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZFYQUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:20:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:13422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbZFYQUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:20:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,290,1243839600"; 
   d="scan'208";a="469568642"
Date: Thu, 25 Jun 2009 09:20:35 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [RFC/PATCH] Winbond CIR driver for the WPCD376I chip (ACPI/PNP
      id WEC1022)
Message-ID: <20090625092035.4bbe5251@jbarnes-g45>
In-Reply-To: <461dbc08f8573008440a03b9618bce94.squirrel@www.hardeman.nu>
References: <20090624213645.GA18843@hardeman.nu>
	<20090624151335.0f73907c@jbarnes-g45>
	<461dbc08f8573008440a03b9618bce94.squirrel@www.hardeman.nu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 04:46:01 -0700
David Härdeman <david@hardeman.nu> wrote:

> On Thu, June 25, 2009 00:13, Jesse Barnes wrote:
> > On Wed, 24 Jun 2009 14:36:45 -0700
> > David Härdeman <david@hardeman.nu> wrote:
> >
> >> I've written a driver for the
> ...
> >> Winbond WPCD376I chipset
> >
> > Yay, glad I could get these released for you.  I just did a quick
> > scan of the driver (notes below)
> 
> Two more things that Intel could provide:
> 
> a) Publish the datasheet (I know you mentioned doing this but
>    I can't find it on the Intel website)

Ah I was hoping that had been done already; I'll ping the docs people
about it.

> b) Make the hardware needed to actually use the CIR functionality
>    available for purchase. http://www.easy-cir.com seems to be more
>    or less dead (which is curious since an ad for the website
>    seems to be included with every CIR-enabled Intel motherboard).
>    I had to solder my own IR receiver in order to write the driver.

Oh that might be harder.  We just provide the boards for OEMs and
resellers; often not made directly for end users...

> >> Where should this driver go in the tree? drivers/platform/x86/?
> >
> > drivers/char is probably fine.
> 
> I'm leaning towards drivers/input/misc now...

Seems ok too.

> > The key up/down timeout handling seems like a pretty general
> > problem, maybe the input layer has some helpers for it?  Dunno.
> 
> drivers/media/common/ir-functions.c is the closest thing I could find
> while writing the driver. The functions there aren't usable because
> they do not properly implement the toggle/repeat handling and it
> forces the use of a small, fixed-size keymap. The same problem
> existed when I improved the IR functionality in
> drivers/media/dvb/ttpci/budget-ci.c by the way, so a generic version
> could probably be added to ir-functions in the future.

Sounds good.

> > Are these just for debugging?  If so, you could put them in debugfs
> > instead...
> 
> No, they are there to help the user when generating a keymap for an
> unknown remote. Press key on remote, read value from
> /sys/.../last_scancode, add line saying "0x12345678 = KEY_EXPLODE" to
> keymap file, repeat...there aren't any user-friendly tools for this
> yet though.

Ah right, yeah that's a good use for sysfs.

-- 
Jesse Barnes, Intel Open Source Technology Center
