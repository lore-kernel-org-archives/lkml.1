Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXJJRcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXJJRcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXJJRcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:32:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37915 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbXJJRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:32:17 -0400
Date: Wed, 10 Oct 2007 10:30:22 -0700
From: Greg KH <greg@kroah.com>
To: Martin Bligh <mbligh@mbligh.org>
Cc: Tejun Heo <htejun@gmail.com>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver
	model
Message-ID: <20071010173022.GA11125@kroah.com>
References: <11902755392688-git-send-email-htejun@gmail.com> <20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com> <20071005061812.GA16914@kroah.com> <4705EF30.8010002@gmail.com> <20071009224820.GE21228@kroah.com> <470D0ADB.2060007@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470D0ADB.2060007@mbligh.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 10:24:43AM -0700, Martin Bligh wrote:
>> The rules for sysfs files are the following:
>> 	- one value, in text format, per file.
>> 	- no action apon open/close
>> 	- binary files are only allowed for "pass-through" type files
>> 	  that the kernel does not touch (like for firmware and pci
>> 	  config space)
>> 	- directories should be associated with a kobject where it makes
>> 	  sense (no nesting deep subdirectories without a kobject
>> 	  present)
>> 	- when a directory is created/removed, a uevent should happen
>> 	  declaring what type of device was created/removed.
>
> So you'll be removing:
>
> /sys/devices/system/node/node?/meminfo
>
> then?
>
> along with:
>
> /sys/devices/system/node/node?/distance
> /sys/devices/system/node/node?/numastat
>
> and all the other things that violate the rules?

I would love to do that :)

And that goes to show how trying to enforce these kinds of rules is damm
hard.  Things slip by that I never notice because they are only for odd
types of hardware :)

> (which I do agree with ... I just don't think sysfs works for
> performance stats as we've discussed several times before ;-))

I agree that this doesn't work too, but also that if it's really needed,
it can be done, just let us know about it (like
/sys/block/BLOCKDEV/stat)

thanks,

greg k-h
