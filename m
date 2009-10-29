Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbZJ2GvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbZJ2GvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 02:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZJ2GvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 02:51:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39264 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZJ2GvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 02:51:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE93B42.5040605@jp.fujitsu.com>
Date: Thu, 29 Oct 2009 15:50:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86, mce: short output of MCE banks ownership information
References: <4AE90E43.2030709@jp.fujitsu.com> <adaaaza6exw.fsf@cisco.com>
In-Reply-To: <adaaaza6exw.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Seems OK, but I think it would be even more useful to find a way to
> print fewer lines of output; with CPUs that will be released shortly, a
> system with 64 or even 128 logical CPUs will not be will not be that
> exotic, and producing 128 lines of kernel log output for debugging
> information that is rarely used and where the same info can be expressed
> in 2 or 3 lines is silly-looking (and very annoying on a 57600 bps
> serial console!).

Thanks for your review!

I think we could some effort like this for other messages during
CPU initialization.

For example I googled a full dmesg of recent hardware:
  http://www.gossamer-threads.com/lists/linux/kernel/1134265
It shows that the lines like:
   :
  Booting processor 1 APIC 0x2 ip 0x6000
  Initializing CPU#1 
  Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672337) 
  CPU: Physical Processor ID: 0 
  CPU: Processor Core ID: 1 
  CPU: L1 I cache: 32K, L1 D cache: 32K 
  CPU: L2 cache: 256K 
  CPU: L3 cache: 8192K 
  mce: CPU supports 9 MCE banks 
  CPU1: Thermal monitoring enabled (TM1) 
  CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8 
  x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106 
  CPU1: Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz stepping 04 
  Skipping synchronization checks as TSC is reliable. 
   :
are that printed for every cpu.

We already eliminated "mce: CPU supports X MCE banks" in this repeat
and now going to compress "CPU X MCA banks ..." line.

I suppose:
  - Cache information can be compressed too, could be in one line.
  - Usually model name (and also cache size) will be same on all cpu.

I can understand that it is better to avoid printing same lines
again and again.  But there are more redundant messages...

Maybe there would be more desirable ways, but I think that
"compress messages shorter to bear heavy repeating" will be
a good way at this time.


Thanks,
H.Seto
