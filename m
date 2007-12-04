Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbXLDVYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbXLDVYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXLDVYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:24:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbXLDVYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:24:15 -0500
Message-ID: <4755C423.60907@redhat.com>
Date: Tue, 04 Dec 2007 15:18:27 -0600
From: Mike McGrath <mmcgrath@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <20071204210827.GE19691@waste.org>
In-Reply-To: <20071204210827.GE19691@waste.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> which would have been in v2.6.22-rc4 through the normal CVE process.
> The only other bits in there are wall time and utsname, so systems
> with no CMOS clock would behave repeatably. Can we find out what
> kernels are affected?
>
>   
We can but it will likely take a few weeks to get a good sampling. UUID 
is unique in the db so when someone checks in with the same UUID, the 
old one gets overwritten. I'll have to do regular copies of what the 
UUID holds over time. Smolt schedules a monthly check in which we 
literally just missed a few days ago.

>> We seen a huge number of duplicates for certain values:
>>
>> >From Mike McGrath (added to Cc)
>>
>>     
>>> Here's the top 5:
>>>
>>>    266 28caf2c3-9766-4fe1-9e4c-d6b0ba8a0132
>>>    336 810e7126-1c69-4aff-b8b1-9db0fa8aa15a
>>>    402 c8dbb9d3-a9bd-4ba6-b92e-4a294ba5a95f
>>>    884 06e84493-e024-44b1-9b32-32d78af04039
>>>    931 e2b67e1d-e325-4740-b938-795addb45280
>>>
>>> The left number is times this month someone has submitted a profile with
>>> that UUID.  If we take the last one as an example has come from over 800
>>> IP's in the last 20 days.  It seems very unlikely that one person would
>>> find his way to 800 different IP's this month.  Let me know if you'd
>>> like more.
>>>       
>
> Any other details would be interesting.
>   

We'll be able to get lots of stuff. Here's a profile of whats currently 
in e2b67e1d-e325-4740-b938-795addb45280.

u_u_id: e2b67e1d-e325-4740-b938-795addb45280
o_s: Fedora release 7.92 (Rawhide)
platform: i686
bogomips: 3660.33
system_memory: 2025
system_swap: 964
vendor: Sony Corporation
system: VGN-FE31Z C3LMPJWX
cpu_vendor: GenuineIntel
cpu_model: Intel(R) Core(TM)2 CPU T
num_cp_us: 2
cpu_speed: 1833
language: en_US.UT
default_runlevel: 5
kernel_version: 2.6.23.1-23.fc8
formfactor: laptop
last_modified: 2007-10-02 04:22:42
rating: 3
selinux_enabled: 1
selinux_enforce: targeted

I'll grab the suspect UUID profiles over time to see what we end up with.

-Mike
