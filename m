Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbXFAPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbXFAPVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 11:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbXFAPVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 11:21:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:57013 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701AbXFAPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 11:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bF4kMy3678P+3k+N54GI673wPuattuTGcRYm16uLAb7H4/Js6Iwrh+nDLqvCsfOZR9FA4UHkh5wSZ77nW7S34kJart9XcqpVQ2eBDraWxE2ysHQXK6CPzGKtNgV/5gjzkOpgedCEIpfmGTdjMAEB4foSA6aOlUCE/STx0IXAe8o=
Message-ID: <d120d5000706010821g6ce613eqa1c3738f01469b4@mail.gmail.com>
Date: Fri, 1 Jun 2007 11:21:34 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Richard Hughes" <hughsient@gmail.com>, linux-acpi@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20070601150657.GD8211@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11802004861625-git-send-email-hmh@hmh.eng.br>
	 <200705312333.11477.dtor@insightbb.com>
	 <20070601040824.GA5042@srcf.ucam.org>
	 <200706010037.59496.dtor@insightbb.com>
	 <20070601131324.GB12204@srcf.ucam.org>
	 <d120d5000706010704h71c817a9p55e0bba5d54efd3f@mail.gmail.com>
	 <20070601150657.GD8211@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Fri, 01 Jun 2007, Dmitry Torokhov wrote:
> > On 6/1/07, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > What I am trying to say - there already EVIOCSKEYCODE ioctl in the
> > kernel. And for force feedback devices to work you need to nable
> > writing to corresponding /dev/input/eventX thus opening possibility to
> > alter the keymap table. I guess you coudl analyze capabilities of a
> > device and only relax permissions for devices that have FF...
>
> Agreed. CAP_SYSADMIN or somesuch should be required for some of those
> IOCTLs, at least on keyboards. I don't see a problem with a digitizing
> tablet relaxing that to allow anyone, for example, so it makes sense to punt
> this test to the driver level (and not input layer level), or to make it
> configurable somehow from the driver level before registering the input
> device.

That is going to be a bitch to implement for HID devices which can be
all of the above at once.

>
> > Anyway, I think that we don't want ordinary users to alter hardware
> > keymapping, it should indeed be priveleged operation done by box's
> > administrator. Hopefully the infrastructure (hal/udev/whatever) will
> > be able to load proper keymap at boot time so even that is not needed.
> >
> > Why I think using kernel remapping_in addition_ to X remapping is better:
>
> Agreed.
>
> > The biggest cons for KEY_UNKNOWN + scancode is that presently we do
> > not have the code to iteract with user.
>
> Actually, it is more like "we don't have it, and it is non-trivial to do it
> right", if I understood Matthew correctly.
>

Yes, here I agree. There are quirks to be worked out.

There is one more thing. If we alias KEY_FN_ESC through KEY_FN_B as
KEY_GENACT* this will give us 20 general-purpose actions. If we add
something like EVIOGSCANCODE to retrieve reverse mapping then
distributions like Matthew's can just scan new input devices in udev
and remap to KEY_GENACT* while we employ KEY_UNKNOWN + scancode on
kernel level.

> > >> > The standard setup in an office environment is likely to be
> > >> > multiuser.
> > >>
> > >> Huh? In my limited experience everyone in the office gets its own box.
> > >> And I am not talking about software shop.
> > >
> > >Standard is that everyone gets their own machine, but usually everyone
> > >has an account on all of them.
> >
> > Which is never used (except remotely)...
>
> Oh yes, it *is* used, and very much so.

Ok, different experiences I guess...

-- 
Dmitry
