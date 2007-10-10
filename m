Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbXJJS0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbXJJS0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 14:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbXJJS0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 14:26:33 -0400
Received: from dvhart.com ([64.146.134.43]:47933 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbXJJS0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 14:26:33 -0400
Message-ID: <470D1958.3060703@mbligh.org>
Date: Wed, 10 Oct 2007 11:26:32 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <htejun@gmail.com>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver	model
References: <11902755392688-git-send-email-htejun@gmail.com> <20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com> <20071005061812.GA16914@kroah.com> <4705EF30.8010002@gmail.com> <20071009224820.GE21228@kroah.com> <470D0ADB.2060007@mbligh.org> <20071010173022.GA11125@kroah.com>
In-Reply-To: <20071010173022.GA11125@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Oct 10, 2007 at 10:24:43AM -0700, Martin Bligh wrote:
>>> The rules for sysfs files are the following:
>>> 	- one value, in text format, per file.
>>> 	- no action apon open/close
>>> 	- binary files are only allowed for "pass-through" type files
>>> 	  that the kernel does not touch (like for firmware and pci
>>> 	  config space)
>>> 	- directories should be associated with a kobject where it makes
>>> 	  sense (no nesting deep subdirectories without a kobject
>>> 	  present)
>>> 	- when a directory is created/removed, a uevent should happen
>>> 	  declaring what type of device was created/removed.
>> So you'll be removing:
>>
>> /sys/devices/system/node/node?/meminfo
>>
>> then?
>>
>> along with:
>>
>> /sys/devices/system/node/node?/distance
>> /sys/devices/system/node/node?/numastat
>>
>> and all the other things that violate the rules?
> 
> I would love to do that :)
> 
> And that goes to show how trying to enforce these kinds of rules is damm
> hard.  Things slip by that I never notice because they are only for odd
> types of hardware :)

Is there no way to enforce that in the sysfs interface?
(Haven't looked, I'll admit).

>> (which I do agree with ... I just don't think sysfs works for
>> performance stats as we've discussed several times before ;-))
> 
> I agree that this doesn't work too, but also that if it's really needed,
> it can be done, just let us know about it (like
> /sys/block/BLOCKDEV/stat)

OK. Would be nice if we could get rid of /sys/devices/system at
some point, which seems like a fairly crazy path, but still ;-)

M.
