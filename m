Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXJDS6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXJDS6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757420AbXJDS6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:58:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:52975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223AbXJDS6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:58:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: [rfc][patch 2/3] x86: fix IO write barriers
Date: Thu, 4 Oct 2007 20:58:27 +0200
User-Agent: KMail/1.9.6
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071004052153.GA15131@wotan.suse.de> <200710042021.59704.ak@suse.de> <20071004184107.GC23300@redhat.com>
In-Reply-To: <20071004184107.GC23300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710042058.27640.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2007 20:41:07 Dave Jones wrote:
> On Thu, Oct 04, 2007 at 08:21:59PM +0200, Andi Kleen wrote:
>  > On Thursday 04 October 2007 20:10:44 Dave Jones wrote:
>  > > On Thu, Oct 04, 2007 at 07:53:16PM +0200, Andi Kleen wrote:
>  > >  > 
>  > >  > > The only vendor that ever implemented OOSTOREs was Centaur, and they
>  > >  > > only did in the Winchip generation of the CPUs.  When they dropped it
>  > >  > > from the C3, I asked whether they intended to bring it back, and the
>  > >  > > answer was "extremely unlikely".
>  > >  > >
>  > >  > 
>  > >  > Do you know if it made a big performance difference?
>  > > 
>  > > On the winchip, it was a huge win. I can't remember exact numbers,
>  > > but pretty much every benchmark I threw at it at the time showed
>  > > significant improvement.
>  > 
>  > Significant as in >10%?
> 
> "Worth about 10-20% performance" according to the 2.4.18pre9-ac4
> release notes: http://www.linuxtoday.com/news_story.php3?ltsn=2002-02-14-015-20-NW-KN

Are there numbers for a newer kernel available too?

>  > >  > But yes we should probably just remove this special case to make 
>  > >  > maintenance easier.
>  > > It's CONFIG_SMP anyway, which none of the winchips were.
>  > 
>  > It's not.
> 
> You're right it isn't now, but Nicks patch seems to change it so that it is.
> 
> ...
> 
>  #ifdef CONFIG_SMP
>  #define smp_mb()       mb()
>  #define smp_rmb()      rmb()
> -#define smp_wmb()      wmb()
> +#ifdef CONFIG_X86_OOSTORE
> +# define smp_wmb()     wmb()
> +#else
> +# define smp_wmb()     barrier()
> +#endif

That is only for smp_wmb() which are always SMP only

-Andi
