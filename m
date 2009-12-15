Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbZLOGk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbZLOGk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZLOGk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:40:26 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:51048 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZLOGk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:40:26 -0500
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200E9C6@mi8nycmail19.Mi8.com>
References: <20091208102842.GH12264@elf.ucw.cz>
	 <4B203575.6050407@bluewatersys.com>
	 <20091210172458.GJ19454@elf.ucw.cz>
	 <4B2150B7.3040207@bluewatersys.com>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com>
	 <20091211221015.GB24456@elf.ucw.cz>
	 <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com>
	 <20091214064545.GK5114@elf.ucw.cz>
	 <1260813293.13078.15.camel@c-dwalke-linux.qualcomm.com>
	 <BD79186B4FD85F4B8E60E381CAEE19090200E9C6@mi8nycmail19.Mi8.com>
Date: Mon, 14 Dec 2009 22:40:19 -0800
Message-ID: <d6200be20912142240q5e7785e6h57fae538a5f4ea4e@mail.gmail.com>
Subject: Re: GPIO support for HTC Dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Daniel Walker <dwalker@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Iliyan Malchev <malchev@google.com>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 10:12 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> On Monday, December 14, 2009 10:55 AM, Daniel Walker wrote:
>> On Mon, 2009-12-14 at 07:45 +0100, Pavel Machek wrote:
>>> Hi!
>>>
>>>> This looks MUCH better!
>>>
>>> Thanks :-).
>>>
>>>>> arch/arm/Kconfig                     |    1
>>>>> arch/arm/mach-msm/board-dream-gpio.c |  327 +++++++++--------------------------
>>> ...
>>>> Please update (or remove) this diffstat.  It no longer matches the patch.
>>>
>>> I was just showing differences to _previous_ version, not what I was sending.
>>>
>>>> Ok.  The hardware still seems a bit strange. Is there any datasheet
>>>> available?
>>>
>>> I don't think there is one. Daniel, can you help here?
>>
>> I don't know if there is one or not (I'd guess not).. I can't release
>> documents, but I could try to address specific questions or find people
>> to answer specific questions.
>
> Hello Daniel,
>
> My specific question was about the gpio hardware registers.
>
> From Pavel's implementation it appears that the gpio's are organized as a
> number of 8-bit ports.  Each of these ports only have one 8-bit register.
> Writing a '1' to a bit in the register makes the associated pin a high-level
> output.  Writing a '0' makes the pin a low-level output or an input pin.
> Reading the port at this point will return the actual 'input' level of the pin.
>
> The hardware seems a bit strange and I just wanted to verify that this is
> correct.  If it is, this would explain the need to keep the 'shadow' contents
> of the port in order to set the 'direction' of a pin.
>
> I was also wondering if the initial 'shadow' value needs to be written to the
> port at init in order to correctly establish the output value for specific
> pins.
>
> One other thing.  Are the gpio's handled by Pavel's driver actually from the
> MSM chip or from an external CPLD?  The registers are all defined as:
>
> +               .reg = reg_num + DREAM_CPLD_BASE,
>
> If they are external from the MSM chip this driver should probably be renamed
> to something more appropriate since it is probably dream specific and not
> generic to the msm architecture.

These are board specific gpios. I think it would be less confusing if
the msm gpio support was added first.

-- 
Arve Hjønnevåg
