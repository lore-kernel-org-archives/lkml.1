Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbZCDORm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbZCDORm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 09:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZCDORc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 09:17:32 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:44596 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZCDORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 09:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fs9B3wJrT1pFn/hLwprVRKITHmNAm5fEYcBCRYYv3ymaS5HtR50u8xtep8e7zteHS/
         EJJAEGCv5JGjHPBHxtP8YG1cUL4uMuecn/RhpeovoJHYpTByXm4kjYN3wl5R2FxCKNYy
         Hpdf/Xw9T7cathFoZvehTnh1BF2CDNJ/uDFUU=
Date: Wed, 4 Mar 2009 23:17:23 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] generic debug pagealloc
Message-ID: <20090304141721.GC7168@localhost.localdomain>
References: <20090303160103.GB5812@localhost.localdomain> <20090303133610.cb771fef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20090303133610.cb771fef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 01:36:10PM -0800, Andrew Morton wrote:
> Alternatively, we could just not do the kmap_atomic() at all.  i386
> won't be using this code and IIRC the only other highmem architecture
> is powerpc32, and ppc32 appears to also have its own DEBUG_PAGEALLOC
> implementation.  So you could remove the kmap_atomic() stuff and put
> 
> #ifdef CONFIG_HIGHMEM
> #error i goofed
> #endif
> 
> in there.

I'll take the variant of this. Then poison_page() will be

static void poison_page(struct page *page)
{
        void *addr;

        if (PageHighmem(page))
                return; // i goofed

       page->poison = true;
       addr = page_address(page);
       memset(addr, PAGE_POISON, PAGE_SIZE);
}
