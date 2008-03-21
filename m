Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbYCUV4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbYCUV4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbYCUV43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:56:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58658 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757446AbYCUV41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:56:27 -0400
Message-Id: <1206136586.14058.1243686863@webmail.messagingengine.com>
X-Sasl-Enc: JUFh180J5Q5aJUjGxX2E2O2yA4mT7hAUuabI2a4+G0NL 1206136586
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <rpurdie@rpsys.net>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1205698451-1640-1-git-send-email-hmh@hmh.eng.br>
   <20080321160048.ZZRA012@mailhub.coreip.homeip.net>
Subject: Re: [PATCH] Input: add flags bitfield
In-Reply-To: <20080321160048.ZZRA012@mailhub.coreip.homeip.net>
Date: Fri, 21 Mar 2008 18:56:26 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 16:07:01 -0400, "Dmitry Torokhov"
<dmitry.torokhov@gmail.com> said:
> On Sun, Mar 16, 2008 at 05:14:11PM -0300, Henrique de Moraes Holschuh wrote:
> > Add a flags bitfield to the input_dev structure, which can be used for
> > internal coordination among kernel input devices and input handlers without
> > the need to use ever-expanding blacklists on the input handlers.
> > 
> > Add initial flag bits which allows an input driver to request that joystick
> > emulation (joydev) or mouse emulation (mousedev) not be attached to an
> > input device.
> > 
> > This will be used by accelerometer drivers exporting a raw interface which
> > is not to be used as a joystick device (not to confuse this with the usual
> > fuzzed joystick interface these drivers export for enhanced Neverball
> > productivity), for example.
> 
> I'd rather not apply this patch because it pushes kowledge of existing
> input interfaces into device drivers. What we could do instead is add
> a 'type' field to the input device structure and then input interfaces
> (evdev/mousedev, etc) could have an option of matching either by device
> type or by device capabilities or both. Your raw devices could have type
> of accelerometer and joydev would bind to devices with type "joystick"
> or "unknown" + certain capabilities. Will this work?

It would solve my problem, yes.

But I'd prefer if joydev and mousedev did not bind to
unknown+capabilities,
just in case.  Looks like bad form to me, and might bite us back later
on.
We can properly fix all drivers in-tree to have suitable types for
joydev
and/or mousedev binds, rfkill binds, and so on after all.

What did I miss?  Are there drivers for some sort of generic device that
would be unable to set their type bitfields at runtime?

BTW: as far as I can see, type should be a bitfield or a list, to allow
a
device to have more than one type.  Is that fine with you?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

