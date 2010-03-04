Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0CDVn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:43:59 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:16475 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0CDVn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:43:56 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zz154dM1432Rab9bhzz1202hzzz32i6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYS1P1-02-GY8-02
X-M-MSG: 
Date: Thu, 4 Mar 2010 22:43:59 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Langsdorf <mark.langsdorf@amd.com>, <linux-kernel@vger.kernel.org>,
       <cpufreq@vger.kernel.org>, <bhavna.sarathy@amd.com>,
       <joachim.deguara@amd.com>
Subject: Re: [PATCH 2/3] [cpufreq] powernow-k8: add core performance boost
 support
Message-ID: <20100304214359.GA29002@aftab>
References: <201003031458.27538.mark.langsdorf@amd.com>
 <20100304132328.3391dba5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100304132328.3391dba5.akpm@linux-foundation.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Mar 2010 21:43:43.0658 (UTC) FILETIME=[C2F978A0:01CABBE3]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, Mar 04, 2010 at 01:23:28PM -0800

Hi Andrew,

[..]

> > +/* CPB 0=disable, 1=enable. */
> > +static void cpb_toggle(u32 t)
> > +{
> > +	if (cpb_capable) {
> > +		u32 lo, hi;
> > +		rdmsr(MSR_K7_HWCR, lo, hi);
> > +
> 
> The newline usually goes after end-of-locals, before start-of-code.

Done.

> > +		if (t)
> > +			lo &= ~(1 << 25);
> > +		else
> > +			lo |= (1 << 25);
> > +
> > +		wrmsr(MSR_K7_HWCR, lo, hi);
> > +
> > +		printk(KERN_ERR "CPB: %s.\n", (t ? "on" : "off"));
> 
> Why KERN_ERR?  It's not an error?
> 
> Do we want a printk here at all?  Under which circumstances will it come
> out?  Does it have sufficient context for people to be able to
> understand what it means, and which subsystem it's referring to?  If
> you phone your Aunt Tillie and tell her "CPB: on", will she understand
> what you mean?

This isn't actually supposed to be there - it was there only for
debugging.

These patches weren't supposed to go out just yet so please drop them
from your tree for now - I'll have corrected versions with proper
changelogs soon.

> > --- a/include/linux/cpufreq.h
> > +++ b/include/linux/cpufreq.h
> > @@ -104,6 +104,10 @@ struct cpufreq_policy {
> >  
> >  	struct kobject		kobj;
> >  	struct completion	kobj_unregister;
> > +
> > +	struct flags {
> > +		unsigned long cpb:1;	/* toggle CPB on this cpu */
> > +	} flags;
> >  };
> 
> Bear in mind that the compiler provides no atomicity support for
> bitfields.  So if someone later comes along and adds a new field to
> `flags', they will need to provide external synchronisation (ie: a
> lock) to protect that field during modifications to `cpb'.
> 
> IOW, this is a bit of a hand-grenade.

Ok, I'll switch to a unsigned long for the flags.

Thanks.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center

