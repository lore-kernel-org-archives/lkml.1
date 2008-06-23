Return-Path: <linux-kernel-owner+w=401wt.eu-S1759483AbYFWRFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483AbYFWRFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbYFWRFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:05:09 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:6131 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYFWRFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qU0KYiJMncwGoqZcH2TzabHGbctp9zVq5aoxR8yNL/CzruOMOL+wj79kv0ybdvqbAR
         hcn/+npwozPKpoXXkQxgyoT7uM14NRqga9dI2W8BPFu4MnSR7Xo7Mum9eSBv0BbJA28I
         8GflsihN1k5GMpC81bR1kLemChQZJ/Z/L9yTc=
Message-ID: <b6a2187b0806231005x44b69918q111e865938c55e7@mail.gmail.com>
Date: Tue, 24 Jun 2008 01:05:04 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 2/5] Reinstate ZERO_PAGE optimization in get_user_pages() and fix XIP
Cc: "Hugh Dickins" <hugh@veritas.com>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Oleg Nesterov" <oleg@tv-sign.ru>, "Nick Piggin" <npiggin@suse.de>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Roland McGrath" <roland@redhat.com>
In-Reply-To: <alpine.LFD.1.10.0806230928140.2926@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622185327.348377223@mini.kroah.org>
	 <20080622190140.GD20141@suse.de>
	 <alpine.LFD.1.10.0806221220530.2926@woody.linux-foundation.org>
	 <20080622202950.GB20800@suse.de>
	 <b6a2187b0806230832j10e8be28vc0b05fea233437fa@mail.gmail.com>
	 <Pine.LNX.4.64.0806231650190.13651@blonde.site>
	 <alpine.LFD.1.10.0806230928140.2926@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 12:39 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> So here's a third patch to test. It removes the VM_SHARED thing just to
> get us closer to the original code (and because do_no_page() didn't do it
> historically, so let's not do it either), and it re-instates the insane
> VM_LOCKED test with a comment.
>
> Jeff, does this still work with vmware?


No, this breaks vmware. Does this trace help?

Jun 24 00:54:49.325: vmx| NOT_IMPLEMENTED
/build/mts/release/bora-93057/bora/vmx/main/vmmonPosix.c:774
Jun 24 00:54:49.325: vmx| Backtrace:
Jun 24 00:54:49.325: vmx| Backtrace[0] 0xbffc30c8 eip 0x8052f10
Jun 24 00:54:49.325: vmx| Backtrace[1] 0xbffc34f8 eip 0x80f2f7d
Jun 24 00:54:49.325: vmx| Backtrace[2] 0xbffc3548 eip 0x80e4b15
Jun 24 00:54:49.325: vmx| Backtrace[3] 0xbffc3638 eip 0x837b341
Jun 24 00:54:49.325: vmx| Backtrace[4] 0xbffc3688 eip 0x837cde4
Jun 24 00:54:49.325: vmx| Backtrace[5] 0xbffc36b8 eip 0x80fda89
Jun 24 00:54:49.325: vmx| Backtrace[6] 0xbffc36e8 eip 0x80f36f5
Jun 24 00:54:49.325: vmx| Backtrace[7] 0xbffc3728 eip 0x80f3bd4
Jun 24 00:54:49.325: vmx| Backtrace[8] 0xbffc3788 eip 0x80511be
Jun 24 00:54:49.325: vmx| Backtrace[9] 0xbffc3878 eip 0x8051561
Jun 24 00:54:49.325: vmx| Backtrace[10] 0xbffc38e8 eip 0xb7e374c0
Jun 24 00:54:49.325: vmx| Backtrace[11] 00000000 eip 0x804e7b1
Jun 24 00:54:49.325: vmx| Core dump limit is 0 kb.
Jun 24 00:54:49.326: vmx| Cannot remap region MonWired (addr=(nil),
size=0x13000, offset=0x19000)
Jun 24 00:54:49.326: vmx| Cannot remap region PShareMPN (addr=(nil),
size=0x1000, offset=0x18000)
Jun 24 00:54:49.326: vmx| Remapping region BusMemFrame1 as MAP_PRIVATE
(addr=0xb7f9c000, size=0x1000, offset=0x17000)
Jun 24 00:54:49.326: vmx| Remapping region BusMemFrame0 as MAP_PRIVATE
(addr=0xb7f9d000, size=0x1000, offset=0x16000)
Jun 24 00:54:49.326: vmx| Cannot remap region PhysRegion0 (addr=(nil),
size=0x1000, offset=0x15000)
Jun 24 00:54:49.326: vmx| Msg_Post: Error
Jun 24 00:54:49.326: vmx| [msg.log.error.unrecoverable] VMware
Workstation unrecoverable error: (vmx)
Jun 24 00:54:49.326: vmx| NOT_IMPLEMENTED
/build/mts/release/bora-93057/bora/vmx/main/vmmonPosix.c:774


Thanks,
Jeff.




>  mm/memory.c |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 9aefaae..a2ce28d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1045,6 +1045,23 @@ no_page_table:
>        return page;
>  }
>
> +/* Can we do the FOLL_ANON optimization? */
> +static inline int use_zero_page(struct vm_area_struct *vma)
> +{
> +       /*
> +        * We don't want to optimize FOLL_ANON for make_pages_present()
> +        * when it tries to page in a VM_LOCKED region.
> +        */
> +       if (vma->vm_flags & VM_LOCKED)
> +               return 0;
> +       /*
> +        * And if we have a fault or a nopfn routine, it's not an
> +        * anonymous region.
> +        */
> +       return !vma->vm_ops ||
> +               (!vma->vm_ops->fault && !vma->vm_ops->nopfn);
> +}
> +
>  int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>                unsigned long start, int len, int write, int force,
>                struct page **pages, struct vm_area_struct **vmas)
> @@ -1119,8 +1136,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
>                foll_flags = FOLL_TOUCH;
>                if (pages)
>                        foll_flags |= FOLL_GET;
> -               if (!write && !(vma->vm_flags & VM_LOCKED) &&
> -                   (!vma->vm_ops || !vma->vm_ops->fault))
> +               if (!write && use_zero_page(vma))
>                        foll_flags |= FOLL_ANON;
>
>                do {
>
