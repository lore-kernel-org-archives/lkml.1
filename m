Return-Path: <linux-kernel-owner+w=401wt.eu-S1763220AbXJPIga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763220AbXJPIga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 04:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbXJPIgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 04:36:19 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49994 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757439AbXJPIgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 04:36:18 -0400
X-Sasl-enc: ZSGqMZWKqc4kjJc2N47NZ9BuCdrwOnJeqT3+n8tpqvga 1192523776
Date: Tue, 16 Oct 2007 06:36:11 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071016083611.GB15293@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <200710152038.10980.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710152038.10980.jesse.barnes@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Jesse Barnes wrote:
> On Monday, October 15, 2007 2:07 pm Henrique de Moraes Holschuh wrote:
> > As for Lenovo thinkpads, brightness control is to be processed by the
> > ACPI video module, so brightness hot keys are not to be reported by
> > default there either.  I am not so sure about the volume keys, but
> > your patch touches the IBM keymap *and* you provide no testing
> > information for the various Lenovo models, so I have to NAK it as
> > well until more information is available.
> 
> No, on Lenovo (and in general actually) the firmware should *not* touch 
> the backlight.  Otherwise if another driver touches it the driver and 

This is not an option on IBM ThinkPads, unless you patch the DSDT on
non-ancient ACPI-based models, and unless you patch the BIOS (and maybe even
the EC control program) itself on the really ancient models.  It is that
simple.

On *new* Lenovo ThinkPad BIOSes (the z60 that Lenovo has given up on act
just like IBM ThinkPads), the firmware reports brightness changes through
the proper ACPI messages, which are processed by the ACPI video module. So I
will repeat myself here: brightness control is to be processed by the ACPI
video module, so brightness hot keys are not to be reported by default in
Lenovo thinkpads.

You want ACPI video to just pass the messages to userspace when X.org is
driving the backlight?  Fine with me.  That *still* doesn't make it right to
get these messages as hot key presses over the input layer through the
thinkpad-acpi driver.  So the NAK stands.  Any changes should be done to the
ACPI video driver in this case.

If the user has any real need to get these messages from thinkpad-acpi for
whichever particular reasons, he can use the standard interface to input
event drivers to remap the scan codes to whatever he wants.

> firmware will be out of sync, causing unexpected and undesirable 
> behavior.  We intend to fix this for the Intel driver at least 
> (requiring both ACPI video driver and gfx driver updates), others will 
> probably follow eventually.

Good luck, and please interface it properly to the backlight class while
at it.  There's no reason to make the waters mudier :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
