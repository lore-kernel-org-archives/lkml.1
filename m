Return-Path: <linux-kernel-owner+w=401wt.eu-S1423190AbXBHK07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423190AbXBHK07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 05:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423153AbXBHK07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 05:26:59 -0500
Received: from nebensachen.de ([195.225.107.202]:55011 "EHLO
	mail.nebensachen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423198AbXBHK05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 05:26:57 -0500
X-Greylist: delayed 1337 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 05:26:57 EST
From: Elias Oltmanns <eo@nebensachen.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Christoph Schmid <chris@schlagmichtod.de>, linux-kernel@vger.kernel.org
Subject: Re: is there any Hard-disk shock-protection for 2.6.18 and above?
References: <7ibks-1fg-15@gated-at.bofh.it> <7kpjn-7th-23@gated-at.bofh.it>
	<7kDFF-8rd-29@gated-at.bofh.it> <87d5783fms.fsf@denkblock.local>
	<20061130171910.GD1860@elf.ucw.cz> <87k61bpuk4.fsf@denkblock.local>
	<20061202115709.GC4030@ucw.cz> <87wt50wokd.fsf@denkblock.local>
	<20070204204115.GC2067@elf.ucw.cz>
X-Hashcash: 1:20:070208:jens.axboe@oracle.com::FNemR3tirYCiYK5C:00000000000000000000000000000000000000000eEU
X-Hashcash: 1:20:070208:pavel@ucw.cz::yDoCtDKYnNXUQnhb:000002U3j
X-Hashcash: 1:20:070208:linux-kernel@vger.kernel.org::AW5Iq+nNF81vZ6Uh:0000000000000000000000000000000000Zjo
X-Hashcash: 1:20:070208:chris@schlagmichtod.de::PYQ1Bk+z8rg8M0FK:0000000000000000000000000000000000000000WfK
Date: Thu, 08 Feb 2007 11:04:10 +0100
In-Reply-To: <20070204204115.GC2067@elf.ucw.cz> (Pavel Machek's message of
	"Sun\, 4 Feb 2007 21\:41\:15 +0100")
Message-ID: <87ps8lj78l.fsf@denkblock.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Pavel Machek <pavel@ucw.cz> wrote:
> Hi1
>
>> >> >> +module_param_named(protect_method, libata_protect_method, int, 0444);
>> >> >> +MODULE_PARM_DESC(protect_method, "hdaps disk protection method  (0=autodetect, 1=unload, 2=standby)");
>> >> >
>> >> > Should this be configurable by module parameter? Why not tell each
>> >> > unload what to do?
>> [...]
>> >> > Is /sys interface right thing to do?
>> >> 
>> >> Probably, you're right here. Since this feature is actually drive
>> >> specific, it should not really be set globally as a libata or ide-disk
>> >> parameter but specifically for each drive connected. Perhaps we should
>> >> add another attribute to /sys/block/*/queue or enhance the scope of
>> >> /sys/block/*/queue/protect?
>> >
>> > Certainly better than current solution. Or maybe ioctl similar to wat
>> > hdparm uses?
>> 
>> I'm not quite sure what you have in mind wrt ioctls. I'm still
>> convinced that the administrator should take a conscious decision when
>> forcing an idle immediate with unload feature on a drive which doesn't
>> announce this capability according to the specs. This is because I
>> have no idea as to how drives might react if they don't support it.
>> Perhaps we should consult linux-ide on this topic.
>
> Yep, I guess linux-ide would have some comments.

At least, I can now see the benefits of an ioctl approach. Although
the protect_method attribute allows to configure each drive
individually, that is actually not quite what we want. Since this
attribute is meant to deal with drives that don't comply strictly with
the ATA specs, it is, at least, misleading to associate this with each
queue. Instead, it would be desirable to offer this option to ATA
drives only and to do this consistently, regardless whether the IDE or
the ATA drivers are in use. So, I'm now quite convinced that ioctls
are the easiest way to achieve just that - thanks for the hint.

>
>> So, here is a patch in which your remarks and suggestions have been
>> incorporated. Additionally, I've added the requested kernel doc file
>
> Additional suggestion is to keep lines < 80 columns.... Sorry it took
> me so long to comment.
> 								Pavel

In the meantime, I've started to implement the generic block layer
commands for queue freezing as Jens suggested in this thread.
Unfortunately, I've been very busy lately and actually I still am but
I'll try hard to get this finished rather sooner thn later.

Thanks for your support.

Elias
