Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbZIUOiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbZIUOiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbZIUOit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:38:49 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47842 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbZIUOis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:38:48 -0400
X-Sasl-enc: wO6DCORjJqXkODlPRHUNsDAPkcXT+LcoPp5/3+PuNEmG 1253543922
Date: Mon, 21 Sep 2009 11:38:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ThinkPad T400 and the mute button ...
Message-ID: <20090921143840.GA7476@khazad-dum.debian.net>
References: <200909210935.29280.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200909210935.29280.toralf.foerster@gmx.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Toralf Förster wrote:
> It works - but only if the T400 is plugged into the docking station. Then both
> the mute button at the T400 and the button of the external keyboard works fine.
> However w/o the docking station pressing the mute button of the T400
> gives under KDE the graphical response "mute on" - but that's all, the sound
> isn't muted.
> 
> Is this behaviour known/expected or worth a bug report ?

1. go single user, text mode.  No userspace HAL/udev/KDE/GNOME crap allowed
for these tests ;-)

2. Test mute/unmute in both keyboards, and check *WHICH* audio outputs get
muted.  You have at least three: dock line-out, built-in speakers, built-in
headphone-out.  Remember that some thinkpads (those without a MUTE LED) use
a single press of volume up or down as unmute.

3. do the same testing using the alsa HDA mixer.

4. Anything that doesn't light-up the MUTE LED is doing it on the HDA mixer.
If you don't have a MUTE led, it gets far more difficult to know what is
happening :-(

5. thinkpad-acpi can tell you if the firmware thinks the internal MUTE gate
is enabled or not: cat /proc/acpi/ibm/volume.  It won't be able to *set*
mute state, AFAIK.  But it can read it.

> BTW the BIOS is at the latest level (I hoped to avoid the command line 
> eboot=pci w/ the new BIOS but no chance, that parameter is necessary to avoid

Get someone to write a proper, specific bug report that could be sent to a
BIOS engineer, pinpointing what is wrong and what should be fixed, and
either I or the SuSE people can forward it to Lenovo.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
