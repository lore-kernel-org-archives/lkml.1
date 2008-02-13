Return-Path: <linux-kernel-owner+w=401wt.eu-S1760810AbYBMHCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbYBMHCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbYBMHCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:02:01 -0500
Received: from www.tglx.de ([62.245.132.106]:37199 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbYBMHCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:02:00 -0500
Date: Wed, 13 Feb 2008 08:01:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git-x86 mm branch compile error
In-Reply-To: <47B2377C.3000207@gmail.com>
Message-ID: <alpine.LFD.1.00.0802130759180.12988@apollo.tec.linutronix.de>
References: <47B2366C.4020901@gmail.com> <47B2377C.3000207@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1919183126-1202886107=:12988"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1919183126-1202886107=:12988
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 12 Feb 2008, Kevin Winchester wrote:

> Kevin Winchester wrote:
> >   CC      arch/x86/mm/pageattr.o
> > arch/x86/mm/pageattr.c: In function ‘change_page_attr_set_clr’:
> > arch/x86/mm/pageattr.c:778: error: incompatible type for argument 1 of
> > ‘cpa_check_alias’
> > make[1]: *** [arch/x86/mm/pageattr.o] Error 1
> > make: *** [arch/x86/mm] Error 2
> > 
> > at tip 5248bbad9c72dd576aa8f3b44b5a959a7cae6ce1 x86: make
> > DEBUG_PAGEALLOC & HIBERNATE work

Sorry. I pushed the wrong branch out.

> I assume the following is an acceptable fix (it will be completely
> whitespace damaged due to thunderbird, but I think you get the idea)

Applied. Thanks,

	 tglx

> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index cf91149..76a3de5 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -729,7 +729,7 @@ cpa_check_alias(struct cpa_data *cpa, unsigned long
> addr, int numpages)
>  #else
> 
>  static int
> -cpa_check_alias(struct cpa_data cpa, unsigned long addr, int numpages)
> +cpa_check_alias(struct cpa_data *cpa, unsigned long addr, int numpages)
>  {
>         return 0;
>  }
> 
--8323328-1919183126-1202886107=:12988--
