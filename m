Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXJPOMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXJPOMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932387AbXJPOMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:12:00 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35414 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932218AbXJPOL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:11:59 -0400
X-Sasl-enc: 6YFiIHIWt3joQ67T5VFdhY6+dYplEH1bX9IAI6Us3u0X 1192543916
Date: Tue, 16 Oct 2007 12:11:53 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Message-ID: <20071016141153.GA3237@khazad-dum.debian.net>
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <20071015210737.GA15293@khazad-dum.debian.net> <20071016130053.GA20010@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016130053.GA20010@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Matthew Garrett wrote:
> On Mon, Oct 15, 2007 at 07:07:37PM -0200, Henrique de Moraes Holschuh wrote:
> > And the input subsystem maintainer has made it extremely clear in various
> > threads that the input devices are *not* to be used as a notification
> > service for on-screen-display or other such stuff.  If you send volume and
> > brightness *key* events to userspace, it is supposed to act on them and
> > raise/lower brightness/volume, which is the wrong thing to do on thinkpads.
> > Never mind that HAL is ignoring the input maintainer's directions and
> > violating this.
> 
> Reality disagrees. There are already several cases where notifications 

Yes, it does.  But none of it cannot be fixed, HAL is the really big
offender in userspace, and laptop drivers are the really big offenders in
kernel space.

> are sent via the keyboard controller, such as the wireless and touchpad 
> disable keys on my HP. There are Dells that do the same for brightness 

It is not clear to me if they are notifications or not.  Does the firmware
act on the keys by itself? If it does, then they are notifications.  If it
does not, then they are regular hot keys and there is no controversy whether
they belong on the input layer or not (they do).

> keys. Unless you want to make the argument that sending keyboard 
> controller events through the input layer is the wrong thing to do, it's 
> impossible to standardise on a setup where we never see notifications 
> through it.

Well, I better make it clear once again. Please excuse me the very direct
and acid tone in the rest of this email, I want to make certain points
crystal clear to everyone (and not just you, I do believe you are already
very aware of my position in this):

1. I am not against sending notification events through input (but see point
two below).  However, AFAIK, Dmitry is.  He said as much in the last thread
about it.  I have added him to the CC list, he can make his position clear
in this thread, if I got it wrong.

Until I get a "you can do it" from Dmitry, forget about thinkpad-acpi
sending such events over the input layer.  I believe in a coherent kernel
where the schizophrenia on the use of the various interfaces and subsystems
is kept to a bare minimum.  If a subsystem maintainers tell me not to do
something, I won't do it.

2. I am against sending notification events through input **that look
exactly the same as regular events**.  That is not a wise design choice IMO,
it is a very dirty hack.

I did propose ways to fix that properly, though (and to write the patches to
do so).  Two simple and clean ways come to mind:

	1. Add a new EV_* class for such events.
	2. Alternatively, add a flags field to the higher bits of EV_*
	   class that could be used to mark events in a proper way.

And I am sure there are other ways too, so it *can* be done properly if it
is to be done at all.  However, it was not accepted because Dmitry does not
want notifications going over the input subsystem as far as I recall from
that thread.  Get Dmitry to accept a way to send notifications though the
input layer, and I will follow it.

3. We have a backlight class, a LED class, a rf-kill class and ALSA mixers.
Is there a real reason to pester Dmitry about the issue, if we can use these
alternate paths (that are indeed more generic and more suited for the job)?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
