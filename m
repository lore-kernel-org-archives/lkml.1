Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbYKWW6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbYKWW6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 17:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYKWW6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 17:58:41 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:56696 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYKWW6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 17:58:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hAOB+bFRIAn6CLbz3SHP+hj90DGp5nsqJ1+izB0ryzc33F7twt/ovk/zhWjMci2ph+
         UxFWe54HDxY0lzK3PguJjZYeAaVgNjj86rgUY3EXG3oqnDWBTAkgNA9C4MPzh7cUB2qN
         MKAc+JAaMOoYaPqxQjfjRDFov7jQ+g2QQaiiI=
Message-ID: <9e4733910811231458s10482c93ie94999664d1e5189@mail.gmail.com>
Date: Sun, 23 Nov 2008 17:58:38 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Christoph Bartelmus" <lirc@bartelmus.de>
Subject: Re: In-kernel IR remote control support
Cc: jkosina@suse.cz, jrm8005@gmail.com, linux-kernel@vger.kernel.org,
       pavel@suse.cz
In-Reply-To: <AqQUJV3JjFB@christoph>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LRH.1.10.0811232128050.26670@twin.jikos.cz>
	 <AqQUJV3JjFB@christoph>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 5:28 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> Hi,
>
> on 23 Nov 08 at 21:33, Jiri Kosina wrote:
>> On Sun, 23 Nov 2008, Christoph Bartelmus wrote:
>
>>> You can have LIRC setup to decode all common remote control protocols.
>>> It's just a matter of proper packaging and pre-configuration. You don't
>>> have to write a single line of code for this (I still have to add uinput
>>> support, though, which I probably would have done by now, if I weren't
>>> busy writing posts like this).
>
>> Just a question -- how much is the situation different to what we
>> currently have for HID devices?
>>
>> For these, we currently have common code, that is able to handle all the
>> "normal" devices by default, that are fully compliant with the HID
>> standard.
>> For the devices that don't behave that well, we have specialized drivers,
>> that use all the generic HID infrastructure to handle the
>> standard-compliant behavior of the device and allows the specialized
>> drivers to implement only the parts that violate standard.
>>
>> It's pretty lightweight and seems to work well. Wouldn't this work also
>> for LIRC drivers?
>
> No. Unlike with HID devices, with most IR receivers you can use any
> remote. In LIRC we write drivers for the receivers and don't care about
> the remote, which is handled in userspace. The suggested approach would
> move both receiver and remote handling into kernel space (actually only
> part of it because many receivers have userspace drivers, so both receiver
> and remote handling must be done in userspace anyway for these receivers).

Now that I've worked on this for a while, I'm moving towards putting
all of the IR drivers in the kernel. Putting them in the kernel
collects them in a single place where they can't get lost and they
will be maintained on all archs. Sure you can write these drivers in
user space too. But they are so small (10-20K), they are hardly
noticeable in the kernel when compared to a 4MB Nvidia device driver.

I'm also a big fan of using existing kernel interfaces and not
building new ones. Evdev, sysfs and configfs can implement everything
IR needs and all of them are pre-existing APIs.

The code I'm post is not being marked for inclusion in the kernel. It
is being posted RFC - request for comment. Various features aren't
implement (repeat, more protocol engines, etc). There are bugs too.
After I added configfs support I discovered that interrupt handling
needs to be altered since configfs was being called from interrupt
context and that;s not allowed. I'm traveling now and will fix it when
I get back next week.

I'd like to get some input on the general design but so far nobody
have commented on the design.


>
> Christoph
>



-- 
Jon Smirl
jonsmirl@gmail.com
