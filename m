Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbXJ3P6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbXJ3P6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbXJ3P6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:58:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2377 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbXJ3P6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MzkKWtzx0YV5iSQm+5qLx/C3H6wa6Ns7jilRvJt8XMRTKajUx5lj79fNe/kN6Db31uXzoGt3ags2YCX2bm+RI7PFXzjLr5Fnw9R2A63Sq0IDKBNMaLgSfpB30TYtPat+zmczOZlVno/C2RzlPgD+Uw8oixbsWPGO4yu6+kJ6628=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/4 -v5] x86_64 EFI runtime service support: EFI runtime services
Date: Tue, 30 Oct 2007 15:58:31 +0000
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1193723743.23935.352.camel@caritas-dev.intel.com>
In-Reply-To: <1193723743.23935.352.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301558.31443.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 05:55, Huang, Ying wrote:
> +static inline unsigned long native_get_wallclock(void)
> +{
> +	unsigned long retval;
> +
> +	if (efi_enabled)
> +		retval = efi_get_time();
> +	else
> +		retval = mach_get_cmos_time();
> +
> +	return retval;
> +}

mach_get_cmos_time() is itself an inline, and a _large_ one
(~20 LOC with macro and function calls).

efi_get_time() is an inline too, although strange one:
it is declared inline *only* in efi.c file:
      inline unsigned long efi_get_time(void)
(yes, just inline, not static/extern),
while efi.h has normal extern for it:
      extern unsigned long efi_get_time(void);

Is it supposed to be like that?

> +static inline int native_set_wallclock(unsigned long nowtime)
> +{
> +	int retval;
> +
> +	if (efi_enabled)
> +		retval = efi_set_rtc_mmss(nowtime);
> +	else
> +		retval = mach_set_rtc_mmss(nowtime);
> +
> +	return retval;
> +}

Same here, only mach_set_rtc_mmss is 50 LOC, not 20.
--
vda
