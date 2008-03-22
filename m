Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYCVHKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYCVHKO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 03:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYCVHKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 03:10:01 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49024 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbYCVHKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 03:10:00 -0400
X-Sasl-enc: D5uk5D/Engc061WUp6YmoPKprjCH+a6MRbNtmHqyRjC7 1206169798
Date: Sat, 22 Mar 2008 04:09:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] Input: add flags bitfield
Message-ID: <20080322070955.GA10719@khazad-dum.debian.net>
References: <1205698451-1640-1-git-send-email-hmh@hmh.eng.br> <20080321160048.ZZRA012@mailhub.coreip.homeip.net> <1206136586.14058.1243686863@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206136586.14058.1243686863@webmail.messagingengine.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Henrique de Moraes Holschuh wrote:
> On Fri, 21 Mar 2008 16:07:01 -0400, "Dmitry Torokhov"
> <dmitry.torokhov@gmail.com> said:
> > On Sun, Mar 16, 2008 at 05:14:11PM -0300, Henrique de Moraes Holschuh wrote:
> > > Add a flags bitfield to the input_dev structure, which can be used for
> > > internal coordination among kernel input devices and input handlers without
> > > the need to use ever-expanding blacklists on the input handlers.
> > > 
> > > Add initial flag bits which allows an input driver to request that joystick
> > > emulation (joydev) or mouse emulation (mousedev) not be attached to an
> > > input device.
> > > 
> > > This will be used by accelerometer drivers exporting a raw interface which
> > > is not to be used as a joystick device (not to confuse this with the usual
> > > fuzzed joystick interface these drivers export for enhanced Neverball
> > > productivity), for example.
> > 
> > I'd rather not apply this patch because it pushes kowledge of existing
> > input interfaces into device drivers. What we could do instead is add
> > a 'type' field to the input device structure and then input interfaces
> > (evdev/mousedev, etc) could have an option of matching either by device
> > type or by device capabilities or both. Your raw devices could have type
> > of accelerometer and joydev would bind to devices with type "joystick"
> > or "unknown" + certain capabilities. Will this work?
> 
> It would solve my problem, yes.
> 
> But I'd prefer if joydev and mousedev did not bind to
> unknown+capabilities, just in case.  Looks like bad form to me, and
> might bite us back later on.  We can properly fix all drivers in-tree
> to have suitable types for joydev and/or mousedev binds, rfkill binds,
> and so on after all.

Drat, removing unknown+capabilities means I'd have to hunt down every
frigging input device in the tree to annotate its type... otherwise, it
would cause regressions re. the handlers.  It is a work that needs to be
done anyway, only adding type metadata to new devices and leaving the
rest to report "unknown" is just icky.

Come to think of it, what about uinput?  It would need to be able to set
the device type as well, otherwise mousedev and joydev, for example,
would not attach to uinput-created input devices.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
