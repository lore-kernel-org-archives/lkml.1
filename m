Return-Path: <linux-kernel-owner+w=401wt.eu-S1422660AbXCBApI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422660AbXCBApI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422665AbXCBApH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:45:07 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:58382 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422660AbXCBApG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:45:06 -0500
Message-ID: <45E7738D.5090607@vmware.com>
Date: Thu, 01 Mar 2007 16:45:01 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 12/26] Xen-paravirt_ops: Fix patch site clobbers to include
 return register
References: <20070301232443.195603797@goop.org> <20070301232527.755495278@goop.org>
In-Reply-To: <20070301232527.755495278@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Fix a few clobbers to include the return register.  The clobbers set
> is the set of all registers modified (or may be modified) by the code
> snippet, regardless of whether it was deliberate or accidental.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Zachary Amsden <zach@vmware.com>
>
> ---
>  include/asm-i386/paravirt.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> ===================================================================
> --- a/include/asm-i386/paravirt.h
> +++ b/include/asm-i386/paravirt.h
> @@ -556,7 +556,7 @@ static inline unsigned long __raw_local_
>  					   "popl %%edx; popl %%ecx")
>  			     : "=a"(f): "m"(paravirt_ops.save_fl),
>  			       paravirt_type(PARAVIRT_PATCH(save_fl)),
> -			       paravirt_clobber(CLBR_NONE)
> +			       paravirt_clobber(CLBR_EAX)
>  			     : "memory", "cc");
>  	return f;
>   

Has this been tested on older gcc's?  I seem to recall them barfing over 
things like this.

Zach
