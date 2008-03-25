Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYCYXAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYCYXAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYCYXAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:00:25 -0400
Received: from ns1.suse.de ([195.135.220.2]:33886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbYCYXAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:00:23 -0400
Date: Tue, 25 Mar 2008 16:00:09 -0700
From: Greg KH <gregkh@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Message-ID: <20080325230009.GA25062@suse.de>
References: <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de> <20080325123454.4eba7644.randy.dunlap@oracle.com> <47E96263.9000808@zytor.com> <20080325212032.GA24495@suse.de> <47E96E15.7020105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E96E15.7020105@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 02:26:45PM -0700, H. Peter Anvin wrote:
> Greg KH wrote:
>> On Tue, Mar 25, 2008 at 01:36:51PM -0700, H. Peter Anvin wrote:
>>> Randy Dunlap wrote:
>>>>> Come on people, adding symlinks for device major:minor numbers in sysfs
>>>>> to save a few 10s of lines of userspace code?  Can things get sillier?
>>>>>
>>>>> You can add a single udev rule to probably build these in a tree in 
>>>>> /dev
>>>>> if you really need such a thing...
>>>>>
>>>>> And what's wrong with your new ioctl recomendation?
>>>> Ah, there's some sanity.  :)
>>> It's not so much an issue of a few tens of lines of user space code, but 
>>> rather the fact that something that should be O(1) is currently O(n).
>> "should"?  why?  Is this some new requirement that everyone needs?  I've
>> _never_ seen anyone ask for the ability to find sysfs devices by
>> major:minor number in O(1) time.  Is this somehow a place where such
>> optimization is warranted?
>
> Well, when dealing with shell scripts a O(n) very easily becomes O(n^2).  
> For the stuff that I, personally, do, it's not a big deal, but people with 
> large number of disks have serious gripes with our boot times.

How does this have anything to do with boot times?  Do you really have a
foolish shell script that iteratorates over every single disk in the
sysfs tree for every disk?  What does it do that for?

I thought we were talking about 2TB disks here, with a proposed new
ioctl, not foolishness of boot scripts...
