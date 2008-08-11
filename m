Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYHKBCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYHKBCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 21:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYHKBCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 21:02:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:15739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYHKBCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 21:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,341,1215414000"; 
   d="scan'208";a="605621543"
Subject: Re: [PATCH -v2 3/8] kexec jump: check code size in control page
From: Huang Ying <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080808140938.GE3840@redhat.com>
References: <1218178356.22039.76.camel@caritas-dev.intel.com>
	 <20080808140938.GE3840@redhat.com>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 09:02:38 +0800
Message-Id: <1218416558.30464.12.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek,

On Fri, 2008-08-08 at 10:09 -0400, Vivek Goyal wrote:
[...]
> > --- a/arch/x86/kernel/relocate_kernel_32.S
> > +++ b/arch/x86/kernel/relocate_kernel_32.S
> > @@ -20,10 +20,11 @@
> >  #define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
> >  #define PAE_PGD_ATTR (_PAGE_PRESENT)
> >  
> > -/* control_page + PAGE_SIZE/2 ~ control_page + PAGE_SIZE * 3/4 are
> > - * used to save some data for jumping back
> > +/* control_page + KEXEC_CONTROL_CODE_MAX_SIZE
> > + * ~ control_page + PAGE_SIZE * 3/4 are used to save some data for
> > + * jumping back
> >   */
> 
> Hi Huang,
> 
> Above comment is not very clear. Can you please elaborate it. I thought
> that PAGE_SIZE/2 is used for control code and rest half is shared between
> kjump data and stack. What is PAGE_SIZE *3/4?

Yes. Rest half is shared between kjump data and stack. I will change it.

> > +++ b/arch/x86/kernel/vmlinux_check_32.lds.S
> > @@ -0,0 +1,7 @@
> > +/*
> > + * Link time checks
> > + */
> > +
> > +#include <asm/kexec.h>
> > +
> > +ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
> "kexec control code size is too big")
> 
> Will it make sense to move it into vmlinux_32.lds.S itself? Creating a
> separate
> file for a single check seems superfluous.

I hope other ones can use it. But for now, put it in vmlinux_32.lds.S is
better. I will change it.

Best Regards,
HUang Ying


