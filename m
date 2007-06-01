Return-Path: <linux-kernel-owner+w=401wt.eu-S1761662AbXFAPHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662AbXFAPHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760587AbXFAPHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:07:05 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33678 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759209AbXFAPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:07:03 -0400
X-Sasl-enc: SE98i7Iq7XFnAUgX7HDxqoXFDnqg+n4fNL92QRzeyoc+ 1180710420
Date: Fri, 1 Jun 2007 12:06:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Richard Hughes <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
Message-ID: <20070601150657.GD8211@khazad-dum.debian.net>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <200705312333.11477.dtor@insightbb.com> <20070601040824.GA5042@srcf.ucam.org> <200706010037.59496.dtor@insightbb.com> <20070601131324.GB12204@srcf.ucam.org> <d120d5000706010704h71c817a9p55e0bba5d54efd3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706010704h71c817a9p55e0bba5d54efd3f@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007, Dmitry Torokhov wrote:
> On 6/1/07, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> What I am trying to say - there already EVIOCSKEYCODE ioctl in the
> kernel. And for force feedback devices to work you need to nable
> writing to corresponding /dev/input/eventX thus opening possibility to
> alter the keymap table. I guess you coudl analyze capabilities of a
> device and only relax permissions for devices that have FF...

Agreed. CAP_SYSADMIN or somesuch should be required for some of those
IOCTLs, at least on keyboards. I don't see a problem with a digitizing
tablet relaxing that to allow anyone, for example, so it makes sense to punt
this test to the driver level (and not input layer level), or to make it
configurable somehow from the driver level before registering the input
device.

> Anyway, I think that we don't want ordinary users to alter hardware
> keymapping, it should indeed be priveleged operation done by box's
> administrator. Hopefully the infrastructure (hal/udev/whatever) will
> be able to load proper keymap at boot time so even that is not needed.
> 
> Why I think using kernel remapping_in addition_ to X remapping is better:

Agreed.

> The biggest cons for KEY_UNKNOWN + scancode is that presently we do
> not have the code to iteract with user.

Actually, it is more like "we don't have it, and it is non-trivial to do it
right", if I understood Matthew correctly.

> >> > The standard setup in an office environment is likely to be
> >> > multiuser.
> >>
> >> Huh? In my limited experience everyone in the office gets its own box.
> >> And I am not talking about software shop.
> >
> >Standard is that everyone gets their own machine, but usually everyone
> >has an account on all of them.
> 
> Which is never used (except remotely)...

Oh yes, it *is* used, and very much so.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
