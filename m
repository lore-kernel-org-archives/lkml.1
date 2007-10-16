Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbXJPO1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbXJPO1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbXJPO1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:27:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:14285 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbXJPO1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FDDXtUcL5JgRv0QyGITMZGeZbV00PD3PkVIAUF3R1D1KqmKKeMBrw+ZS1C2BAHPeqdL2frZPaCWPb7K3+38WzgcUnGYiPv0M9pPTdhnZY4hcvNz0CgYT/1HESUwAz9xzQgirWJknC/VnldB0khS4vCeaVGaTWglS182YONpPY+M=
Message-ID: <d120d5000710160727w3267b9a4td25d155d816ecee8@mail.gmail.com>
Date: Tue, 16 Oct 2007 10:27:11 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>, "Jeremy Katz" <katzj@redhat.com>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       davej@redhat.com
In-Reply-To: <20071016141153.GA3237@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>
	 <20071015210737.GA15293@khazad-dum.debian.net>
	 <20071016130053.GA20010@srcf.ucam.org>
	 <20071016141153.GA3237@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

On 10/16/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Tue, 16 Oct 2007, Matthew Garrett wrote:
> > On Mon, Oct 15, 2007 at 07:07:37PM -0200, Henrique de Moraes Holschuh wrote:
> > > And the input subsystem maintainer has made it extremely clear in various
> > > threads that the input devices are *not* to be used as a notification
> > > service for on-screen-display or other such stuff.

Yes, I think different transport (like netlink) is better suited as a
generic notification transport. Input devices are pretty "heavy"
objects to add them everywhere.

>  If you send volume and
> > > brightness *key* events to userspace, it is supposed to act on them and
> > > raise/lower brightness/volume, which is the wrong thing to do on thinkpads.
> > > Never mind that HAL is ignoring the input maintainer's directions and
> > > violating this.
> >
> > Reality disagrees. There are already several cases where notifications
>
> Yes, it does.  But none of it cannot be fixed, HAL is the really big
> offender in userspace, and laptop drivers are the really big offenders in
> kernel space.
>
> > are sent via the keyboard controller, such as the wireless and touchpad
> > disable keys on my HP. There are Dells that do the same for brightness
>
> It is not clear to me if they are notifications or not.  Does the firmware
> act on the keys by itself? If it does, then they are notifications.  If it
> does not, then they are regular hot keys and there is no controversy whether
> they belong on the input layer or not (they do).
>
> > keys. Unless you want to make the argument that sending keyboard
> > controller events through the input layer is the wrong thing to do, it's
> > impossible to standardise on a setup where we never see notifications
> > through it.
>

I want to add the ability to add "filetrs" to i8042 keyboard ports so
that certain bytes that represent state changes (battery events,
wireless, etc.) can be diverted from keyboard serio port (and atkbd
driver) and be processed by a separate driver(s).

> Well, I better make it clear once again. Please excuse me the very direct
> and acid tone in the rest of this email, I want to make certain points
> crystal clear to everyone (and not just you, I do believe you are already
> very aware of my position in this):
>
> 1. I am not against sending notification events through input (but see point
> two below).  However, AFAIK, Dmitry is.  He said as much in the last thread
> about it.  I have added him to the CC list, he can make his position clear
> in this thread, if I got it wrong.
>
> Until I get a "you can do it" from Dmitry, forget about thinkpad-acpi
> sending such events over the input layer.  I believe in a coherent kernel
> where the schizophrenia on the use of the various interfaces and subsystems
> is kept to a bare minimum.  If a subsystem maintainers tell me not to do
> something, I won't do it.
>
> 2. I am against sending notification events through input **that look
> exactly the same as regular events**.  That is not a wise design choice IMO,
> it is a very dirty hack.
>
> I did propose ways to fix that properly, though (and to write the patches to
> do so).  Two simple and clean ways come to mind:
>
>        1. Add a new EV_* class for such events.
>        2. Alternatively, add a flags field to the higher bits of EV_*
>           class that could be used to mark events in a proper way.
>
> And I am sure there are other ways too, so it *can* be done properly if it
> is to be done at all.  However, it was not accepted because Dmitry does not
> want notifications going over the input subsystem as far as I recall from
> that thread.  Get Dmitry to accept a way to send notifications though the
> input layer, and I will follow it.
>
> 3. We have a backlight class, a LED class, a rf-kill class and ALSA mixers.
> Is there a real reason to pester Dmitry about the issue, if we can use these
> alternate paths (that are indeed more generic and more suited for the job)?
>

My position is that we should not cram all notifications into input
layer. We need something lighter and more flexible, that can mix
together battery charging, brightness increased, network link appeared
type of events. Maybe something like dbus strings + originating sysfs
device.

-- 
Dmitry
