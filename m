Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbXJPIun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbXJPIun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759753AbXJPIuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:50:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:22279 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbXJPIuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,282,1188802800"; 
   d="scan'208";a="347489746"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Date: Tue, 16 Oct 2007 01:49:54 -0700
User-Agent: KMail/1.9.7
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <200710152038.10980.jesse.barnes@intel.com> <20071016083611.GB15293@khazad-dum.debian.net>
In-Reply-To: <20071016083611.GB15293@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710160149.56649.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 16, 2007 1:36 am Henrique de Moraes Holschuh wrote:
> > No, on Lenovo (and in general actually) the firmware should *not*
> > touch the backlight.  Otherwise if another driver touches it the
> > driver and
>
> This is not an option on IBM ThinkPads, unless you patch the DSDT on
> non-ancient ACPI-based models, and unless you patch the BIOS (and
> maybe even the EC control program) itself on the really ancient
> models.  It is that simple.
>

Yeah, unfortunately, "should not" doesn't mean "does not" in this case.  
In cases where we can't control the firmware, we have to use it to 
control the backlight exclusively, or we'll definitely get into 
trouble.

> You want ACPI video to just pass the messages to userspace when X.org
> is driving the backlight?  Fine with me.  That *still* doesn't make
> it right to get these messages as hot key presses over the input
> layer through the thinkpad-acpi driver.  So the NAK stands.  Any
> changes should be done to the ACPI video driver in this case.

So is this really the direction that input is going?  Last time I talked 
with Dmitry, he seemed ok with adding input events for ACPI and other 
firmware hotkeys...

> Good luck, and please interface it properly to the backlight class
> while at it.  There's no reason to make the waters mudier :-)

Yeah, the backlight class needs some changes:  the backlight dirs should 
somehow identify the display they control and only *one* backlight 
driver should be registered for a given display.  Unfortunately we 
don't have enough info in the kernel to identify displays, so those 
changes may have to wait until the DRM grows such knowledge.

Jesse
