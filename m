Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZJ2I2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZJ2I2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZJ2I2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:28:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53154 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZJ2I2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:28:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE951F4.7080406@jp.fujitsu.com>
Date: Thu, 29 Oct 2009 17:27:32 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86, mce: short output of MCE banks ownership	information
References: <4AE90E43.2030709@jp.fujitsu.com> <adaaaza6exw.fsf@cisco.com> <4AE93B42.5040605@jp.fujitsu.com> <20091029073408.GA18976@elte.hu>
In-Reply-To: <20091029073408.GA18976@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
>> Maybe there would be more desirable ways, but I think that "compress 
>> messages shorter to bear heavy repeating" will be a good way at this 
>> time.
> 
> We really want to only print out relevant information. 128 lines of 
> identical output is not relevant. (or 2x 64 lines, or 4096 lines of 
> identical output)
> 
> So we only want to print MCE setup messages on the boot CPU. That gives 
> us 90% of the benefits already: we see the rough structure of the 
> hardware, and if the bootup has a problem with MCE initialization we get 
> relevant printouts that helps debugging.
> 
> Now, it's certainly true that with things like MCE bank sharing the MCE 
> setup output from different CPUs might not be identical all the time - 
> but the information is represented in other (topology) info anyway. (and 
> if not it wasnt all that important to begin with)
> 
> For non-boot CPUs we can perhaps add a mce=verbose (default-disabled) 
> mode of bootup that allows all CPUs to be printed - should there be any 
> problem with MCE details only visible on non-boot CPUs. (unlikely)

How about having a kind of "boot=quiet_ap" which suppress boot-time messages
for all non-boot CPUs, rather than "mce=verbose" which only suppress one
(or, with thermal message, two) line?  I don't not understand why this problem
would be solved only by removing the lines from mce subsystem.

I have no problem on my box with 16 CPUs, but I would not think so if there
were 128 or 4096.  Then I'd like to see in short:
  :
 2048 CPUs available, 4096 CPUs total
 Booting 2047 processors ........<snip>..... OK.
 Total of 2048 processors activated (XXXXXXXXXXX.XX BogoMIPS).
  :

Anyway this will be a quite trivial problem for desktop/notebook users.


Thanks,
H.Seto

