Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbZJ1Rgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbZJ1Rgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbZJ1Rgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:36:54 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35457 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755266AbZJ1Rgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:36:54 -0400
Message-ID: <4AE88151.8000608@sgi.com>
Date: Wed, 28 Oct 2009 10:37:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com>	<4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com>	<4AE7D59D.9070307@linux.intel.com> <4AE7E40F.20602@jp.fujitsu.com>	<4AE7E931.6040703@linux.intel.com> <ada8wevtpbk.fsf@cisco.com>
In-Reply-To: <ada8wevtpbk.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Roland Dreier wrote:
>  > Perhaps they could be also compressed a bit like SRAT.
> 
> Seems like a good idea... but I wonder what the best way to represent
> things is.  For example I have a 2-socket Nehalem system that shows:
> 
>  2 times:  MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
>  6 times:  MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
>  8 times:  MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 
> presumably the first line is once per package, the next line is for the
> first sibling in all the other cores in a package, and the last line is
> for the SMT siblings of all the cores.
> 
> But would we want to accumulate all the different combinations of banks
> along with a CPU mask and then print something like:
> 
>  CPUs 0 4: MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
>  CPUs 1 2 3 5 6 7: MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
>  CPUs 8 9 10 11 12 13 14 15: MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8

Or use a cpumask and cpulist_scnprintf which condenses the cpu list nicely.

> 
> of course output like that is going to lead to super-long lines on a
> 64-thread system.
> 
> Also I'm not sure of a clean way to implement this; unlike the SRAT
> stuff, we need to deal with CPU hotplug so all this at best could be
> __cpuinitdata, ie we can't discard it in most configs.
> 
> However the "MCA banks" output definitely is annoying on a 64-thread
> system -- the amount of output is far greater than the utility of said
> output.  So ideas on the best way to reduce this would be appreciated.
> 
> Thanks,
>   Roland
