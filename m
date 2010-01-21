Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375Ab0AUVj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0AUVj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610Ab0AUVj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:39:27 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:62193 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0AUVj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:39:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jR7Zd6nR6bF4FApbvH7ENqsOIU0WXonLjwO0a/QU7RbpcP9QbOKe0/3WEyOCoAPksL
         enq1iBYksdIW1yobU6XDGyiHtuKmIkqnzObOe1e96ImhHfcW/Hqln9Do96Rfq9PeBGr9
         EC8CbeZ6sI0oGPiW0vKDwGetY/8+28+oHIchg=
MIME-Version: 1.0
In-Reply-To: <20100121185544.GB11996@core.coreip.homeip.net>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
	 <20100121185544.GB11996@core.coreip.homeip.net>
Date: Thu, 21 Jan 2010 15:39:25 -0600
Message-ID: <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Robert Hancock <hancockrwd@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 12:55 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Jan 20, 2010 at 06:41:56PM -0600, Robert Hancock wrote:
>> On 01/20/2010 12:23 PM, Bastien Nocera wrote:
>> >As those computers never had any i8042 controllers, and the
>> >current lookup code could potentially lock up/hang/wait for
>> >timeout for long periods of time.
>> >
>> >Fixes intermittent hangs on boot on a MacbookAir1,1
>> >
>> >Signed-off-by: Bastien Nocera<hadess@hadess.net>
>>
>> I assume this is happening because of this code in
>> drivers/input/serio/i8042-x86ia64io.h:
>>
>>         if (!i8042_pnp_kbd_devices && !i8042_pnp_aux_devices) {
>>                 i8042_pnp_exit();
>> #if defined(__ia64__)
>>                 return -ENODEV;
>> #else
>>                 printk(KERN_INFO "PNP: No PS/2 controller found.
>> Probing ports directly.\n");
>>                 return 0;
>> #endif
>>
>> In other words, on x86, if PNP and/or ACPI don't indicate any PS/2
>> controller exists, we randomly bang on the ports in the expectation
>> they'll be there anyway. This seems rather misguided.
>
> Basically, we do not trust BIOS writers on x86 ;) In the past there were
> occasions when they forgot to mention presence of KBD/AUX in DSDT and
> elsewhere which lead to non-functional keyboard/mouse.

Are we certain about that? Any pointers to reports?

>
>> It would seem
>> like a better idea to fix this rather than adding yet another DMI
>> list (especially since there likely are, or will be, machines
>> without i8042 other than Macs).
>>
>
> If they are not Macs that mean they are tested with windows and thus
> expect probes in i8042 port region so no harm done. In a few years if
> everyone uses USB only we could add a year threshold to trust ACPI/PNP
> data.

Macs will be tested with Windows too, so obviously it manages to avoid
this problem somehow, and I very much doubt it has an Apple-specific
check..
