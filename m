Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYJONzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYJONzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 09:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYJONzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 09:55:01 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40274 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYJONzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 09:55:00 -0400
Message-ID: <48F5F628.8080500@bull.net>
Date: Wed, 15 Oct 2008 15:54:48 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
References: <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk> <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org> <20081007222726.GA9465@kroah.com> <48EBF21E.40709@kernel.org> <m1myh8rnf4.fsf@frodo.ebiederm.org> <48F45075.7000003@kernel.org> <20081014185320.GA24908@us.ibm.com> <m13aiyk7jf.fsf@frodo.ebiederm.org> <20081015134204.GA26886@us.ibm.com>
In-Reply-To: <20081015134204.GA26886@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Serge E. Hallyn" <serue@us.ibm.com> writes:
>>
>>> Again fuse doesn't address the *core* issue (sysfs needing a way to
>>> create files for multiple devicenames with same name).  But I believe
>>> Benjamin was looking into a minimal patch to fix that.  Benjamin,
>>> have you gotten anywhere with that?
>> I would love to hear a minimal strategy for that.
> 
> Oh I just meant for kernel-space.  So if a container is creating lo,
> it will create a device named lo, but the sysfs file will be called
> lo_1 or something.

I've started working on a patch that implements what you suggested:
add a suffix representing the netns to net device entries in sysfs.

It does work, but there are some issues (in addition to the fact that
these new device entries doesn't look very clean in /sys/class/net :) ).

For example, what is a good suffix for the device name.
We only have 4 bytes left for the suffix:

BUS_ID_SIZE - IFNAMSIZ = 4
sysfs         net device
name length   name length

Benjamin

> 
>> The only minimal strategy user space wise is to create multiple superblocks.
>> Anything else I an think of violates backwards compatibility.
> 
> Yes, the above would require that the container either not mount
> sysfs, ignore sysfs, or tweak sysfs using
> 	mount -t tmpfs none /sys/class/net
> 	mount --bind /sys/devices/virtual/net/lo_1 /sys/class/net/lo
> or using fuse.
> 
> I'd definately prefer the sysfs tagging approach.  But I'd prefer
> the above over never being able to use network namespaces on a
> standard distro (with sysfs enabled).
> 
> -serge
> 
> 


-- 
B e n j a m i n   T h e r y  - BULL/DT/Open Software R&D

    http://www.bull.com
