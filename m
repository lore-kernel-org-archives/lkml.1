Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYI2WTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYI2WTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYI2WTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:19:32 -0400
Received: from smtp21.orange.fr ([80.12.242.48]:23154 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYI2WTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:19:31 -0400
X-ME-UUID: 20080929221928143.22FA21C00085@mwinf2118.orange.fr
Message-ID: <48E15447.1000200@laposte.net>
Date: Tue, 30 Sep 2008 00:18:47 +0200
From: =?ISO-8859-1?Q?Emmanuel_Fust=E9?= <emmanuel.fuste@laposte.net>
Reply-To: emmanuel.fuste@laposte.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] Implementation of IR support using the input
 subsystem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 080929-0, 29/09/2008), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jon Smirl wrote:
> On Mon, Sep 29, 2008 at 4:14 PM, Maxim Levitsky 
> <maximlevitsky@gmail.com> wrote:
> > Jon Smirl wrote:
> >>
> >> Second pass at implementing evdev support for IR. The goal of 
> in-kernel IR
> >> is to integrate IR events into the evdev input event queue and maintain
> >> ordering of events from all input devices.
> >>
> >> Note that user space IR device drivers can use the existing support in
> >> evdev to inject events into the input queue.
> >>
> >> Send and receive are implemented. Received IR messages are decoded and
> >> sent to user space as input messages. Send is done via an IOCTL on 
> the input
> >> device.
> >>
> >> Two drivers are supplied. mceusb2 implements send and receive 
> support for
> >> the Microsoft USB IR dongle.
> >> The GPT driver implements receive only support for a GPT pin - GPT is a
> >> GPIO with a timer attached.
> >>
> >> Encoders and decoders have not been written for all protocols. 
> Repeat is
> >> not handled for any protocol. I'm looking for help. There are 15 more
> >> existing LIRC drivers.
> >
> >
> > Hi,
> >
> > One thing worries me, there are bazillion of different IR protocols,
> > but in-kernel decode support will mean that only handful of known 
> protocols
> > will work.
> > Suppose I take an old remote which has some unknown protocol.
> > I want to be able to teach the system to listen to it.
> > But how this can be done if protocols are hard coded?
>
> There's not a bazillion different protocols.
>
> For example thirty different vendors may use the NEC encoding. They
> will each use a unique device number and their own commands. While
> each of the thirty vendors may assign different device/command codes
> they are all still using the NEC encoding. These remotes won't trigger
> the other devices because the device fields won't match.
>
> This code only converts raw IR timing of NEC/etc encoding into
> device/command. User space has to then figure out how to interpret
> device/command.
>
> Christoph has pointed out that their are some more obscure encodings
> from RCMM, Grundig, Bang&Olufsen, Goldstar, Serial, Denon, RECS80, and
> Motorola that are different than the common ones at
> http://www.sbprojects.com.
>
> It takes about 1KB of code to add an encoding. We could make an "extra
> encoding" module for these obscure ones.
>
> You can't have an infinite variety of encodings or table based
> universal remote controls wouldn't work.
>
Yes, in kernel clean/smalls (encoding/)decoding engines abstracted by 
the input subsystem
are a good thing.
But you still need a way to send and received raw IR signal  to be able 
to send or
decode very out of spec signals like RC5 timing dependent  Philips 
service mode
codes. Or simply to decode / reverse engineer an IR protocol not already 
implemented
by a kernel encoder/decoder.

>
> >
> > I think that it would be much better to pass raw ir codes to 
> userspace, and
> > make it deal with bazillion protocols, and you can always make it 
> auto learn
> > too, and save
> > results in configuration file.
> >
> > My .02 cents.
> >
> > Best regards,
> >        Maxim Levitsky
> >
>
>
>
> -- 
> Jon Smirl
> jonsmirl@gmail.com

Best regards,
Emmanuel.

