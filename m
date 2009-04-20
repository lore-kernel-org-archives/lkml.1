Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZDTGma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZDTGma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZDTGmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:42:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:27733 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZDTGmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:42:17 -0400
Message-ID: <49EC1945.1000805@petalogix.com>
Date: Mon, 20 Apr 2009 08:42:13 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Nate Straz <nate-ltp@refried.org>, subrata@linux.vnet.ibm.com,
       ltp-list@lists.sourceforge.net,
       John Williams <john.williams@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [LTP] statvfs -> f_bavail
References: <49E759FB.70103@petalogix.com> <49E847FB.1030801@petalogix.com> <20090417173107.GA3590@refried.org> <49EC1352.6010900@petalogix.com> <20090420062642.GY26366@ZenIV.linux.org.uk>
In-Reply-To: <20090420062642.GY26366@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, Apr 20, 2009 at 08:16:50AM +0200, Michal Simek wrote:
>   
>> Nate Straz wrote:
>>     
>>> On Apr 17 11:12, Michal Simek wrote:
>>>   
>>>       
>>>>> don't you know what is the description of f_bavail in struct statvfs?
>>>>> On my system I am getting zero for this entry that's why fsync02 failed.
>>>>>   
>>>>>       
>>>>>           
>>>> I track down where the problem comes from.
>>>> There is problem for all fs which use simple_statfs function from
>>>> fs/libfs.c.
>>>> In open.c in vfs_statfs function is whole structure set to zero and then
>>>> in simple_statfs not set this value.
>>>> I think we should fix it in ltp code.
>>>> Here is my proposed change. If is ok - I will generate proper patch.
>>>>     
>>>>         
>>> If the problem is in the kernel, then it should be fixed in the kernel.
>>> That's the whole point of LTP, pointing out problems in the kernel which
>>> need to be fixed.  Patching LTP to work around f_bavail not being set
>>> correctly is not the right thing to do.
>>>   
>>>       
>> :-) And what about if is the kernel code ok? :-)
>> Then IMHO is the right time to fix LTP.
>>
>> The main question is if is or not.
>>
>> Hi guys from linux-fsdevel: Can you told us what is the right solution
>> for my problem above?
>>     
>
> "Fields that are undefined for a particular file system are set to 0".
> So what kind of fs are you running that on and is that sucker really
> defined for it?  Note that if it's ramfs or tmpfs with -o nr_blocks=0,
> there is no such thing as "amount of free space", reserved for root
> or not.
I use ramfs and nfs without any -o nr_block=0 option.
That mean that for all other fs is possible to set nr_blocks=0 (f_bavail=0) and for all this cases
fsync02 test failed. That mean that make sense to test f_bavail value in LTP and if is zero
don't work with it. Am I right?

Thanks,
Michal

# mount
rootfs on / type rootfs (rw)
proc on /proc type proc (rw)
none on /var type ramfs (rw)
none on /sys type sysfs (rw)
192.168.0.102:/tftpboot/nfs on /mnt type nfs
(rw,vers=3,rsize=32768,wsize=32768,namlen=255,hard,nointr,nolock,proto=tcp,timeo=70,retrans=3,sec=sys,addr=192.168.0.102)



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

