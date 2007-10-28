Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbXJ1RWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbXJ1RWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbXJ1RV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:21:58 -0400
Received: from mailgw2.3essentials.com ([66.179.153.59]:1907 "EHLO
	mailgw2.3essentials.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXJ1RV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:21:57 -0400
X-Greylist: delayed 899 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Oct 2007 13:21:57 EDT
Message-ID: <4724CF9F.6050908@antonello.org>
Date: Sun, 28 Oct 2007 19:06:23 +0100
From: "lists@antonello.org" <lists@antonello.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Dell laptop backlight driver
References: <4724B4F5.80004@antonello.org> <20071028161955.GF23359@auslistsprd01.us.dell.com>
In-Reply-To: <20071028161955.GF23359@auslistsprd01.us.dell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:
> On Sun, Oct 28, 2007 at 05:12:37PM +0100, jack@antonello.org wrote:
>> Hello,
>> this driver implements backlight control on Dell laptops
>> which use SMI  for changing brightness levels.
>>
>> The driver is INCOMPLETE since it is unable to probe some required 
>> parameters
>> in order to perform backlight control. Such parameters are found in a Dell
>> proprietary DMI table which should be parsed. For now external tools may be
>> used to find these parameters by hand. So if you intend to try this out,
>> FIRST write your laptop model parameters correctly inside the source code
>> as explained in Documentation/dell-laptop.txt.
>>
>> Parts of this driver may also be used to provide additional functionalities
>> similarly to the drivers/misc/*-laptop.c drivers.
> 
> Why is this better done in the kernel rather than in userspace with
> libsmbios as you've noted?
> 

I had to do a kernelspace driver for controlling the backlight. This
was part of a college project assignment. In order for it to be valid
for an operating system course, it had to be in kernelspace (not
Unix programming) :).

As i mentioned that can be done in userspace and it IS sensible to do
so. I know that the code which was already written for Dell implied
a userspace approach, but i simply had no choice.

I also don't expect this driver to become mainstream, but since i have
written it, other people might want to have a look at it.

Finally i really don't think there's any sensible way of implementing
Linux LCD Backlight Abstraction relying on a userspace application.
That would mean the kernel calling userspace code to change the
brightness, then this latter code would again call the kernel to trigger
a SMI and so on. That's just not a good design. I think a userspace
solution implies choosing NOT to implement the LCD Abstraction. Causing
Dell laptops to be treated differently from other machines (as they are
not compliant with Linux's own interface).

jacopo

