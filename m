Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbXJaApR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbXJaApR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbXJaApF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:45:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:6981 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXJaApE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:45:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,349,1188802800"; 
   d="scan'208";a="259049461"
Subject: Re: [PATCH 2/4 -v5] x86_64 EFI runtime service support: EFI
	runtime services
From: "Huang, Ying" <ying.huang@intel.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710301558.31443.vda.linux@googlemail.com>
References: <1193723743.23935.352.camel@caritas-dev.intel.com>
	 <200710301558.31443.vda.linux@googlemail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Oct 2007 08:47:47 +0800
Message-Id: <1193791667.23935.383.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 31 Oct 2007 00:44:45.0425 (UTC) FILETIME=[3B7D9610:01C81B57]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 15:58 +0000, Denys Vlasenko wrote:
> On Tuesday 30 October 2007 05:55, Huang, Ying wrote:
> > +static inline unsigned long native_get_wallclock(void)
> > +{
> > +	unsigned long retval;
> > +
> > +	if (efi_enabled)
> > +		retval = efi_get_time();
> > +	else
> > +		retval = mach_get_cmos_time();
> > +
> > +	return retval;
> > +}
> 
> mach_get_cmos_time() is itself an inline, and a _large_ one
> (~20 LOC with macro and function calls).
> 
> efi_get_time() is an inline too, although strange one:
> it is declared inline *only* in efi.c file:
>       inline unsigned long efi_get_time(void)
> (yes, just inline, not static/extern),
> while efi.h has normal extern for it:
>       extern unsigned long efi_get_time(void);
> 
> Is it supposed to be like that?

efi_get_time is no longer inline in this patch. See efi.c of this patch.

Best Regards,
Huang Ying
