Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZJ0Rb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZJ0Rb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZJ0Rb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:31:58 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:20231 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZJ0Rb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:31:57 -0400
MIME-Version: 1.0
Message-ID: <4f079cd6-0872-4cb5-832b-ee6a46841192@default>
Date: Tue, 27 Oct 2009 10:29:22 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add	vsyscall
	implementation
In-Reply-To: <4AD5C4ED.3050809@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AE72E61.0048:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any way for an application to conclusively determine
programmatically if the "fast vsyscall" pvclock is functional
vs the much much slower gettimeofday/clock_gettime equivalents?

If not, might it be possible to implement some (sysfs?)
way to determine this, that would also be backwards compatible
to existing OS's that don't have pvclock+vsyscall supported?

Thanks,
Dan

> -----Original Message-----
> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Wednesday, October 14, 2009 6:33 AM
> To: Jeremy Fitzhardinge
> Cc: Dan Magenheimer; Jeremy Fitzhardinge; Kurt Hackel; the arch/x86
> maintainers; Linux Kernel Mailing List; Glauber de Oliveira Costa;
> Xen-devel; Keir Fraser; Zach Brown; Chris Mason; Ingo Molnar
> Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
> implementation
> 
> 
> On 10/14/2009 05:00 AM, Jeremy Fitzhardinge wrote:
> >
> >> So it's broken or disabled when that assumption is wrong?  We could
> >> easily fix that now.  Might even reuse the pvclock structures.
> >>      
> > Well, the kernel internally makes more or less the same 
> assumption; the
> > vsyscall clocksource is the same as the kernel's internal 
> one.  I think
> > idea is that it just drops back to something like hpet if the tsc
> > doesn't have very simple SMP characteristics.
> >
> > If the kernel could characterize the per-cpu properties of 
> the tsc more
> > accurately, then it could use the pvclock mechanism on native.
> >    
> 
> It does - that's how kvm implements pvclock on the host side.  See 
> kvmclock_cpufreq_notifier() in arch/x86/kvm/x86.c.
> 
> -- 
> I have a truly marvellous patch that fixes the bug which this
> signature is too narrow to contain.
> 
> 
>
