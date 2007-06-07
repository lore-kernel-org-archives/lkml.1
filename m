Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbXFGFxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbXFGFxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 01:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbXFGFxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 01:53:41 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:40197 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbXFGFxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 01:53:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pyJrENXFdTrJjUXs86by/sMytm6V45Z8KRzOilnF8FJn81C/y6JdelinhpsF0BAy4AlisrWhf1O/5zOoXSTr8yBrdUW/v+xrqAVJAykeD08KGb/YBmdYT/E7dtaAg3jENiaP8jkXyfZe1n26RmUK6kK0mo4cgtbLUMz7/AGKiVc=
Message-ID: <46679D56.7040001@gmail.com>
Date: Thu, 07 Jun 2007 14:53:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com>
In-Reply-To: <46668EE0.2030509@dgreaves.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

David Greaves wrote:
> Just to be clear. This problem is where my system won't resume after s2d
> unless I umount my xfs over raid6 filesystem.

This is really weird.  I don't see how xfs mount can affect this at all.

[--snip--]
> So now this compiles but it does cause the problem:
> 
> umount /huge
> echo platform > /sys/power/disk
> echo disk > /sys/power/state
> # resumes fine
> 
> mount /huge
> echo platform > /sys/power/disk
> echo disk > /sys/power/state
> # won't resume

How hard does the machine freeze?  Can you use sysrq?  If so, please
dump sysrq-t.

>   Behavior difference introduced by the
>> reimplementation is serialization of resume sequence, so it takes more
>> time.  My test machine had problems resuming if resume took too long
>> even with the previous implementation.  It didn't matter whether the
>> long resuming sequence is caused by too many controllers or explicit
>> ssleep().  If time needed for resume sequence is over certain threshold,
>> machine hangs while resuming.  I thought it was a BIOS glitch and didn't
>> dig into it but you might be seeing the same issue.
> given the mount/umount thing this sounds unlikely... but what do I know?

No I don't think this is the same problem either.  The problem I
described happened during resume from s2ram.

> resume does throw up:
> ATA: abnormal status 0x7F on port 0x0001b007
> ATA: abnormal status 0x7F on port 0x0001b007
> ATA: abnormal status 0x7F on port 0x0001a407
> ATA: abnormal status 0x7F on port 0x0001a407
> 
> which I've not noticed before... oh, alright, I'll check...
> reboots to 2.6.21, suspend, resume...
> nope, not output on resume in 2.6.21

The messages don't really matter.

Thanks.

-- 
tejun
