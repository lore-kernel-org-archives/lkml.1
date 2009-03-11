Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbZCKHUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbZCKHUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 03:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZCKHUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 03:20:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:60709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZCKHUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 03:20:31 -0400
Message-ID: <49B76640.6010109@kernel.org>
Date: Wed, 11 Mar 2009 16:20:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
 per kobj
References: <20090310232027.GC25665@ldl.fc.hp.com> <20090311044151.GB25840@suse.de> <20090311070359.GF25665@ldl.fc.hp.com>
In-Reply-To: <20090311070359.GF25665@ldl.fc.hp.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Mar 2009 07:20:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Greg KH <gregkh@suse.de>:
>> On Tue, Mar 10, 2009 at 05:20:27PM -0600, Alex Chiang wrote:
>>> Hi Vegard, sysfs folks,
>>>
>>> Vegard was nice enough to test my PCI remove/rescan patches under
>>> kmemcheck. Maybe "torture" is a more appropriate term. ;)
>>>
>>> My patch series introduces a sysfs "remove" attribute for PCI
>>> devices, which will remove that device (and child devices).
>>>
>>> 	http://thread.gmane.org/gmane.linux.kernel.pci/3495
>>>
>>> Vegard decided that he wanted to do something like:
>>>
>>> 	# while true ; do echo 1 > /sys/bus/pci/devices/.../remove ; done
>>>
>>> which caused a nasty oops in my code. You can see the results of
>>> his testing in the thread I referenced above.
>>>
>>> After looking at my code for a bit, I decided that maybe it
>>> wasn't completely my fault. ;) See, I'm using device_schedule_callback()
>> why?  Are you really in interrupt context here to need to do the remove
>> at a later time?
> 
> What other interface can I use to remove objects from sysfs?

I haven't read your code yet but I seem to recall doing something
similar.  Ah.. okay, this one didn't get in and I forgot about this.

  http://thread.gmane.org/gmane.linux.kernel/582130

But, yeah, committing suicide is currently quite hariy.  I tought SCSI
did it correctly with all the grab/release dances.  Does SCSI have the
problem too?

Thanks.

-- 
tejun
