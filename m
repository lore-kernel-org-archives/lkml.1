Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbZIUMCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbZIUMCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbZIUMCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:02:44 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:34995 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbZIUMCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:02:43 -0400
X-Trace: 261256486/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.63.13/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.63.13
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAFUIt0pQKT8N/2dsb2JhbACBU852gjCBawU
X-IronPort-AV: E=Sophos;i="4.44,424,1249254000"; 
   d="scan'208";a="261256486"
Date: Mon, 21 Sep 2009 13:02:44 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
       ebmunson@us.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-ia64@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] remove duplicate asm/mman.h files
In-Reply-To: <alpine.DEB.1.00.0909210208180.16086@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0909211258570.7831@sister.anvils>
References: <cover.1251197514.git.ebmunson@us.ibm.com> <200909181848.42192.arnd@arndb.de>
 <alpine.DEB.1.00.0909181236190.27556@chino.kir.corp.google.com>
 <200909211031.25369.arnd@arndb.de> <alpine.DEB.1.00.0909210208180.16086@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, David Rientjes wrote:
> On Mon, 21 Sep 2009, Arnd Bergmann wrote:
> 
> > > > -#define MCL_CURRENT	1		/* lock all current mappings */
> > > > -#define MCL_FUTURE	2		/* lock all future mappings */
> > > > +#define MAP_GROWSUP	0x0200		/* register stack-like segment */
> > > >  
> > > >  #ifdef __KERNEL__
> > > >  #ifndef __ASSEMBLY__
> > > 
> > > ia64 doesn't use MAP_GROWSUP, so it's probably not necessary to carry it 
> > > along with your cleanup.
> > 
> > ia64 is the only architecture defining it, nobody uses it in the kernel.
> > If the ia64 maintainers want to remove it in a separate patch, that
> > would probably be a good idea.
> > 
> 
> I'll do it then.
> 
> > I tried not to change the ABI in any way in my patch, and there is
> > a theoretical possibility that some user space program on ia64 currently
> > depends on that definition.
> > 
> 
> I don't buy that as justification, if some userspace program uses it based 
> on the false belief that it actually does what it says, it's probably 
> better to break their build than perpetuating the lie that it's different 
> than ~MAP_GROWSDOWN.
> 
> 
> ia64: remove definition for MAP_GROWSUP
> 
> MAP_GROWSUP is unused.

Is it perhaps the case that some UNIX on ia64 does implement MAP_GROWSUP,
and these numbers in the Linux ia64 mman.h have been chosen to match that
reference implementation?  Tony will know.  But I wonder if you'd do
better at least to leave a MAP_GROWSUP comment on that line, so that
somebody doesn't go and reuse the empty slot later on.

Hugh

> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> diff --git a/arch/ia64/include/asm/mman.h b/arch/ia64/include/asm/mman.h
> --- a/arch/ia64/include/asm/mman.h
> +++ b/arch/ia64/include/asm/mman.h
> @@ -11,7 +11,6 @@
>  #include <asm-generic/mman-common.h>
>  
>  #define MAP_GROWSDOWN	0x00100		/* stack-like segment */
> -#define MAP_GROWSUP	0x00200		/* register stack-like segment */
>  #define MAP_DENYWRITE	0x00800		/* ETXTBSY */
>  #define MAP_EXECUTABLE	0x01000		/* mark it as an executable */
>  #define MAP_LOCKED	0x02000		/* pages are locked */
