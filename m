Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYH1BrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYH1BrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYH1Bq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:46:58 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58655 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753315AbYH1Bq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:46:57 -0400
X-Sasl-enc: ISwJZdF3EfXaMNX4CM/5H4Nh8Yl5t1wzD7xE2e/TDzFh 1219888015
Date: Wed, 27 Aug 2008 22:46:47 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: /proc/acpi/ibm/wan stopped appearing
Message-ID: <20080828014647.GA24365@khazad-dum.debian.net>
References: <48B5D11E.5090209@goop.org> <20080827231223.GB18081@khazad-dum.debian.net> <48B5E2C4.7060803@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B5E2C4.7060803@goop.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Jeremy Fitzhardinge wrote:
> Henrique de Moraes Holschuh wrote:
> > 2. The proper way to control ANY radio's rfkill functions is through the
> > rfkill sysfs interface.  That includes thinkpad-acpi's  bluetooth and WWAN.
> >   
> 
> Do you know what UI-level programs make use of these interfaces now?

Anything that does it through HAL when HAL gets updated, I suppose.

I don't really care for the network management GUIs, I have never seen one
that worked properly, so I dropped them all for good.  The UIs I use are
wpa-supplicant's config file, iproute and friends, and Debian's ifupdown
crap.

The only UI I trust enough to touch rfkill control on my machines is the
kernel itself (rfkill-input is an UI), so I guess you will have to ask
someone else about it normal user-level UIs and GUIs for rfkill :(
Probably in the linux-wireless ML, instead of here in LKML.

> > IOW, we may have a regression here.  Please compile thinkpad-acpi with debug
> > mode enabled, load it with the "debug=0xffff" and "experimental=1"
> > parameters (as far as I remember, WWAN requires "experimental=1" to work,
> > without that it will NOT load, and you will NOT get /proc/acpi/ibm/wan or
> > anything else WWAN related from thinkpad-acpi), and send me the resulting
> > log output from thinkpad-acpi.
> 
> Actually, that may be it.  I think I used to load it as a module, and
> modprobe.conf set experimental=1, but I don't have an equivalent on the
> kernel command line.

thinkpad-acpi.experimental=1 in the kernel command line should do it.

> I think I'll submit a patch to remove the need for experimental; it's
> been working fine for me for 3 years now.

It is in my TODO list, so you don't need to bother.  But if you do, here are
my requirements for patches to be accepted, so that you don't waste your
time:

1. Do it based on thinkpad-acpi in Linus' mainline, and give the patch a
proper title prefix ("ACPI: thinkpad-acpi: "), title and commit message.
Sign it off, and CC me.

2. UPDATE THE DOCUMENTATION ALONG WITH THE CODE, in the SAME patch.  That
means Documentation/laptops/thinkpad-acpi.txt.

Plus the usual "test it first", etc.  But it will be an extremely trivial
one-liner patch to the code, so I wouldn't worry much about that ;-) It is
the doc update that will make up most of the patch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
