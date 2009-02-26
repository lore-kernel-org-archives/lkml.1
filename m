Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZBZXxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZBZXxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZBZXxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:53:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:54818 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbZBZXxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:53:01 -0500
MIME-Version: 1.0
In-Reply-To: <ac3eb2510902261428n297063f5webb06fc105e5ef0a@mail.gmail.com>
References: <20090218151132.476.81706.stgit@localhost.localdomain>
	 <fa686aa40902180834r2b9b8de0tcdc31c850f6323a6@mail.gmail.com>
	 <ac3eb2510902180849o6d86bbfev337e1bc203d6543e@mail.gmail.com>
	 <fa686aa40902180951q64c71581y3811062256685df7@mail.gmail.com>
	 <ac3eb2510902181032h3f9ed994s212dd8b42ddca82@mail.gmail.com>
	 <20090218183945.GA31797@suse.de>
	 <fa686aa40902182250g1c4e7cb6o4d0102da35ab838b@mail.gmail.com>
	 <ac3eb2510902191508w71cf7d76x4a8957ecee9c4e6@mail.gmail.com>
	 <fa686aa40902200728k1466121cqb772bb9e5d1a777c@mail.gmail.com>
	 <ac3eb2510902261428n297063f5webb06fc105e5ef0a@mail.gmail.com>
Date: Thu, 26 Feb 2009 16:52:58 -0700
Message-ID: <fa686aa40902261552ibc36057p5e9173a0f8a5a8dd@mail.gmail.com>
Subject: Re: [PATCH] Export device_add_attributes() so drivers can use it.
From: Grant Likely <grant.likely@secretlab.ca>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, this is exactly what I want.  I'll read through and write up a
little blurb to describe the recommended model.

g.


On Thu, Feb 26, 2009 at 3:28 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Fri, Feb 20, 2009 at 16:28, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Thanks for the reply, it clarifies a lot.  It sounds like this really
>> should be documented (in Documentation/driver-model/device.txt?).  I'm
>> happy to add a blurb to that effect and send a patch, but I want to
>> make sure I really understand the model before I do so.  I've got a
>> couple more questions below:
>>
>> On Thu, Feb 19, 2009 at 4:08 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> [...]
>>> If an attribute is not available at event time, nothing of this can
>>> ever work. If you look a the device a second later, you will see the
>>> proper looking files and values, and all the test programs will work,
>>> but it will always fail at device creation.
>> [...]
>>> That all might not be needed for your specific setup/driver/device and
>>> may work fine for your need. But we don't want to encourage anybody
>>> with another new API which creates the usual trouble we need to fix
>>> later.
>>
>> Fair enough
>>
>>> And we need to fix things like this all the time.
>>
>> Can you point me at a 'textbook' example of one of these fixups?
>
> Here are a few cases of broken atribute timing, a quick git search has found:
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f7120a4f75168df3c02efacd10403a4ba0bcb29d
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8a89efd18aa15bb832778baa4e6eee3857ecada4
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3b23dd6f8a718e5339de4f7d86ce76a078b5f771
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2e5f10e4f0a9649186d8a8c793822b2e0dae8373
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bfd129445f23c037d9a440ebfa4109e11c220301
>
> Regarding the split of the driver device and the device to bind to:
> the platform stuff is kind of "special", because it is often used for
> devices/buses which can not be enumerated. With buses which need
> enumeration, it's pretty obvious that the enumeration creates their
> own devices, which then a driver can bind to, and where the driver
> creates its own driver instance for it. Like nobody would expect a
> network driver to add the netif properties directly to the pci device,
> and so on.
>
> Many platform devices are just static placeholders, and then it is not
> obvious that userspace still prefers another device instance while
> binding a driver, but in most cases it's worth the effort, because
> then all devices, regardless which bus is backing them, can be handled
> the same way with a "hotplug handler" like udev.
>
> Thanks,
> Kay
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
