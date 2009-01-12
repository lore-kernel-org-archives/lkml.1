Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZALVET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZALVET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZALVEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:04:06 -0500
Received: from mail-gx0-f12.google.com ([209.85.217.12]:52273 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbZALVEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f+jEdY+sIsUmGBOCvVUpGNNToOmsHjUq/7Xaew4etdayYqY7SL9uXJeQiNGGWOb725
         NMYHXXXzOMKmop7hqsTHhbL5VmvwTbZU8FY/rPtl4oSgsT2Z68NFzPyCsQbwZssqyBhM
         KT36k3YkxF7LIN7/gAHV9NhpX3ttEZfLu/uSg=
Subject: Re: [git pull] x86 fixes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090112205259.GA5303@elte.hu>
References: <20090111143951.GA6666@elte.hu>
	 <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com>
	 <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com>
	 <20090112191934.GA28851@linux-os.sc.intel.com>
	 <20090112192912.GA31650@linux-os.sc.intel.com>
	 <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain>
	 <20090112205259.GA5303@elte.hu>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 13:03:49 -0800
Message-Id: <1231794230.5405.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 21:52 +0100, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:

> +static inline int is_new_memtype_allowed(unsigned long flags,
> +                                               unsigned long new_flags)
> +{
> +       /*
> +        * Certain new memtypes are not allowed with certain
> +        * requested memtype:
> +        * - request is uncached, return cannot be write-back
> +        * - request is write-combine, return cannot be write-back
> +        */
> +       if ((flags == _PAGE_CACHE_UC_MINUS &&
> +            new_flags == _PAGE_CACHE_WB) ||
> +           (flags == _PAGE_CACHE_WC &&
> +            new_flags == _PAGE_CACHE_WB)) {
> +               return 0;
> +       }

	if ((flags == _PAGE_CACHE_UC_MINUS || flags == _PAGE_CACHE_WC) &&
	    (new_flags == _PAGE_CACHE_WB))

might be a bit neater perhaps.

Harvey

