Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbXEAAam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbXEAAam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423405AbXEAAal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:30:41 -0400
Received: from 1-1-8-31a.gmt.gbg.bostream.se ([82.182.75.118]:62658 "EHLO
	lin5.shipmail.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422987AbXEAAaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:30:07 -0400
X-Greylist: delayed 1156 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 20:30:06 EDT
Message-ID: <46368588.3040503@tungstengraphics.com>
Date: Tue, 01 May 2007 02:10:48 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.7.8) Gecko/20050511
X-Accept-Language: sv, en-us, en
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>	 <20070427163951.GA12216@kroah.com> <21d7e9970704301610u5d5132uc282ac697c9df2be@mail.gmail.com>
In-Reply-To: <21d7e9970704301610u5d5132uc282ac697c9df2be@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:

>
> Most likely in doxygen as that is what Mesa uses and the intersection
> of developers is higher in that area, I'll take it as a task to try
> and kerneldoc the drm at some stage..
>
>>   - what's with the /proc interface?  Don't add new proc code for
>>     non-process related things.  This should all go into sysfs
>>     somewhere.  And yes, I know /proc/dri/ is there today, but don't add
>>     new stuff please.
>
>
> Well we should move all that stuff to sysfs, but we have all the
> infrastructure for publishing this stuff under /proc/dri and adding
> new files doesn't take a major amount, as much as I appreciate sysfs,
> it isn't suitable for this sort of information dump, the whole one
> value per file is quite useless to provide this sort of information
> which is uni-directional for users to send to us for debugging without
> have to install some special tool to join all the values into one
> place.. and I don't think drmfs is the answer either... or maybe it
> is....
>
>>   - struct drm_bo_arg can't use an int or unsigned, as it crosses the
>>     userspace/kernelspace boundry, use the proper types for all values
>>     in those types of structures (__u32, etc.)
>
>
> int is defined, unsigned I'm not so sure about, the drm user space
> interface is usually specified in non-system specific types so the
> drm.h file is consistent across systems, so we would probably have to
> use uint32_t which other people have objected to, but I'd rather use
> uint32_t than unspecified types..
>
>>   - there doesn't seem to be any validity checking for the arguments
>>     passed into this new ioctl.  Possibly that's just the way the rest
>>     of the dri interface is, which is scary, but with the memory stuff,
>>     you really should check things properly...
>
>
> Okay this needs fixing, we do check most ioctls args, the main thing
> passed in are handles and these are all looked up in the hash table,
> it may not be so obvious, also most of the ioctls are probably going
> to end up root or DRM master only, I'd like do an ioctl fuzzer at some
> stage, I'd suspect a lot more then the dri would be oopsable with
> permissions...
>
> Thanks,
> Dave.

I agree with Dave for most if not all of the above.
Typing, for example unsigned / uint32 vs u32, __u32 is very easily 
fixable once we decide on a clear way to go to keep  (if we want to 
keep) compatibility with *bsd.

For the IOCTL checking, as Dave states, most invalid data will be 
trapped in hash lookups and
checks in the buffer validation system, but probably far from all. A 
fuzzer would be a nice tool to trap the exceptions.

/Thomas

