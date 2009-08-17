Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZHQLIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZHQLIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbZHQLII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:08:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:40229 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZHQLIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,395,1246863600"; 
   d="scan'208";a="439582886"
Message-ID: <4A893A14.1070103@linux.intel.com>
Date: Mon, 17 Aug 2009 13:08:04 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine	check
 code on 32bit
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com> <20090817092047.GB21269@elte.hu>
In-Reply-To: <20090817092047.GB21269@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
>> One possibility is: if the BIOS doesn't clear status in banks, new 
>> mce codes will try to log such junks. If the junk is totally junk 
>> but can be decoded as a valid log with MISCV or ADDRV bit, and if 
>> the cpu try to access register which is not implemented (e.g. 
>> IA32_MCi_MISC/ADDR), then such access might cause a general 
>> protection exception. (ref. ASDM 3A 15.3.2.3)
> 
> btw., that reminds me: mce_rdmsrl() needs to be fixed to use 
> rdmsrl_safe() and it should emit a WARN_ONCE() if it ever hits an 
> error while trying to access registers.

In general systems (like VMs) who don't have MCA MSRs don't declare the
capability bits (there are own capability bits for all of this) and then
the MSRs are never touched. So far I've not had a
single report of this going wrong.

I suspect the problem on your system is something else too we just
need to debug properly.

-Andi


