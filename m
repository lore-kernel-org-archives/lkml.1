Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZHYAR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZHYAR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZHYAR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:17:28 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:57517 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZHYAR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:17:27 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2009 20:17:27 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RbdcSRD2xM3M7d53eDB5OPpcKNrGmVDHV3FpyzO61QTn8e8hkfTH8u98ADb8i2iblQ
         dTcdA2Lo4zpYQcifFhbXeXdMzGqQx4QSPR4IG0HEekt+OdmgssS6xtO/slyAFnO5uNMX
         9Y+PMW/5L2BY64GvAFGWGOcBO+1u9sPBuZtCo=
MIME-Version: 1.0
In-Reply-To: <20090810090508.69E02526EC9@mailhub.coreip.homeip.net>
References: <ac71f2bb0908061315o1449e91dge1d5a63a2a4b986a@mail.gmail.com>
	 <20090810090508.69E02526EC9@mailhub.coreip.homeip.net>
Date: Mon, 24 Aug 2009 17:09:20 -0700
Message-ID: <ac71f2bb0908241709i1afa2cedy62c3dc13982f4fb7@mail.gmail.com>
Subject: Re: serio / atkbd / PS/2 Strangeness with Serial port adapter
From: Matt Causey <matt.causey@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 1:34 AM, Dmitry
Torokhov<dmitry.torokhov@gmail.com> wrote:

>> [  459.004227] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1,
>> 12, timeout) [445118]
>> [20171.684870] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 0,
>> 1) [20162195]
>>
>> However - the atkbd driver does not pick the device up at all.
>>
>
> Your device is steadely refusing to say that it is a keyboard - and so
> atkbd driver does not bind to it.
>
>> So, I did find a workaround (which is NOT acceptable for this
>> deployment).  Remember the PS/2 'wedge' I mentioned?  Well, it has an
>> extra PS/2 port for your keyboard.  If I connect a PS/2 keyboard to
>> that thing, suddenly my scanner starts working.
>>
>> We see some chatter from the controller driver, then one of these:
>>
>> [23811.805578] input: AT Translated Set 2 keyboard as
>> /devices/platform/i8042/serio0/input/input6
>>
>
> That happened because apparently the 'wedge' passes the inquirys to
> the real keyboard and it answers propery.
>
> I think the "i8042.dumbkbd" kernel parameter will solve your issue.
>
> --
> Dmitry
>

That's great.  I think it's the only option that I did not try.  ;-)
Works great!

In case it matters:

blah blah/ # dmesg | grep i8042
[    0.000000] Kernel command line: initrd=ramdisk.gz
video="vesafb:mtrr,ywrap,1024x768-32@85" i8042.dumbkbd
BOOT_IMAGE=bzImage auto
[   14.046511] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.046578] serio: i8042 AUX port at 0x60,0x64 irq 12
[   15.804210] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
blah blah/ #

Looks like it just decides that there must be a keyboard there,
whether or not there really is one.

Are there any downsides to using this kernel parameter?

Thanks!

--
Matt
