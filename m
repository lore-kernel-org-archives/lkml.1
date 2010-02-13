Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab0BMVHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 16:07:25 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:33781 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab0BMVHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 16:07:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=afGp56sDCAKgKzvaG1gq8pX3cKyc9UwmDtji/529F85i2lEtDz0oFNYfufiys85DUy
         QaKTlFt3ocGVqAqyOKyxrDduB2z5eEDPL5NZq8ZEGai+iT9t3GDcMf5rqDN6ROln5CA7
         rCpnwEcREoQHiw8wHb63zVMpP6/VuQDQXgzK8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002131248390.4721@asgard.lang.hm>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
	 <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
	 <4B77044B.1020609@zytor.com>
	 <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
	 <alpine.DEB.2.00.1002131248390.4721@asgard.lang.hm>
Date: Sat, 13 Feb 2010 13:07:22 -0800
Message-ID: <4877c76c1002131307i61a3c985w8db8c10623a693c8@mail.gmail.com>
Subject: Re: Linux mdadm superblock question.
From: Michael Evans <mjevans1983@gmail.com>
To: david@lang.hm
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 12:49 PM,  <david@lang.hm> wrote:
> On Sat, 13 Feb 2010, Justin Piszcz wrote:
>
>> On Sat, 13 Feb 2010, H. Peter Anvin wrote:
>>
>>> On 02/11/2010 05:52 PM, Michael Evans wrote:
>>>>
>>>> On Thu, Feb 11, 2010 at 3:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com>
>>>> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> I may be converting a host to ext4 and was curious, is 0.90 still the
>>>>> only
>>>>> superblock version for mdadm/raid-1 that you can boot from without
>>>>> having to
>>>>> create an initrd/etc?
>>>>>
>>>>> Are there any benefits to using a superblock > 0.90 for a raid-1 boot
>>>>> volume
>>>>> < 2TB?
>>>>>
>>>>> Justin.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>>> You need the superblock at the end of the partition:  If you read the
>>>> manual that is clearly either version 0.90 OR 1.0 (NOT 1.1 and also
>>>> NOT 1.2; those use the same superblock layout but different
>>>> locations).
>>>
>>> 0.9 has the *serious* problem that it is hard to distinguish a
>>> whole-volume
>>>
>>> However, apparently mdadm recently switched to a 1.1 default.  I
>>> strongly urge Neil to change that to either 1.0 and 1.2, as I have
>>> started to get complaints from users that they have made RAID volumes
>>> with newer mdadm which apparently default to 1.1, and then want to boot
>>> from them (without playing MBR games like Grub does.)  I have to tell
>>> them that they have to regenerate their disks -- the superblock occupies
>>> the boot sector and there is nothing I can do about it.  It's the same
>>> pathology XFS has.
>>>
>>>        -hpa
>>>
>>
>> My original question was does the newer superblock do anything special or
>> offer new features *BESIDES* the quicker resync?
>
> the older superblocks have limits on the number of devices that can be part
> of the raid set.
>
> David Lang
>

The 1.1 and 1.2 formats ALSO play more nicely with stacking partition
contents.  LVM, filesystems, and partition info all begin at the start
of a block device; putting the md labels there too makes it obvious
what order to unpack the structures in.
