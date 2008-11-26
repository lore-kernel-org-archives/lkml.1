Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYKZK0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYKZK0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 05:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYKZKZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 05:25:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:3878 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYKZKZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 05:25:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QXyeNrRPUDmhEh+QYS+iRf63o9MeRjmeEqNyeKc0yOeeluMKvPFJLlGnieDk4mIq0S
         mifAzRxeUreAViQrBhSJCqDrKBlfAF0SJYfDXnnoUTtVHPgz3tjXtiFvQT7gunWZ+NCE
         SL/VNso8KBuXn/pvhhToG0LvSkrvqKuGRXTNI=
Message-ID: <45a44e480811260225k5dc2bedal41ccac33626f3b4c@mail.gmail.com>
Date: Wed, 26 Nov 2008 05:25:57 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [Linux-fbdev-devel] [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Cc: "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Greg KH" <greg@kroah.com>, linux-kernel@vger.kernel.org,
       "David Brownell" <david-b@pacbell.net>,
       "Ben Gardner" <bgardner@wabtec.com>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Russell King" <rmk@arm.linux.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811261106180.2632@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <492D125D.5010607@teltonika.lt>
	 <45a44e480811260118v440716bbqa8d37c8b696c148a@mail.gmail.com>
	 <Pine.LNX.4.64.0811261106180.2632@anakin>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 5:08 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, 26 Nov 2008, Jaya Kumar wrote:
>> On Wed, Nov 26, 2008 at 4:09 AM, Paulius Zaleckas
>> <paulius.zaleckas@teltonika.lt> wrote:
>> > Jaya Kumar wrote:
>> >>   * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
>> >>   *   implementation may not sleep
>> >>   * @dbg_show: optional routine to show contents in debugfs; default code
>> >> @@ -84,6 +86,9 @@ struct gpio_chip {
>> >>                                               unsigned offset, int value);
>> >>       void                    (*set)(struct gpio_chip *chip,
>> >>                                               unsigned offset, int value);
>> >> +     void                    (*set_bus)(struct gpio_chip *chip,
>> >> +                                             unsigned offset, int values,
>> >
>> > I think values should be unsigned
>> >
>>
>> Okay, can do but it is unusual no? since set uses int value, i figured
>> set_bus should be similar right?
>
> ->set() sets one pin, right? So it's either 0 or 1.
>
> ->set_bus() sets multiple pins. With `int', it will fail for bit 31, as that's
> the sign bit.

I'm not sure I understood this. I imagine the usage will be like

int values = 0x8000_0000;
set_bus(..., start_pin, values);

write_32(register, values); // will still work to set bit 31
(values >> 31) == 1;

>
> Perhaps you even want u32, to make it clear what's the maximum number of pins
> you can set in one shot?

Yes, I agree, I will change to use u32 as it is then explicit.

Thanks,
jaya
