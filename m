Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbZGLATe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbZGLATe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 20:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZGLATZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 20:19:25 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:46254 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZGLATZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 20:19:25 -0400
Message-ID: <4A592C09.8060104@msgid.tls.msk.ru>
Date: Sun, 12 Jul 2009 04:19:21 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
References: <49FEB572.4010909@msgid.tls.msk.ru> <20090710162105.GA1469@ucw.cz>
In-Reply-To: <20090710162105.GA1469@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2009-05-04 13:29:22, Michael Tokarev wrote:
>> Is there any reason why 32-bit uswsusp &Friends does not work
>> on 64bits kernel?
>>
>> For one, 32bits s2disk produces the following when trying to
>> suspend:
>>
>>  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} arg(ff853554) on /dev/snapshot
>>  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000805) on /dev/snapshot
>>
>> this is coming from:
>>
>>     error = ioctl(dev, SNAPSHOT_SET_SWAP_AREA, &swap);
>>     if (error && !offset)
>>             error = ioctl(dev, SNAPSHOT_SET_SWAP_FILE, blkdev);
>>
>> but I guess (just guess!) that other SNAPSHOT_* operations will
>> also fail the same way.
>>
>> Is there a reason why those are not in compat_ioctl?
> 
> Lazyness...?
> 
> Patch would be welcome.

Pavel, you really should take a look at the original thread.

As I mentioned in my first email, I'm not the right person to
do the patch.  But regardless, I spent about a day understanding
this stuff (or trying to, anyway) - 100% useless day - and when
I thought I have a patch someone else spoken up and said this
way (compat_ioctl) is the wrong approach now.  And sent another,
also trivial patch, adding compat calls right to the proper
place in kernel/power.c.  Which (the patch) has been ignored
too.

So "welcome" is a wrong word here, and I'm sorry about that.

 > On 4GB machine, running 64bit kernel (but
> staying with 32bit userland) makes sense...

This is exactly what I'm running here by the way.
But regardless, uswsusp should be fixed too before it will
be useful for that.  And fixing uswsusp is not trivial,
unlike kernel side.  But having in mind amount of useless
jumping needed just for the trivial kernel part, for a
20-minute patch, -- there's not much hope really.  (I
wanted to fix it too, initially, -- not any more).

/mjt
