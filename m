Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbXJIQGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbXJIQGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 12:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXJIQGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 12:06:42 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:26150 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755037AbXJIQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 12:06:41 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Tue, 9 Oct 2007 18:06:05 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
cc: "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Egger" <Christoph.Egger@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i386: mce cleanup part1: functional change
Message-ID: <20071009160605.GC13205@amd.com>
References: <11919341961890-git-send-email-joerg.roedel@amd.com>
 <11919341961530-git-send-email-joerg.roedel@amd.com>
 <E1IfHZg-0003dp-FA@flower>
MIME-Version: 1.0
In-Reply-To: <E1IfHZg-0003dp-FA@flower>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 09 Oct 2007 16:06:06.0168 (UTC)
 FILETIME=[4C4B0D80:01C80A8E]
X-WSS-ID: 6B15788A0601317252-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 06:04:48PM +0200, Oleg Verych wrote:
> * Tue,  9 Oct 2007 14:49:55 +0200
> 
> []
> > @@ -33,9 +33,20 @@ void fastcall (*machine_check_vector)(struct pt_regs *, long error_code) = unexp
> >  /* This has to be run for each processor */
> >  void mcheck_init(struct cpuinfo_x86 *c)
> >  {
> > +	uint32_t mca, mce;
> > +
> >  	if (mce_disabled==1)
> >  		return;
> >  
> > +	mca = cpu_has(c, X86_FEATURE_MCA);
> > +	mce = cpu_has(c, X86_FEATURE_MCE);
> > +
> > +	if (!mca || !mce) {
> > +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > +			smp_processor_id());
> > +		return;
> > +	}
> > +
> 
> cpu_has() returns int,
> but would it be better to have something like
> 
>   	if (!mce_disabled &&
> 	    !(c->x86_capability & (X86_FEATURE_MCA | X86_FEATURE_MCE)) {
> 		printk(KERN_INFO "CPU%i: No machine check support available\n",
> 			smp_processor_id());

This looks complicated and is harder to read. Its exactly the purpose of the
cpu_has() macro to avoid such constructs.

> 		return;
> 	} else
> 		return;

Return unconditionaly here?

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


