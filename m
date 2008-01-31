Return-Path: <linux-kernel-owner+w=401wt.eu-S933900AbYAaNab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbYAaNab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbYAaNaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:30:23 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:17340 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765905AbYAaNaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:30:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=APYNKdCnLYLuaNYlEB0/F8xQA13kMpghy61a2MddqQ4ro56PKAUV1KiDqn6r+2hkYcQKEXz+SXiTRec7NiXRU0HrDvk03Twe3eQJ/NQ2Df6ESu5SL91M3wsPUxisc5sRgbo1eGdoekdHFNtVBcimozQXtnteONt3sStUQ7qUiPo=
Message-ID: <851fc09e0801310530p5f5839aat141ae9fcb6713b25@mail.gmail.com>
Date: Thu, 31 Jan 2008 21:30:19 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 5/5] x86: EFI memory mapping changes according to changes to ioremap and c_p_a
Cc: "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080131121823.GF12571@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201764968.12950.26.camel@caritas-dev.intel.com>
	 <20080131121823.GF12571@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan 31, 2008 8:18 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Huang, Ying <ying.huang@intel.com> wrote:
>
> > +                     /* Assume pages are mapped as WB */
> > +                     if (mode == IOR_MODE_UNCACHED)
> > +                             set_memory_uc(md->virt_addr, md->num_pages);
> > +                     /* Assume pages are mapped as unexecutable */
> > +                     if ((__supported_pte_mask & _PAGE_NX) &&
> > +                         xmode == IOR_XMODE_EXEC)
> > +                             set_memory_x(md->virt_addr, md->num_pages);
>
> hm, why is the check for __supported_pte_mask needed? That is already
> listened to in set_memory_x(). [if not then it's an ioremap bug that we
> want to fix.]

OK, I will check it.

> > -static int ioremap_change_attr(unsigned long paddr, unsigned long size,
> > -                            enum ioremap_mode mode,
> > -                            enum ioremap_xmode xmode)
> > +int ioremap_change_attr(unsigned long paddr, unsigned long size,
> > +                     enum ioremap_mode mode,
> > +                     enum ioremap_xmode xmode)
>
> hm, there should be no need to use this raw API.

Oh, you are right. __efi_ioremap() is only used when there is no
identity map. So ioremap_change_attr() need not to be called in
__efi_ioremap().

Best Regards,
Huang Ying
