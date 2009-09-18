Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZIRMP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZIRMP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZIRMP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:15:56 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:33727 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZIRMPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rdn6M+TSlohDG5n/eyyss7TG/UA9wG5tjAn91wy7Ofx6f1qaaCjGOzbeKxzWQEMh4N
         /bz2M70NO4CqD/0eip7u2NYmQO9uRUKTQix9tzY0HQDxbj2rtiYVf/FoxefSgMOhlTwd
         n1frCBhtafgtqdgqoFK00SKm3NLaW3rQxIewY=
MIME-Version: 1.0
In-Reply-To: <20090918061529.GB7717@kroah.com>
References: <7eb6a4d80909170549k7a19eb01s8975fe2c5f230cee@mail.gmail.com>
	 <7eb6a4d80909170552na322914x23b65d60bb56e20d@mail.gmail.com>
	 <20090918061529.GB7717@kroah.com>
Date: Fri, 18 Sep 2009 14:15:57 +0200
Message-ID: <7eb6a4d80909180515k48ee2197q8f6e5ff8933c4647@mail.gmail.com>
Subject: Re: New ark3116 driver - how to get included into kernel?
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ondrej Zary <linux@rainbow-software.org>, ark3116_driver@auctionant.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thanks for your reply.

2009/9/18 Greg KH <greg@kroah.com>:
> On Thu, Sep 17, 2009 at 02:52:29PM +0200, Bart Hartgers wrote:
>> (Sorry for sending an HTML-ized version of this mail before)
>>
>> Hi All,
>>
>> I managed to write an improved ark3116 driver after I figured out that
>> it is just an 16450 UART with some USB glue logic.
>>
>> The attached files can be compiled outside the kernel tree, and work
>> for 2.6.31. However, I would like this driver to (eventually) end up
>> in the kernel tree. In order to get there, who should I sent patches
>> against what? I've contributed code to the kernel before, but not in
>> the last 5 or so years, so I am a bit out of touch.
>
> Take a look at the file, Documentation/SubmittingPatches, it should
> describe what you need to do.
>
Thanks. But the question I had was more that I didn't know where to
put a new driver. In drivers/usb/serial, or perhaps in
drivers/staging. Anyway, if we are going to replace the existing
driver, it is obvious what the patch should be against.

>> Compared to the old ark3116 driver this one offers the following improvements:
>>  - cts/rts handshake support
>>  - break signalling
>>  - line error detection
>
> Why can't you just send patches adding support for these features to the
> existing driver?  It shouldn't be that much different between the two
> versions, right?

The difference is actually quite significant. The old driver is pretty
much a dumb parameterized replay of the windows usb-snoops. The new
driver actually "understands" the hardware. That's why I made a
completely new driver in the first place. A diff between the two is
ore or less the same as a complete replacing. I could try to minimize
the differences, but I would be surprised if more than 30% of the
lines will be shared, and most of those will be red tape, not actual
code. The patch will be hard to read anyhow.

>
> That's the preferred method, I'd like to not drop the existing one if at
> all possible.
>

Do you think it is worth the effort to minimize the diff, or should I
just replace ark3116.c by ark3116new.c?

Groeten,
Bart

> thanks,
>
> greg k-h
>



-- 
Bart Hartgers - New e-mail: bart.hartgers@gmail.com
