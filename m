Return-Path: <linux-kernel-owner+w=401wt.eu-S965668AbXDBSi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668AbXDBSi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965672AbXDBSi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:38:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965668AbXDBSiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:38:55 -0400
Message-ID: <46114DAD.3060100@redhat.com>
Date: Mon, 02 Apr 2007 14:38:37 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Pavel Machek <pavel@ucw.cz>, David Zeuthen <davidz@redhat.com>,
       Maxim <maximlevitsky@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       gregkh@suse.de, Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
References: <Pine.LNX.4.44L0.0704011422460.1054-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704011422460.1054-100000@netrider.rowland.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sun, 1 Apr 2007, Pavel Machek wrote:
> 
>> Hi!
>>
>>>>>> The GNOME hath spoken?
>>>>> 	I also thought about that,
>>>>> 	
>>>>> 	I think that the best solution is still to hide connect/disconnect of usb devices from userspace (now it also causes corruption)
>>>>> 	But to refuse suspend with any usb mass storage device connected with mounted systems (and add a module param override
>>>>> 	 for users who know what they are doing)
>>>>>
>>>>> 	What do you think ?
>>>> Agreed... and notice how easy is to do that in userspace :-))).
>>> The problem with refusing to suspend with usb mass storage devices
>>> mounted is just not going to work; the way we want desktop power
>> Problem is that suspending _with_ removable mass storage devices
>> attached just will not work. User will unplug them, then complain
>> about corruption. Advanced user will unplug them, work with them
>> somewhere else, replug them, then loose filesystem.
>>
>> Feel free to send patch to teach filesystems to handle this.
> 
> Actually what's needed is a Persistent Logical Volume Manager.  With it,
> you could even mount a filesystem on a USB device, unplug the device, plug
> it back into a different port, and still be able to use the filesystem.
> 
> But you're still likely to run into trouble if you unplug a storage
> device, move it to another system and write on it, then plug it back into
> the original system.  The PLVM would somehow have to recognize that the
> data had been changed.  I don't know a foolproof way of doing that.
> 

Mark the filesystem as in-use with a one-time UUID in the superblock at
mount time. If one moved the drive to another system it would require
an fsck to clear the UUID before the other system could use it; then
the original machine would refuse to use the drive when the UUID didn't
match on resume.

