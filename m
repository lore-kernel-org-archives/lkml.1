Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbYBEVS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbYBEVS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbYBEVSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:18:18 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:33583 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbYBEVSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:18:17 -0500
Date: Tue, 5 Feb 2008 13:17:36 -0800
From: Robin Lee Powell <rlpowell@digitalkingdom.org>
To: Neil Brown <neilb@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Monthly md check == hung machine; how do I debug?
Message-ID: <20080205211736.GD9284@digitalkingdom.org>
References: <20080203212155.GF12173@digitalkingdom.org> <200802042140.55521.nickpiggin@yahoo.com.au> <20080205171005.GA9284@digitalkingdom.org> <18344.50892.5633.905311@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18344.50892.5633.905311@notabene.brown>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 07:27:56AM +1100, Neil Brown wrote:
> On Tuesday February 5, rlpowell@digitalkingdom.org wrote:
> > 
> > I was able to solve the problem, however, like so:
> > 
> > 132c133
> > < # CONFIG_PREEMPT_NONE is not set
> > ---
> > > CONFIG_PREEMPT_NONE=y
> > 134,135c135,136
> > < CONFIG_PREEMPT=y
> > < CONFIG_PREEMPT_BKL=y
> > ---
> > > # CONFIG_PREEMPT is not set
> > > # CONFIG_PREEMPT_BKL is not set
> > 
> 
> This suggests that there is some sort of race. Given that I've
> never hit it on SMP machines, it is probably a very small window
> that opens immediately after some event that triggers kernel
> preemption.
> 
> The only "mdadm --monitor" does

Going to stop you right there; "mdadm --monitor" wasn't it, nor was
smartd as I thought at one point.  I honestly don't know what was
triggering it, except maybe disk access.  The fact that backups were
running at the same time as the sync seemed to make it happen
faster; that's the best I've got at this point.

> What sort of hardware do you have?  x86?  SMP or uni-processor?
> Also, exactly what kernel are you running?

rlpowell@chain> uname -a                                                                       
Linux chain.digitalkingdom.org 2.6.23.1-dk3 #4 SMP Mon Feb 4 06:14:44 PST 2008 x86_64 GNU/Linux
rlpowell@chain> cat /proc/cpuinfo                                                              
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 39
model name      : AMD Athlon(tm) 64 Processor 3700+
stepping        : 1
cpu MHz         : 2210.251
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflu
t fxsr_opt lm 3dnowext 3dnow up rep_good pni lahf_lm
bogomips        : 4422.66
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


> I might see if I can reproduce it... so if you can send me the
> broken .config, that might help too.

http://teddyb.org/~rlpowell/media/regular/config-2.6.23.1-dk2.txt

-Robin
