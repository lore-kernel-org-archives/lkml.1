Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXIOQzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXIOQzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 12:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXIOQzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 12:55:44 -0400
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:59291 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbXIOQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 12:55:44 -0400
X-Greylist: delayed 4191 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 12:55:43 EDT
Message-ID: <46EBFE4B.7000002@gmail.com>
Date: Sat, 15 Sep 2007 18:46:19 +0300
From: Anssi Hannula <anssi.hannula@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070831)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: sysfs change of input/event devices in 2.6.23rc breaks udev
References: <46E2D712.1010402@gmail.com> <d120d5000709100624s4fd7e68djf8654a4d591cbb5d@mail.gmail.com> <20070915010519.34bcb9ae.akpm@linux-foundation.org> <200709151018.16076.dtor@insightbb.com>
In-Reply-To: <200709151018.16076.dtor@insightbb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Saturday 15 September 2007 04:05, Andrew Morton wrote:
>> On Mon, 10 Sep 2007 09:24:04 -0400 "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:
>>
>>> On 9/10/07, Greg KH <gregkh@suse.de> wrote:
>>>> On Mon, Sep 10, 2007 at 01:28:47AM -0400, Dmitry Torokhov wrote:
>>>>> On Sunday 09 September 2007 19:03, Kay Sievers wrote:
>>>>>> On 9/8/07, Anssi Hannula <anssi.hannula@gmail.com> wrote:
>>>>>>> However, the change that broke id_path of udev is that
>>>>>>> /sys/class/input/event5/device is now a symlink to the inputX directory
>>>>>>> instead of being the same as the device symlink in inputX directory,
>>>>>>> i.e. to ../../../devices/platform/pcspkr in this case.
>>>>>>>
>>>>>>> Udev id_path uses that directory to construct the ID_PATH variable.
>>>>>>> Should the sysfs structure be reverted or should udev be adapted to
>>>>>>> handle traversing /device symlink twice? I think the former, as there
>>>>>>> should be considerably more time to adapt udev for coming changes in sysfs.
>>>>>> Udev's path_id script is too dumb to follow the "device" link of
>>>>>> stacked class devices in the CONFIG_SYSFS_DEPRECATED=y layout. Does
>>>>>> this change fix it for you?
>>>>>>   http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff_plain;h=b1ac36ff5e3756cefc79967a26280056da31bf6f
>>>>>>
>>>>> Hmm, fixing udev is good but users will not get the change in time. I think we
>>>>> need to adjust SYSFS_DEPRECATED code to produce old results. Something like the
>>>>> patch below. I wonder what Greg would think...
>>>> Hm, I don't understand.  Didn't the original conversion of the input
>>>> layer by Kay not have this kind of problem?  What did your changes do
>>>> differently to cause this driver core change to be needed?
>>>>
>>> If I understand it correctly Kay's convesion had the same issue. With
>>> class devices "device" link points to class_dev->device instead of
>>> class_dev->parent. If you want to keep compatibility with old sysfs
>>> layout when moving from class devices to regular devices then you need
>>> to "skip" couple of parents till you get to "real" device. This only
>>> matters for input because this was the only subsystem with class
>>> devices stacked.
>>>
>> <wonders where the rest of this thread went to>
> 
> Limbo ;)
> 
> Anssi, could you please tell me if the patch fixes the issue on your box?

It does.

>> Did this userspace-visible post-2.6.22 regression get fixed?
>>
> 
> I'd like the patch to go through Greg if he is OK with it.
> 


-- 
Anssi Hannula
