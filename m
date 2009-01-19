Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbZASWZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbZASWZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZASWY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:24:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZASWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:24:55 -0500
Message-ID: <4974FDAE.7080909@zytor.com>
Date: Mon, 19 Jan 2009 14:24:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Avuton Olrich <avuton@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due
 to dc1e35c
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com> <20090119215736.GE31356@linux-os.sc.intel.com> <4974F9A8.7060107@zytor.com> <20090119221434.GF31356@linux-os.sc.intel.com>
In-Reply-To: <20090119221434.GF31356@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Mon, Jan 19, 2009 at 02:07:36PM -0800, H. Peter Anvin wrote:
>> Suresh Siddha wrote:
>>> Also, I wonder, if we should complain/scream during boot if we find only
>>> fewer cpuid levels on modern generation cpu's.
>>>
>> We should, or if this block is reversible, we should probably just undo 
>> it (the reason people put this block in places is because of, ahem, 
>> inferior operating systems having bugs.)
>>
>> Do you know how this is managed?  Via an MSR?
> 
> IA32_MISC_ENABLE MSR bit 22

LOL, the official name of this bit is "IA32_MISC_ENABLES.BOOT_NT4"; kind 
of says it all.  In fact, I remember the problems we had with NT4 and 
CPUID back from the Transmeta days, and there, too, we ended up with a 
CPUID hack which Linux unconditionally disables.

I'll write up a patch.

	-hpa



