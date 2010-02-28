Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968386Ab0B1Od4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 09:33:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44239 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968176Ab0B1Ody convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 09:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PqWQYAnWmEjyVGZ6GK6pLpwif6VgljZIT65vKmuvgHEoI1Md/ELeNTZcy15upX8G77
         cDluu49VZlHYaEx6Q+84wjpK2Gon06vh/ET9GWXTpqqhPxb6ON6G8WNobYKd9hnI3WP6
         ON3P+d1/S7u54at1but9HZ2IwOjbSxiSoKlQ8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1002280444530.16775@p34.internal.lan>
References: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan>
	 <20100228080100.092c24c2@notabene.brown>
	 <alpine.DEB.2.00.1002271624480.12663@p34.internal.lan>
	 <4B89B44A.70005@tmr.com>
	 <alpine.DEB.2.00.1002280444530.16775@p34.internal.lan>
Date: Sun, 28 Feb 2010 09:33:52 -0500
Message-ID: <170fa0d21002280633x2ea6a281tf53996834c46d831@mail.gmail.com>
Subject: Re: mdadm software raid + ext4, capped at ~350MiB/s limitation/bug?
From: Mike Snitzer <snitzer@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 4:45 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Sat, 27 Feb 2010, Bill Davidsen wrote:
>
>> Justin Piszcz wrote:
>>>
>>>
>>> On Sun, 28 Feb 2010, Neil Brown wrote:
>>>
>>>> On Sat, 27 Feb 2010 08:47:48 -0500 (EST)
>>>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>>
>>>>> Hello,
>>>>>
>>>>> I have two separate systems and with ext4 I cannot get speeds greater
>>>>> than
>>>>> ~350MiB/s when using ext4 as the filesystem on top of a raid5 or raid0.
>>>>> It appears to be a bug with ext4 (or its just that ext4 is slower for
>>>>> this
>>>>> test)?
>>>>>
>>>>> Each system runs 2.6.33 x86_64.
>>>>
>>>> Could be related to the recent implementation of IO barriers in md.
>>>> Can you try mounting your filesystem with
>>>>  -o barrier=0
>>>>
>>>> and see how that changes the result.
>>>>
>>>> NeilBrown
>>>
>>> Hi Neil,
>>>
>>> Thanks for the suggestion, it has been used here:
>>> http://lkml.org/lkml/2010/2/27/66
>>>
>>> Looks like an EXT4 issue as XFS does ~600MiB/s..?
>>>
>>> Its strange though, on a single hard disk, I get approximately the same
>>> speed for XFS and EXT4, but when it comes to scaling across multiple disks,
>>> in RAID-0 or RAID-5 (tested), there is a performance problem as it hits a
>>> performance problem at ~350MiB/s.  I tried multiple chunk sizes but
>>> nothing
>>> seemed to made a difference (whether 64KiB or 1024KiB), XFS performs at
>>> 500-600MiB/s no matter what and EXT4 does not exceed ~350MiB/s.
>>>
>>> Is there anyone on any of the lists that gets > 350MiB/s on a mdadm/sw
>>> raid
>>> with EXT4?
>>>
>>> A single raw disk, no partitions:
>>> p63:~# dd if=/dev/zero of=/dev/sdm bs=1M count=10240
>>> 10240+0 records in
>>> 10240+0 records out
>>> 10737418240 bytes (11 GB) copied, 92.4249 s, 116 MB/s
>>
>> I hate to say it, but I don't think this measures anything useful. When I
>> was doing similar things I got great variabilty in my results until I
>> learned about the fdatasync option so you measure the actual speed to the
>> destination and not the disk cache. After that my results were far slower
>> and reproducible.
>
> fdatasync:
> http://lkml.indiana.edu/hypermail/linux/kernel/1002.3/01507.html

How did you format the ext3 and ext4 filesystems?

Did you use mkfs.ext[34] -E stride and stripe-width accordingly?
AFAIK even older versions of mkfs.xfs will probe for this info but
older mkfs.ext[34] won't (though new versions of mkfs.ext[34] will,
using the Linux "topology" info).
