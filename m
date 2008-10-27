Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYJ0Vyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYJ0Vyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYJ0Vy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:54:26 -0400
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:40418 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751595AbYJ0VyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:54:25 -0400
X-YMail-OSG: nRTDMpEVM1lhN3S7hCZxO3pJESEwvkPikGrgQVChciBInVkPsXSymv_cgBSBpdajhfbOQYjnOZNyt_3UA6DBR3eLUJZsC4DSvSmB6lRAHwhyiG9TDJ1a34Al6bLO4YXl0GhqFYbASLzfDR2aU.KHySSTt0I5DkQckD4XPHIcNGx4rlrY7sq0iUztwAU-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49063888.6050904@schaufler-ca.com>
Date: Mon, 27 Oct 2008 14:54:16 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Rob MacKinnon <c4blem0nkey@gmail.com>
CC: Stephen Smalley <sds@tycho.nsa.gov>, rob.mackinnon@gmail.com,
       Andreas Gruenbacher <agruen@suse.de>, hpa@zytor.com, hugh@veritas.com,
       linux-kernel@vger.kernel.org
Subject: Re: tmpfs support of xattrs?
References: <4902DD98.4090302@gmail.com>	 <Pine.LNX.4.64.0810261148480.14974@blonde.site>	 <200810261425.58892.agruen@suse.de>  <4906211E.8030603@gmail.com> <1225139131.31818.51.camel@moss-spartans.epoch.ncsc.mil> <49062BD5.5050802@gmail.com>
In-Reply-To: <49062BD5.5050802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob MacKinnon wrote:
> Stephen Smalley wrote:
>   
>> On Mon, 2008-10-27 at 13:14 -0700, Rob MacKinnon wrote:
>>     
>>> Andreas Gruenbacher wrote:
>>>       
>>>> On Sunday, 26 October 2008 13:26:35 Hugh Dickins wrote:
>>>>         
>>>>> On Sat, 25 Oct 2008, Rob MacKinnon wrote:
>>>>>           
>>>>>> The background: So during the initial configuration of a box I enabled
>>>>>> the xattr flags for ext3 and options of xattr in coreutils, and at the
>>>>>> time didn't realize that I'd hit a snag that would finally annoy me
>>>>>> enough after a month of getting a non-fatal error messages from cp "cp:
>>>>>> listing attributes of `/dev/null`: Invalid argument" to spend half a day
>>>>>> researching the cause and a potential solution.
>>>>>>
>>>>>> Setup: udev mounts a tmpfs to /dev then fills it with device nodes.
>>>>>> Problem: the resulting tmpfs has no xattr support.
>>>>>> Therefore: Tmpfs without xattrs, and coreutils  and everywhere else with
>>>>>> xattr support, cp freaks.
>>>>>>
>>>>>> Is there sometime in the forseable future when the tmpfs module will
>>>>>> support for xattrs in the stable branch, or should I "holler at the
>>>>>> maintainers of coreutils to fix their broken code in cp". Even better
>>>>>> (and I like this option the most) a little of both?
>>>>>>             
>>>>> I've not seen "cp: listing attributes of `/dev/null': Invalid argument"
>>>>> messages (or.. do I have a dim recollection of them once upon a time?).
>>>>> I would certainly get irritated by them if I did, and want to fix them.
>>>>> I tried "cp /dev/null temp" on a few distros just now but not seen it.
>>>>>           
>>>> As Hugh pointed out already, tmpfs does support xattrs since quite a while, so 
>>>> enabling that should fix the symptoms. Independent of that, cp must of course 
>>>> work correctly on filesystems that don't have xattrs. Those filesystems are 
>>>> not supposed to return EINVAL, though.
>>>>
>>>> Could you please run cp under strace to show us what's happening at the 
>>>> syscall level (and perhaps under ltrace in addition to see the library level 
>>>> as well)?
>>>>
>>>> If the error happens at the syscall level (*listxattr), then which kernel is 
>>>> it exactly, and where can I find its sources?
>>>>
>>>>         
>>> Thanks Andreas, Hugh & HPA
>>>
>>> First off, thanks for looking into this.  After googling around, hitting
>>> forums and such and not getting any answers, this list seemed the best
>>> place to come to ask.
>>>
>>> Now onward to business...I can say that I too was under the general
>>> understanding that xattr for tmpfs was added at 2.6.10...and was still
>>> currently supported.  Unfortunately I already have the config flags set
>>> (as seen below, for a full config set attached) so there is a continued
>>> confusion in my mind why this is still plaguing me.
>>>
>>> I've had several friends compare what was going on, and of them they
>>> were all running rhel and cent (most with no udev support so the
>>> comparison didn't help at all).
>>>
>>> I'll start out with distro info and the like...
>>> `uname -a`="Linux shin-yuko 2.6.26-gentoo-r2 #1 SMP PREEMPT Wed Oct 22
>>> 16:31:40 PDT 2008 i686 Intel(R) Pentium(R) 4 CPU 2.80GHz GenuineIntel
>>> GNU/Linux"
>>>
>>> coreutils-version="coreutils-6.12-r2"
>>>
>>> My current config does have the following set:
>>> 	CONFIG_TMPFS=y
>>> 	CONFIG_TMPFS_POSIX_ACL=y
>>> 	CONFIG_SHMEM=y
>>>
>>> Output from `strace /bin/cp /dev/null /root/temp`= #see attachment
>>> Output from `ltrace -CS /bin/cp /dev/null /root/temp`= #see attachment
>>>
>>> Output from `attr -l /dev/null`=Segfault (hmmm...lemme look at a strace
>>> and ltrace of that too)
>>>
>>> `strace attr -l /dev/null`= #see attachment
>>> `ltrace -CS /bin/attr -l /dev/null`= #see attachment
>>>
>>> Kernel source can be attained from:
>>> http://distfiles.gentoo.org/distfiles/linux-2.6.26.tar.bz2
>>>
>>> Patches:
>>> http://sources.gentoo.org/viewcvs.py/linux-patches/genpatches-2.6/trunk/2.6.26/
>>>
>>> I know this is silly but, setfattr and getfattr obviously don't work
>>> either...just thought it was worth mentioning.
>>>       
>> Looks like a bug in Smack's implementation of the inode_listsecurity
>> hook to me.  Did you mean to enable Smack in your kernel config?
>>
>>     
>
> I had intensionally flipped CONFIG_SECURITY_SMACK to "y".

Thank you!

>   I'm used to
> running hardened with GRSec and RBAC (ot: but found the gentoo
> versioning was so far behind / and me being lazy and not wanting to
> manually do the patching / I dropped using hardened sources) so when I
> saw the option for what sounded like a good compromise I jumped at it.
> Looks like I did a good thing too having uncovered a problem. :)
>
> -- Rob

Yes indeed, and thank you. Stephen has already suggested a fix, I just
need to do some code, build, and test once I get to Smack time.

