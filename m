Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYHMCrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYHMCrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 22:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYHMCrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 22:47:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48987 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYHMCrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 22:47:07 -0400
Date: Wed, 13 Aug 2008 12:47:04 +1000
From: Simon Horman <horms@verge.net.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec jump: fix code size checking
Message-ID: <20080813024701.GA19201@verge.net.au>
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

Is it impossible to skip the linker check in the !CONFIG_KEXEC case?

