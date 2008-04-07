Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYDGPmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYDGPmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYDGPmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:42:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:12039 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYDGPmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=l108GHWZ8k/krSbexhYVPSRZoDDdr268Sdf/lGq7v9a7CoSMekqQWFr30ucmyoTGZrnEUtJATijm+06uMORZNcDJ0BohN7v5eb/t+cDx0uOYtdB2BZVj63iOiw4XBiWqwZcWY4Kj+gNoGwMGVor0xfiT7szsP38S5HqZoDQBqAg=
Message-ID: <47FA40C6.5030104@gmail.com>
Date: Mon, 07 Apr 2008 10:41:58 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Joel K. Greene" <joel.greene@catapult.com>
CC: LKML <linux-kernel@vger.kernel.org>, Mike Steckly <michaels@catapult.com>
Subject: Re: Clock has stopped (time/date looping over 5 seconds), things
 are broken - what to check to debug?
References: <47F69D2F.8010607@gmail.com> <1207568231.4496.9.camel@linuxdt036.nc.catapult.com>
In-Reply-To: <1207568231.4496.9.camel@linuxdt036.nc.catapult.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel K. Greene wrote:
> Hi Roger,
> 
> Does this sound familiar:
> 
> http://lkml.org/lkml/2008/3/14/178

That sounds like it matches what I have.

> 
> 
> We've been chasing this for quite a while. Our PIC gets in a bad state
> where it thinks the CPU is in the ISR, and so won't give another int. We
> haven't much of an idea of how we get in that state other than that
> HZ=1000 makes it happen faster and HZ=100 causes it less often.

I do have HZ=1000 set, Pavel mentions setting it the =4000 to make it happen 
faster, I will try that, I am rebuilding 2.4.24.4 with =4000 in the .config 
file, and will verify after it is up that 4000 is running on it.

My machine does have a fair amount of cpu usage (transcoding video), and has a 
fair amount of interrupt handling (5 disks, and 3 TV recording cards).

> 
> I think that if you look at jiffies you will see it is not incrementing.
> The 4 second loop seems to be in the conversion from jiffies to wall
> time.

I did check the counter in /proc/timer_list under (now at) and it was looping too.

> 
> 
> It _appears_ that there is a race in the kernel that can be triggered by
> any number of hardware issues. There's another thread by Gregory Stark
> with the same symptoms - he thinks his was fixed by replacing a bad
> DIMM.

I don't think I have bad HW, I will run a test job for a few hours that checks 
its results and make sure that the proper answers are coming back, and it is not 
crashing.

I do have a couple of disks (on a SIL controller) that every so often appear to 
give funny errors, but recover and continue on.

> 
> Note that we first saw this on 2.6.16, and Gregory found it on 2.6.5.
> We've seen systems run for a couple of months before seeing this, so
> it's a bear to debug.
> 
> How often is this happening for you? How repeatable?

14-30 days, I don't know if it always happens or not, I don't have exact enough 
data, but I don't think the machine has made it past 30 days in the last 6 
months, if I go back far enough though, I believe it was stable, before I added 
a couple of TV recording cards (PVR150, HD5500), and a disk controller (SIL) to 
it.

> 
> What hardware are you running on?

AMD-754 Sempron64 processor.

ASUS K8V-SE Deluxe MB (VT8385/VT8387 Chipset), so very different HW that the 
Serverworks-P3 that you have.







