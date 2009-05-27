Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbZE0CY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbZE0CY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZE0CYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:24:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:27901 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbZE0CYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:24:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZxHJmzzDGvQQZIHVoVXqdDBX49MW+PpeULWIHi72CG2pvVYUVBBSzVtgtsxlnY05qU
         0xEFz7d2RCBl5f+vWz4zfN8BJO94i1rHX0hSHcOaK4oJlLRCGC1Zs8axWTglVE0WaQRp
         MKb0WJTLDxkoZZG7eL03g0W4HDRvaEgA6rny8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>
	 <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com>
	 <20090526205414.GA26016@kroah.com>
	 <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com>
Date: Wed, 27 May 2009 11:24:50 +0900
Message-ID: <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com>
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to 
	mount debugfs filesystem.
From: GeunSik Lim <leemgs1@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 6:15 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 26 May 2009, Greg KH wrote:
>> >
>> > The filesystem Nazi's out there will argue that the proper place to mount
>> > the debugfs filesystem is /sys/kernel/debug. I personally find that
>> > location annoying.
>>
>> Why?
>
> Because it is too much to type ;-)
I think so. But, when we consider many developers that use linux kernel
source all over the world, I think that a regular rules or consistency
is important
as greg k-h explained.

Recently, I read "ftrace-world.odp" presentation file  of steven rostedt.

For example, about Mounting debugfs...
#> mount -t debugfs nodev /sys/kernel/debug
OR
#> mkdir /debug
#> mount -t debugfs nodev /debug

I want that we will reach a consensus about mount directory name of
debugfs filesystem to avoid confusing among the kernel developers.

/debug/ ?
or   /sys/kernel/debug/?
 .....

Frankly speaking, I like /sys/kernel/debug/ rule is better than /debug/ rule
for consistency.

>
>>
>> When I created debugfs, I was told that I had to pick a place to mount
>> it so that everyone could write scripts that "knew" where it would be.
>>
>> So we picked /sys/kernel/debug/ and the code creates the mount point to
>> put it there.  Now distros actually mount debugfs at that location.
>>
>> So, now you don't like this?  After it's become a standard?  Ick.
>>
>> Becides, /debug/ is pretty presumptious, it's as if debugging the kernel
>> is a system-wide thing :)
>>
>> So please, don't use /debug/ use the standard, defined, and ACTUALLY
>> USED BY DISTROS TODAY mount point of /sys/kernel/debug/
>>
>> If you want to create your own symlink from /debug/ to that location to
>> make it easier to type, feel free, but do not hard code any scripts to
>> use that location, or they are going to break.
>
> All my scripts search /proc/mounts to find where debugfs is mounted, then
> it uses that.
>
> Hmm, Not sure what packages in the distros use the default. I don't see
> the debugfs in /etc/fstab in any of my machines.
>
Yes.. In my case, I use linux distributions like Ubuntu 8.10, Fedora
9/10, CENTOS 5.3 currently. This distributions  use proc , tmpfs,
devpts, sysfs for official release
by default.

> -- Steve
>
>



-- 
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
