Return-Path: <linux-kernel-owner+w=401wt.eu-S1762398AbXEPTMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398AbXEPTMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbXEPTME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:12:04 -0400
Received: from gherkin.frus.com ([192.158.254.49]:37781 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbXEPTMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:12:03 -0400
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
In-Reply-To: <20070516163000.GE30166@redhat.com> "from Dave Jones at May 16,
 2007 12:30:00 pm"
To: Dave Jones <davej@redhat.com>
Date: Wed, 16 May 2007 14:11:56 -0500 (CDT)
CC: Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Joachim Deguara <joachim.deguara@amd.com>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070516191156.69576DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Wed, May 16, 2007 at 11:53:22AM -0400, Chuck Ebbert wrote:
>  > Bob Tracy wrote:
>  > > Jan Engelhardt wrote:
>  > >>> On Tue, 15 May 2007 22:13:14 -0500 (CDT) Bob Tracy wrote:
>  > >>>> The 2.6.22-rc1 boot panics early in amd_mcheck_init() with my k6-III/450.
>  > 
>  > > Intel machine check architecture supported.
>  > > general protection fault: 0000 [#1]
>  > > PREEMPT
>  > > Modules linked in:
>  > > CPU:   0
>  > > EIP: 0060:[<c01079f4>]  Not tainted VLI
>  > > EFLAGS: 00010286   (2.6.22-rc1 #1)
>  > > EIP is at amd_mcheck_init+0x2b/0xc3
>  > > 
>  > 
>  > rdmsr with ecx == 0x179 (Machine Check Global Capabilities Register)
>  > 
>  > Probably K6 doesn't have that.
> 
> sounds right. Intel style MCE capability was introduced with the Athlon
> on AMD systems iirc.
> 
>  > Caused by:
>  > 
>  > 	[PATCH] i386: check capability
> 
> Though this would imply that Bobs K6-3 is reporting that it does have
> that bit in its cpuid flags.
> 
> Bob, can you send your /proc/cpuinfo and dmesg |grep CPU  ?

/proc/cpuinfo sent in the first message in this thread (anticipated your
request :-)), but it's small enough to repeat:

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 5
model		: 9
model name	: AMD-K6(tm) 3D+ Processor
stepping	: 1
cpu MHz		: 451.040
cache size	: 256 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr mce cx8 pge mmx syscall 3dnow k6_mtrr
bogomips	: 902.78
clflush size	: 32

Here's the requested dmesg output (for 2.6.21):

Initializing CPU#0
CPU: After generic identify, caps: 008021bf 808029bf 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 32K (32 bytes/line), D cache 32K (32 bytes/line)
CPU: L2 Cache: 256K (32 bytes/line)
CPU: After all inits, caps: 008021bf 808029bf 00000000 00000002 00000000 00000000 00000000
CPU: AMD-K6(tm) 3D+ Processor stepping 01
NVRM: CPU does not support the PAT, falling back to MTRRs.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
