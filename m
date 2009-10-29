Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZJ2QHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZJ2QHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZJ2QHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:07:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:51209 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753519AbZJ2QHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:07:09 -0400
Message-ID: <4AE9BDA9.3030804@sgi.com>
Date: Thu, 29 Oct 2009 09:07:05 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, mce: short output of MCE banks ownership information
References: <4AE90E43.2030709@jp.fujitsu.com> <adaaaza6exw.fsf@cisco.com> <4AE93B42.5040605@jp.fujitsu.com>
In-Reply-To: <4AE93B42.5040605@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a patch coming that summarizes the Booting processor msgs and
the Processor information messages:

The first increases the start count by a power of 2 so 4096 cpus
would only need 12 lines.

[   25.388280] Booting Processors 1-7,320-327, Nodes 0-0
[   26.064742] Booting Processors 8-15,328-335, Nodes 1-1
[   26.837006] Booting Processors 16-31,336-351, Nodes 2-3
[   28.440427] Booting Processors 32-63,352-383, Nodes 4-7
[   31.640450] Booting Processors 64-127,384-447, Nodes 8-15
[   38.041430] Booting Processors 128-255,448-575, Nodes 16-31
[   50.917504] Booting Processors 256-319,576-639, Nodes 32-63 

(the last line has a slight error in that actually only nodes 32-39
were starting.  Btw, the processor numbers are correct, according
to the Intel spec.)

and

[  103.860206] Summary Processor information for CPUS: 0-639
[  103.864032] Genuine Intel(R) CPU             0000 @ 2.13GHz stepping 04
[  103.873403] CPU: L1 I cache: 32K, L1 D cache: 32K
[  103.877885] CPU: L2 cache: 256K
[  103.880032] CPU: L3 cache: 24576K
[  103.884032] MIN 4266.68 BogoMIPS (lpj=8533378)
[  103.888032] MAX 4267.70 BogoMIPS (lpj=8535412)
[  103.896248] Total of 640 processors activated (2731043.30 BogoMIPS).

This summary looks for different cpu types, steppings and cache sizes.

                                                         
Hidetoshi Seto wrote:
> Roland Dreier wrote:
>> Seems OK, but I think it would be even more useful to find a way to
>> print fewer lines of output; with CPUs that will be released shortly, a
>> system with 64 or even 128 logical CPUs will not be will not be that
>> exotic, and producing 128 lines of kernel log output for debugging
>> information that is rarely used and where the same info can be expressed
>> in 2 or 3 lines is silly-looking (and very annoying on a 57600 bps
>> serial console!).
> 
> Thanks for your review!
> 
> I think we could some effort like this for other messages during
> CPU initialization.
> 
> For example I googled a full dmesg of recent hardware:
>   http://www.gossamer-threads.com/lists/linux/kernel/1134265
> It shows that the lines like:
>    :
>   Booting processor 1 APIC 0x2 ip 0x6000
>   Initializing CPU#1 
>   Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672337) 
>   CPU: Physical Processor ID: 0 
>   CPU: Processor Core ID: 1 
>   CPU: L1 I cache: 32K, L1 D cache: 32K 
>   CPU: L2 cache: 256K 
>   CPU: L3 cache: 8192K 
>   mce: CPU supports 9 MCE banks 
>   CPU1: Thermal monitoring enabled (TM1) 
>   CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8 
>   x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106 
>   CPU1: Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz stepping 04 
>   Skipping synchronization checks as TSC is reliable. 
>    :
> are that printed for every cpu.
> 
> We already eliminated "mce: CPU supports X MCE banks" in this repeat
> and now going to compress "CPU X MCA banks ..." line.
> 
> I suppose:
>   - Cache information can be compressed too, could be in one line.
>   - Usually model name (and also cache size) will be same on all cpu.
> 
> I can understand that it is better to avoid printing same lines
> again and again.  But there are more redundant messages...
> 
> Maybe there would be more desirable ways, but I think that
> "compress messages shorter to bear heavy repeating" will be
> a good way at this time.
> 
> 
> Thanks,
> H.Seto
