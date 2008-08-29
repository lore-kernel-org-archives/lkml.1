Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYH2PBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYH2PBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYH2PBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:01:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:39297 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYH2PBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:01:15 -0400
Message-ID: <48B80EF5.80308@kernel.org>
Date: Fri, 29 Aug 2008 17:00:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Zeuthen <david@fubar.dk>
Subject: Re: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
References: <48B6D28E.10006@kernel.org> <48B6D2C6.4010703@kernel.org>	 <20080828164924.GB17475@kroah.com> <48B6D9B7.2050406@kernel.org>	 <3ae72650808290048v1a5d7e51pc68270b2a8d6faa@mail.gmail.com>	 <48B7AD11.2070906@kernel.org> <1220016439.24737.18.camel@lgn.site>	 <48B7FAEC.80206@kernel.org> <1220018057.24737.36.camel@lgn.site>
In-Reply-To: <1220018057.24737.36.camel@lgn.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 15:01:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
>> I'm afraid trying to do that from kernel side would require more scary
>> hack as CUSE will need to push in random device under unsuspecting
>> parent / class.  Maybe we can add a variable to indicate an emulated
>> device or to tell
> 
> Sure, SUSBYSTEM=cuse will be exactly that value. :) I see no problem, if
> cuse adds SUBSYSTEM_FAKE, or whatever it would be.
> 
>> udev/hal whatever to use alt root for sys hierarchy or
>> just consider sysfs is not available?  I think this problem can be
>> settled between userland programs.
> 
> Exactly, we can do anything needed in userspace to support that. I see
> no problem doing that.
> 
> I just say, that we can _not_ allow to fake the SUBSYSTEM value for
> "cuse" or any other device. If the kernel wants to let "cuse" devices
> look like members of a specific subsystem, they have to appear in the
> class/bus list of that subsystem, and have to have the proper
> "susbsystem" link, not only a (wrong) environment key.
> 
> Userland enumerates devices by looking at class/bus directories for
> things like: "give me all soundcards", it expects a set of certain sysfs
> attributes to be present for a specific device, it reads the "subsystem"
> link, and so on. All that would break and make things "special"  and
> needlessly inconsistent.
> 
> So please drop that plan, of faking only a tiny part of
> driver-core/sysfs device parameters. Either we do it properly, or we
> don't do it, and leave it up to userspace to pick up a (consistent)
> "cuse" device, but use it as a device of whatever class.

Right, I was somehow fixated on sound devices having "sound" subsystem.
 That isn't necessary and if some special treatment is needed, we can
play with udev rules and so on.  Okay, will drop the kobject_uevent
changes and hotplug_info stuff.  It seems dev_info is all that's needed.

Thanks.

-- 
tejun
