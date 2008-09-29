Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYI2UxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYI2UxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 16:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYI2Uwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 16:52:54 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:42877 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYI2Uwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 16:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ePmV8lHBteQGQ6NZuEjlb3luuVInelnzp81BYFJjtkKSR0Ha5wET3NrNIKwl5FGkuK
         k/RaZbL6YeKIR6wXoRghvmkoD6WlocX1FsMz8DzMYPDOW0nfUfbxyMnjs2MfWDybUDdc
         C25Dw8JI/9U9n+2vSOjefnKvTYrZpBHPoDsYw=
Message-ID: <9e4733910809291352r7a581cfel5a3212bebac4336@mail.gmail.com>
Date: Mon, 29 Sep 2008 16:52:40 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [RFC PATCH 0/4] Implementation of IR support using the input subsystem
Cc: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net,
       lirc@bartelmus.de
In-Reply-To: <48E1371A.7050906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080929155506.14559.35166.stgit@terra>
	 <48E1371A.7050906@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 4:14 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Jon Smirl wrote:
>>
>> Second pass at implementing evdev support for IR. The goal of in-kernel IR
>> is to integrate IR events into the evdev input event queue and maintain
>> ordering of events from all input devices.
>>
>> Note that user space IR device drivers can use the existing support in
>> evdev to inject events into the input queue.
>>
>> Send and receive are implemented. Received IR messages are decoded and
>> sent to user space as input messages. Send is done via an IOCTL on the input
>> device.
>>
>> Two drivers are supplied. mceusb2 implements send and receive support for
>> the Microsoft USB IR dongle.
>> The GPT driver implements receive only support for a GPT pin - GPT is a
>> GPIO with a timer attached.
>>
>> Encoders and decoders have not been written for all protocols. Repeat is
>> not handled for any protocol. I'm looking for help. There are 15 more
>> existing LIRC drivers.
>
>
> Hi,
>
> One thing worries me, there are bazillion of different IR protocols,
> but in-kernel decode support will mean that only handful of known protocols
> will work.
> Suppose I take an old remote which has some unknown protocol.
> I want to be able to teach the system to listen to it.
> But how this can be done if protocols are hard coded?

There's not a bazillion different protocols.

For example thirty different vendors may use the NEC encoding. They
will each use a unique device number and their own commands. While
each of the thirty vendors may assign different device/command codes
they are all still using the NEC encoding. These remotes won't trigger
the other devices because the device fields won't match.

This code only converts raw IR timing of NEC/etc encoding into
device/command. User space has to then figure out how to interpret
device/command.

Christoph has pointed out that their are some more obscure encodings
from RCMM, Grundig, Bang&Olufsen, Goldstar, Serial, Denon, RECS80, and
Motorola that are different than the common ones at
http://www.sbprojects.com.

It takes about 1KB of code to add an encoding. We could make an "extra
encoding" module for these obscure ones.

You can't have an infinite variety of encodings or table based
universal remote controls wouldn't work.


>
> I think that it would be much better to pass raw ir codes to userspace, and
> make it deal with bazillion protocols, and you can always make it auto learn
> too, and save
> results in configuration file.
>
> My .02 cents.
>
> Best regards,
>        Maxim Levitsky
>



-- 
Jon Smirl
jonsmirl@gmail.com
