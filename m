Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYHMNUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYHMNUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYHMNUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:20:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbYHMNUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:20:22 -0400
Date: Wed, 13 Aug 2008 09:19:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec jump: fix code size checking
Message-ID: <20080813131927.GB3957@redhat.com>
References: <1218589475.24951.59.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218589475.24951.59.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 09:04:35AM +0800, Huang Ying wrote:
> Fix building issue when CONFIG_KEXEC=n. Thanks to Vivek Goyal for his
> reminding.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  include/asm-x86/kexec.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/include/asm-x86/kexec.h
> +++ b/include/asm-x86/kexec.h
> @@ -43,6 +43,9 @@
>  
>  #ifdef CONFIG_X86_32
>  # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
> +# ifndef CONFIG_KEXEC
> +#  define kexec_control_code_size	0
> +# endif
>  #endif
>  
>  #ifndef __ASSEMBLY__

I think Andrew already fixed it. Right way is to put code in vmlinux.lds.S
under #ifdef CONFIG_KEXEC, than defining the symbol kexec_control_code_size
if CONFIG_KEXEC=n

Thanks
Vivek
