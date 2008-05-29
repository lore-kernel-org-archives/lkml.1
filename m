Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbYE2VQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbYE2VQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYE2VQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:16:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35971 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755259AbYE2VQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:16:26 -0400
X-Sasl-enc: M5J1HFK4zxT2mhoZWjRYHhEdVoAGBNpGeE2oUT6G2XoK 1212095784
Date: Thu, 29 May 2008 18:16:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify
	input subsystem interactions (v2)
Message-ID: <20080529211621.GA18419@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805291919.04384.IvDoorn@gmail.com> <20080529172252.GB3375@khazad-dum.debian.net> <200805291940.09563.IvDoorn@gmail.com> <20080529174620.GD3375@khazad-dum.debian.net> <20080529145256.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529145256.ZZRA012@mailhub.coreip.homeip.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Dmitry Torokhov wrote:
> I wonder why thinkpad_acpi has to go through Len, it seems to live
> in drivers/misc... Does it depend on some other ACPI changes that
> are not in mainline/-mm yet? If it not I'd probably bombard Andrew
> with it.

No, the patches in question don't depend on anything at all other than
thinkpad-acpi itself.  If there were no thinkpad-acpi patches "in
flight" in need to get to mainline soon, there would be no problem at
all... but at least one of them clashes with the SW_RFKILL_ALL patch.

thinkpad-acpi merges through Len Brown because that's probably the best
subsystem for it to be tied to right now.  It uses various other
subsystems, like the input layer, hwmon, LEDs and rfkill, but it makes
extremely heavy use of the ACPI subsystem to actually *do* something.

But patches to thinkpad-acpi do not HAVE to always go through Len, as
they never modify anything in ACPI proper.

> Alternatively SW_RFKILL_ALL can be brought in through wireless three
> or I can add it to my "for_linus" branch that I want Linus to pull
> soon.

I would be thankful if you could merge the input layer SW_RFKILL_ALL
patch ASAP through your for_linus branch, as that's probably the fastest
way to get the whole rfkill stack in its way to the linux-next tree.

The SW_RFKILL_ALL patch is the only real dependency of the rfkill
patches on anything.  If that gets merged now, I can immediately send
the rfkill stack to wireless-dev AND respin the two thinkpad-acpi
patches that are pending on Len's hands to apply without issues on top
of a tree that already had SW_RADIO renamed.

I will send the SW_RFKILL_ALL patch in a version that applies on top of
Linus git tree to you in a few moments.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
