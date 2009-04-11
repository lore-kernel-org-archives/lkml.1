Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZDKIEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZDKIEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 04:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZDKIDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 04:03:53 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54498 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZDKIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 04:03:52 -0400
Date: Sat, 11 Apr 2009 10:05:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] x86: mm/pat.c pat_disable should be static
Message-ID: <20090411080557.GB30873@uranus.ravnborg.org>
References: <1239436493.3975.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239436493.3975.1.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 01:24:53PM +0530, Jaswinder Singh Rajput wrote:
> Impact: reduce kernel size a bit, avoid sparse warning
> 
> Fixes sparse warning:
>   arch/x86/mm/pat.c:34:16: warning: symbol 'pat_disable' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/mm/pat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index cc5e0e2..bc53d8d 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -31,7 +31,7 @@
>  #ifdef CONFIG_X86_PAT
>  int __read_mostly pat_enabled = 1;
>  
> -void __cpuinit pat_disable(const char *reason)
> +static void __cpuinit pat_disable(const char *reason)
>  {
>  	pat_enabled = 0;
>  	printk(KERN_INFO "%s\n", reason);

This is fixed in a better way.
See Marcin's patch: http://lkml.org/lkml/2009/4/10/384

If you had looked carefully at the call-sites you would have noticed that not all
of them were annotated __cpunint/__init.

	Sam
