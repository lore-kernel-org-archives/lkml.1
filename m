Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYHGNQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYHGNQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYHGNQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:16:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbYHGNQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:16:45 -0400
Date: Thu, 7 Aug 2008 09:15:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/6] kexec jump: check code size in control page
Message-ID: <20080807131557.GB27783@redhat.com>
References: <1218099926.5164.33.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099926.5164.33.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 05:05:26PM +0800, Huang Ying wrote:
> Kexec/Kexec-jump requires code size in control page is less than
> PAGE_SIZE/2. This patch adds runtime checking for this.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/kernel/machine_kexec_32.c   |    4 ++++
>  arch/x86/kernel/relocate_kernel_32.S |    3 +++
>  include/asm-x86/kexec.h              |    1 +
>  3 files changed, 8 insertions(+)
> 
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -92,6 +92,10 @@ int machine_kexec_prepare(struct kimage 
>  {
>  	if (nx_enabled)
>  		set_pages_x(image->control_code_page, 1);
> +
> +	BUG_ON((unsigned long)kexec_control_page_code_end - \
> +	       (unsigned long)relocate_kernel >= PAGE_SIZE/2);
> +

Hi Huang,

Run time check is better than nothing but I think in this case it would
be better if we can catch it at compile time. 

One of the methods will be to write a small program of your own and
put in script/ and at build time check for the size and flag error. May
be there are other better ways to do this.

Thanks
Vivek
