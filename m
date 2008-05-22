Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbYEVSGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYEVSGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbYEVSGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:06:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbYEVSGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:06:05 -0400
Date: Thu, 22 May 2008 13:02:23 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Add recent Centaur CPUs to PAT whitelist
Message-ID: <20080522170223.GA32314@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200805200409.m4K49V3G024332@gelk.kernelslacker.org> <86802c440805192249y77e78918u8392f5a43331365@mail.gmail.com> <20080520131943.GA4843@redhat.com> <4834B6AC.9090503@zytor.com> <20080522140753.GB20613@redhat.com> <4835A3EC.1030307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4835A3EC.1030307@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:48:44AM -0700, H. Peter Anvin wrote:
 > Dave Jones wrote:
 > > On Wed, May 21, 2008 at 04:56:28PM -0700, H. Peter Anvin wrote:
 > >  > Dave Jones wrote:
 > >  > > 
 > >  > > From conversation with Centaur engineers, both the newer generations
 > >  > > of the VIA C7, and their future CPUs support PAT, with no known errata.
 > >  > > 
 > >  > > Signed-off-by: Dave Jones <davej@redhat.com>
 > >  > > 
 > >  > 
 > >  > Question: are there any VIA CPUs that display the PAT CPUID flag that 
 > >  > aren't covered by the above?
 > > 
 > > No.  They only added PAT support with the current Esther (C7) generation iirc.
 > > 
 > 
 > OK, so we should just enable VIA unconditionally as long as PAT is 
 > displayed and not worry about generation numbers; same with Transmeta 
 > (only the Transmeta Efficeon supported PAT, and it had a 
 > strictly-coherent memory system.)

Like so?

Unconditionally enable PAT support on Centaur and Transmeta CPUs.
All known models that advertise PAT have no known errata.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c~	2008-05-22 12:59:07.000000000 -0400
+++ linux-2.6/arch/x86/kernel/cpu/addon_cpuid_features.c	2008-05-22 12:59:36.000000000 -0400
@@ -62,6 +62,9 @@ void __cpuinit validate_pat_support(stru
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
 			return;
 		break;
+	case X86_VENDOR_CENTAUR:
+	case X86_VENDOR_TRANSMETA:
+		return;
 	}
 
 	pat_disable(cpu_has_pat ?

-- 
http://www.codemonkey.org.uk
