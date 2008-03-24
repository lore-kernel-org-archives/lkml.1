Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYCXBLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYCXBLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 21:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYCXBLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 21:11:48 -0400
Received: from mxsf09.insightbb.com ([74.128.0.79]:48273 "EHLO
	mxsf09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbYCXBLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 21:11:47 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Mar 2008 21:11:47 EDT
X-IronPort-AV: E=Sophos;i="4.25,544,1199682000"; 
   d="scan'208";a="316979750"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALKZ5kdi3KTd/2dsb2JhbACmBQ
X-IronPort-AV: E=Sophos;i="4.25,544,1199682000"; 
   d="scan'208";a="123709122"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] Input: add flags bitfield
Date: Sun, 23 Mar 2008 21:02:07 -0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
References: <1205698451-1640-1-git-send-email-hmh@hmh.eng.br> <1206136586.14058.1243686863@webmail.messagingengine.com> <20080322070955.GA10719@khazad-dum.debian.net>
In-Reply-To: <20080322070955.GA10719@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803232102.07268.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2008, Henrique de Moraes Holschuh wrote:
> On Fri, 21 Mar 2008, Henrique de Moraes Holschuh wrote:
> > On Fri, 21 Mar 2008 16:07:01 -0400, "Dmitry Torokhov"
> > <dmitry.torokhov@gmail.com> said:
> > > On Sun, Mar 16, 2008 at 05:14:11PM -0300, Henrique de Moraes Holschuh wrote:
> > > > Add a flags bitfield to the input_dev structure, which can be used for
> > > > internal coordination among kernel input devices and input handlers without
> > > > the need to use ever-expanding blacklists on the input handlers.
> > > > 
> > > > Add initial flag bits which allows an input driver to request that joystick
> > > > emulation (joydev) or mouse emulation (mousedev) not be attached to an
> > > > input device.
> > > > 
> > > > This will be used by accelerometer drivers exporting a raw interface which
> > > > is not to be used as a joystick device (not to confuse this with the usual
> > > > fuzzed joystick interface these drivers export for enhanced Neverball
> > > > productivity), for example.
> > > 
> > > I'd rather not apply this patch because it pushes kowledge of existing
> > > input interfaces into device drivers. What we could do instead is add
> > > a 'type' field to the input device structure and then input interfaces
> > > (evdev/mousedev, etc) could have an option of matching either by device
> > > type or by device capabilities or both. Your raw devices could have type
> > > of accelerometer and joydev would bind to devices with type "joystick"
> > > or "unknown" + certain capabilities. Will this work?
> > 
> > It would solve my problem, yes.
> > 
> > But I'd prefer if joydev and mousedev did not bind to
> > unknown+capabilities, just in case.  Looks like bad form to me, and
> > might bite us back later on.  We can properly fix all drivers in-tree
> > to have suitable types for joydev and/or mousedev binds, rfkill binds,
> > and so on after all.

Ohne word - HID.

> 
> Drat, removing unknown+capabilities means I'd have to hunt down every
> frigging input device in the tree to annotate its type... otherwise, it
> would cause regressions re. the handlers.  It is a work that needs to be
> done anyway, only adding type metadata to new devices and leaving the
> rest to report "unknown" is just icky.
> 
> Come to think of it, what about uinput?  It would need to be able to set
> the device type as well, otherwise mousedev and joydev, for example,
> would not attach to uinput-created input devices.
> 

That's why I thinkg unmarked should really be default and only few selected
devices should set their type.

-- 
Dmitry
