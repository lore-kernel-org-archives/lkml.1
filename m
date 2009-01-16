Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbZAPNQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbZAPNQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762186AbZAPNQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:16:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762171AbZAPNQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:16:25 -0500
Date: Fri, 16 Jan 2009 14:16:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH x86/percpu] x86_64: initialize this_cpu_off to
	__per_cpu_load
Message-ID: <20090116131601.GA20593@elte.hu>
References: <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu> <496FB09A.8020808@kernel.org> <496FE2B3.3060706@gmail.com> <496FFE45.1070802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496FFE45.1070802@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <htejun@gmail.com> wrote:

> On x86_64, if get_per_cpu_var() is used before per cpu area is setup
> (if lockdep is turned on, it happens), it needs this_cpu_off to point
> to __per_cpu_load.  Initialize accordingly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Okay, this fixes the problem.  Tested with gcc-4.3.2 and binutils-2.19
> (openSUSE 11.1).  For all four variants I can test (64-smp, 64-up,
> 32-smp, 32-up).  This and the previous merge fix patch are available
> in the following git branch.

cool!

>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
>  arch/x86/kernel/smpcommon.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
> index 84395fa..7e15781 100644
> --- a/arch/x86/kernel/smpcommon.c
> +++ b/arch/x86/kernel/smpcommon.c
> @@ -3,8 +3,13 @@
>   */
>  #include <linux/module.h>
>  #include <asm/smp.h>
> +#include <asm/sections.h>
>  
> +#ifdef CONFIG_X86_64
> +DEFINE_PER_CPU(unsigned long, this_cpu_off) = (unsigned long)__per_cpu_load;
> +#else
>  DEFINE_PER_CPU(unsigned long, this_cpu_off);
> +#endif

I've pulled your tree, but couldnt we do this symmetrically in the 32-bit 
case too and avoid the ugly #ifdef somehow?

	Ingo
