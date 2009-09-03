Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZICOTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZICOTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZICOTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:19:55 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54817 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbZICOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vpP3at+i1kjt7jI4ECOrPWel4z/H50f5qznUzYbqsuC2F8pUtWuLbhbH/nQ1NYN9x3
         SIpkyciaI68bGFKUSsPME9hve3CqzLI0S8vHjdkz/+Gj7V3f5oevJSfvG6gVGLUS6jHE
         8y+K3rQ5EL0//Aer/GJXEp/E23xEGXFa8w9n0=
MIME-Version: 1.0
In-Reply-To: <1251984455.3336.24.camel@johannes.local>
References: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
	 <a32f33a40909030454y51905525g15a65cc8364b8eb5@mail.gmail.com>
	 <20090903122727.GA4465@matterhorn.verdurent.com>
	 <1251984455.3336.24.camel@johannes.local>
Date: Thu, 3 Sep 2009 16:19:53 +0200
Message-ID: <a32f33a40909030719t43ca7fabpe2c9f77f94999b53@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Get rid of duplicate usb id from rt2500usb
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Amit Kucheria <amit.kucheria@canonical.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 3:27 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-09-03 at 15:27 +0300, Amit Kucheria wrote:
>> On 09 Sep 03, Ivo Van Doorn wrote:
>> > > USB_DEVICE(0x148f, 0x2573) is served by the rt73usb driver where it is already
>> > > defined. Remove it from rt2500usb.
>> > >
>> > > Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
>> > > Cc: Ivo van Doorn <IvDoorn@gmail.com>
>> >
>> > NACK
>> >
>> > Users have reported that this is a valid rt2500usb ID. You can thank the
>> > manufacturer of the dongle to produce dongles with the same USB ID but
>> > with different chipsets.
>> >
>> > Ivo
>>
>> Interesting. On my laptop, without this patch both the drivers are loaded
>> (lsmod), rt2500usb aborts without allocating a device successfully but I am
>> unable to associate to the AP.
>
> Sounds like the detection logic is somehow messing with the device, or
> rt2500usb isn't actually freeing the device for rt73usb to bind?

That would be odd, I believe it is working with other devices with
duplicate ID's
where first rt2500usb is loaded and then rt73usb. As far as connecting to the
device, the first thing rt2x00 does is reading the EEPROM and checking the
chipset. So no registers are being written which could upset a rt73usb device.

Ivo
