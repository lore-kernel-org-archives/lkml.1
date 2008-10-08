Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYJHNGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYJHNGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 09:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYJHNGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 09:06:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:7258 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYJHNGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 09:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wmqeHqDepIbDSwN4K+F+SIKU+RZ8W+vDT8NSnhF0BtTkMfSNlC2exG+kr/a9nGcha7
         Zm8C/UctihfLpQosVF7uY3gkKQ3oc/FOnwSHmpAfYql5rYTRroXb4DHunmoH+BKNFrf/
         fm3me07QtuF7ya4V67xa3y7XIg0K016EdDqqw=
Message-ID: <9e4733910810080606ne8bdbb8v81d42069c985ae98@mail.gmail.com>
Date: Wed, 8 Oct 2008 09:06:30 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Bill Gatliff" <bgat@billgatliff.com>
Subject: Re: Toggling GPIO at 38Khz
Cc: "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48ECA101.8010604@billgatliff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
	 <48ECA101.8010604@billgatliff.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2008 at 8:01 AM, Bill Gatliff <bgat@billgatliff.com> wrote:
> Jon Smirl wrote:
>
>>
>> Are there other techniques for generating pulse trains in the 36-56Khz
>> range on a simple GPIO pin?
>>
>
> Yes.
>
> Use the GPIO pin to enable the output of an external circuit.  Or, hope that the
> GPIO pin in question is multiplexed with a timer/counter or PWM peripheral.
>
> But somehow, I don't think either answer is what you were looking for.  :)

The existing LIRC driver for a serial port is here:
http://lirc.cvs.sourceforge.net/viewvc/lirc/lirc/drivers/lirc_serial/lirc_serial.c?view=markup

An example of serial based hardware is here:
http://iguanaworks.net/product2.psp

These are external boards people buy to use with MythTV. They are most
commonly used on the x86, but the NSLU2 has been modified to use them
too.

The hardware can't be changed, people have bought thousands of these devices.

Many people cut up a serial cable and solder it themselves...
http://www.lirc.org/transmitters.html

The problems with these devices are obvious, I use a USB one for my
own system. It has a PIC chip in it with PWM out.


>
> 36 KHz bit-banging is a reach for any processor running Linux, methinks.  Maybe
> you could launch an FIQ (assuming ARM) and then do the bit-bang as a burst in
> there, so that you would have more control over the timing.  But that kind of
> code isn't going to play well with the rest of the kernel...
>
> If the hardware design isn't set, you might want to consider using that GPIO
> line as a quasi-SPI link to a small, AVR-type microcontroller that does the
> bit-banging on your behalf.  Long-term, that's going to be a more reliable and
> flexible solution I think.
>
>
> b.g.
> --
> Bill Gatliff
> bgat@billgatliff.com
>



-- 
Jon Smirl
jonsmirl@gmail.com
