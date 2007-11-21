Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbXKUS1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbXKUS1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXKUS1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:27:08 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54709 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbXKUS1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:27:07 -0500
Subject: Re: [PATCH 2/5] x86: use get_desc_base
From: Zachary Amsden <zach@vmware.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071121102037.A960326F8BE@magilla.localdomain>
References: <20071121101928.A08CF26F8BE@magilla.localdomain>
	 <20071121102037.A960326F8BE@magilla.localdomain>
Content-Type: text/plain
Date: Wed, 21 Nov 2007 10:30:31 -0800
Message-Id: <1195669831.6352.249.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 02:20 -0800, Roland McGrath wrote:
> This changes a couple of places to use the get_desc_base function.
> They were duplicating the same calculation with different equivalent code.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> 
> diff --git a/arch/x86/ia32/tls32.c b/arch/x86/ia32/tls32.c
> index 1cc4340..5291596 100644
> --- a/arch/x86/ia32/tls32.c
> +++ b/arch/x86/ia32/tls32.c
> @@ -85,11 +85,6 @@ asmlinkage long sys32_set_thread_area(struct user_desc __user *u_info)
>   * Get the current Thread-Local Storage area:
>   */
>  
> -#define GET_BASE(desc) ( \
> -	(((desc)->a >> 16) & 0x0000ffff) | \
> -	(((desc)->b << 16) & 0x00ff0000) | \
> -	( (desc)->b        & 0xff000000)   )

Are you sure there still aren't more of these things floating around?  I
recall ptrace and process.c even having one at one point, hopefully they
are all gone.

Nice cleanups,

Zach


