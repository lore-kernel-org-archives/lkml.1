Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbZKKQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbZKKQeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757062AbZKKQeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:34:24 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:54475 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZKKQeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OkCrdugaMnbIoHC4PXofOl9JB1H+7uyVYy/D6Fzffw3SHq4ixVSZcPR37Ae/Fr6eHj
         vrSp4slt+v5kA+gO68cES9xqKqwH6wc3QajpQlspqy+yav/lDggcrvGdw9Gt94Nn8rC8
         yphkshbgmYmLRcGKxtZ6+lscrqfyhn9PGcdas=
Date: Wed, 11 Nov 2009 17:34:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, acme@redhat.com, rosted@goodmis.org,
       paulus@samba.org
Subject: Re: Hard lockup with timer events
Message-ID: <20091111163417.GA5255@nowhere>
References: <ye8hbtiko5k.fsf@camel23.daimi.au.dk> <20091111045004.GA5421@nowhere> <1257945781.4372.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257945781.4372.34.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 02:23:01PM +0100, Peter Zijlstra wrote:
> On Wed, 2009-11-11 at 05:50 +0100, Frederic Weisbecker wrote:
> > On Thu, Oct 29, 2009 at 08:15:03PM +0100, Soeren Sandmann wrote:
> > > Hi,
> > > 
> > > This program
> > > 
> > >         http://www.daimi.au.dk/~sandmann/lockup.c
> > > 
> > > locks up hard for me on a Pentium 4 in 32 bit mode, with the hrtimer
> > > patches applied (-tip for example).
> > > 
> > > What the program does is spawn a thread that just spins, and then 400
> > > threads that each create a performance counter of type
> > > PERF_COUNT_SW_CPU_CLOCK and a sample period of 1000000 and a
> > > sample_type of
> > > 
> > >         PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_CALLCHAIN
> > > 
> > > These threads then map the event buffer and read it continuously.
> > > 
> > > It does not apparently lock up if SAMPLE_CALLCHAIN is removed; also I
> > > cannot get it to lock up on Core 2 Duo in either 32 or 64 bit mode.
> > > 
> > > 
> > > Soren
> > 
> > 
> > 
> > It locks up hard for me too, no more blinking cursor, nothing.
> > I've attached my config, it's against tip:master from yesterday.
> 
> What kind of cpu does your laptop have? The .config seems to suggest a
> Core2. Which would make Soeren's report of not being able to trash a
> 64bit core2 'interesting' ;-)


Nop it's a Pentium Dual Core :)

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz
stepping	: 13
cpu MHz		: 800.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr 
sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl 
est tm2 ssse3 cx16 xtpr pdcm lahf_lm
bogomips	: 2925.95
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

