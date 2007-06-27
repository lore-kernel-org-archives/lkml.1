Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbXF0OWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbXF0OWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbXF0OW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:22:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:51240 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbXF0OW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=txyGtgvTq2F4hbjETqIWSvD6hbtBkn1OBEQ9v4vrY1ayPoRoFFVvqMQtSqcPUt8apLqx/1srZf9ho2yrd8mMLxRgmYK5zn1WRYFIDPpJDT+PislFV/VOhucHKTOTHXqeWFTY24IzGiN/2JDC5fgcmKlP9p+T/u9uvRRtwXHnbro=
Message-ID: <da3e877f0706270722x67bb0738x4274b4367e04f0c6@mail.gmail.com>
Date: Wed, 27 Jun 2007 14:22:24 +0000
From: "Mauro Giachero" <mauro.giachero@gmail.com>
To: "Pim Zandbergen" <P.Zandbergen@macroscoop.nl>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Cc: "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Andi Kleen" <andi@firstfloor.org>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <46823F71.6060200@macroscoop.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706251434.43863.jesse.barnes@intel.com>
	 <46823F71.6060200@macroscoop.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Pim Zandbergen <P.Zandbergen@macroscoop.nl> wrote:
> Now:
> Jesse released a new patch and I tried if for fun on 2.6.22-rc6
> It looks like the patch is releasing memory rather than trimming it:
>
> [...]
> Jun 27 12:22:56 corneille kernel: **** MTRRs don't cover all of memory,
> trimmed -65536 pages
> [...]

>From Jesse's patch:
> +       unsigned long i, base, size, highest_addr = 0, def, dummy;
> [...]
> +               printk(KERN_WARNING "**** MTRRs don't cover all of "
> +                      "memory, trimmed %ld pages\n", end_pfn -
> +                      (highest_addr >> PAGE_SHIFT));

Since both end_pfn (from arch/x86_64/kernel/e820.c) and highest_addr
are unsigned long, maybe the problem is just that %ld in the kprintf
format string? Shouldn't that be %lu?

Mauro
