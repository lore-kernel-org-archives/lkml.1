Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZGFE4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZGFE4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 00:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZGFE4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 00:56:42 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:60084 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZGFE4l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 00:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oZV8Nz6zSsrg+eF1BboSh3VqVO6f5If3nsQdBT61+VsN6M9tO5GTAlpdm2IoRpNnAv
         jNGcP+MbE4YFWa08XjcFspNAXbWdkoKG64OatdEr7WWNMhQTXtny8ASRI7YsF7fuoJMg
         cG+JEYWaweuOJFFgXzBRB/dQ0oehogHRUDaHA=
MIME-Version: 1.0
In-Reply-To: <200907060038.18323.rgetz@blackfin.uclinux.org>
References: <1243622057-17671-1-git-send-email-jason.wessel@windriver.com> 
	<200907051254.41964.rgetz@blackfin.uclinux.org> <20090705191751.6bbf594c@lxorguk.ukuu.org.uk> 
	<200907060038.18323.rgetz@blackfin.uclinux.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 6 Jul 2009 00:56:24 -0400
Message-ID: <8bd0f97a0907052156m44483903i9b2f35428d1bbe62@mail.gmail.com>
Subject: Re: [PATCH 2/2] usb_serial: only allow sysrq on a console port
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com,
       Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 6, 2009 at 00:38, Robin Getz wrote:
> On Sun 5 Jul 2009 14:17, Alan Cox pondered:
>> > If Jason's patch is necessary () - should this be fixed up for
>> > standard UARTs too?
>>
>> I think so yes, although I'd not realised it wasn't protected currently
>> ?
>
> Hmm - try as I may - I can't get this to fail - so it must be protected
> somewhere....
>
> Ahh---
>
> It is in include/linux/serial_core.h:uart_handle_break() - never checked the
> header for the magic before I bugged you... sorry about that...
>
>> > The above patch would sync the (seemlying duplicated) code between
>> > drivers/usb/serial/generic.c and include/linux/serial_core.h
>>
>> There is a lot of near duplicate code like this. That is one reason for
>> adding struct tty_port. In theory both could be collapsed into
>>
>>       int tty_port_handle_sysrq(struct tty_port *port, unsigned int ch)
>>       {
>>       }
>>
>> at this point as both USB and serial layer UARTs now have a port object.
>> That would just need port->sysrq collapsing into the tty_port.
>> port->console sort of already is.
>
> It appears that the usb serial doesn't handle breaks like serial_core does. (I
> don't see any support for SAK in usb_serial either?)
>
> Maybe _that_ is the real problem that Jason is trying to work around???

perhaps, but what Jason proposed originally sounds pretty sane.  if i
enable sysrq support on my desktop, i dont want some development board
being able to send a sysrq request back over my serial port and
rebooting my desktop.
-mike
