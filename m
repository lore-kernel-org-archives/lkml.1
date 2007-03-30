Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbXC3DHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbXC3DHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbXC3DHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:07:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:18951 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbXC3DHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NGS9+gNgdI+v6+ewi0LVv/eUG2xEpiqT9/YOIzyv1KBnk1IaJd0k65tryy5tQ30VOa9fxee0ryULq301q+OpTJlak4IY8Hbtha8xDB+BVmRbZBeph1QAhLziYZW3mnMqyC6D0LMW9IVkOFUAoU1S24kj6xAZEZ5mldgcZHpSKwk=
Message-ID: <460C7EB4.9080009@gmail.com>
Date: Fri, 30 Mar 2007 11:06:28 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Li Yu <raise.sail@gmail.com>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com> <45FE6971.6090503@gmail.com>	 <1174897676.5815.6.camel@violet> <4609CAF2.3040303@ccoss.com.cn>	 <Pine.LNX.4.64.0703280945560.19566@jikos.suse.cz> <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
In-Reply-To: <d120d5000703281200wd914f51s18437a6a8e4107f6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 3/28/07, Jiri Kosina <jkosina@suse.cz> wrote:
>>
>> The crucial thing here is that all reports but the ones that the driver
>> registered to will be processed in a standard way by the generic hid bus
>> layer, and those reports that the driver registered to will be
>> ignored by
>> the layer, and passed for processing to the driver.
>>
>
> I don't think it is a good idea to register driver for specific
> usages/reports. Quite often you want to adjust processing of a report
> for a specific device. What if there are 2 devices that need such
> quirks? How will you do hotplug and module loading? Emit new uevent
> for every report? Also, what about users and Kconfig? "Driver for
> usage 0x000012345. Say Y if your hardware does not wotk correctly with
> defautl handler for this usage and require special processing"???
>
> Just register based on VID/PID and provide standard
> hid_default_input_event() to drivers so they would call it for reports
> they don't need to do special processing on.
>

    I think the shadow driver can not share inputdev with the related
fundamental driver, so here are two input devices for one hid_device,
how we should process both? It seem we have three choices:

1. Shadow | Fundamental means

    I think this is Jiri said. Fundamental driver handle all common
input events, and Shadow driver handle anther specific input events,
this imply user space process need monitor both input devices at same
time, I do not think this is good idea.

2. Shadow & Fundamental means

    Let Fundamental driver and Shadow driver work at same time! but
shadow also handle specific input event. So, the user may get twice
input events! For example, the keyboard input in console.
Also, I do not like this.

3. Shadow ^ Fundamental means

    Let Shadow driver handle every thing, and fundamental device silent,
even unregister it. I think this is best choice between them, this means
have a bit of complex.

Welcome for your words.

PS: Have we need more than one shadow driver for same fundamental
driver? I do not think so.

Good luck.

- Li Yu




