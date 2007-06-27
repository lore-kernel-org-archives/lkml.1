Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXF0PFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXF0PFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbXF0PFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:05:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:56517 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbXF0PFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:05:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,467,1175497200"; 
   d="scan'208";a="100659891"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Mauro Giachero" <mauro.giachero@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 27 Jun 2007 08:04:52 -0700
User-Agent: KMail/1.9.7
Cc: "Pim Zandbergen" <P.Zandbergen@macroscoop.nl>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Andi Kleen" <andi@firstfloor.org>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <46823F71.6060200@macroscoop.nl> <da3e877f0706270722x67bb0738x4274b4367e04f0c6@mail.gmail.com>
In-Reply-To: <da3e877f0706270722x67bb0738x4274b4367e04f0c6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706270804.53263.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 27, 2007 7:22:24 Mauro Giachero wrote:
> On 6/27/07, Pim Zandbergen <P.Zandbergen@macroscoop.nl> wrote:
> > Now:
> > Jesse released a new patch and I tried if for fun on 2.6.22-rc6
> > It looks like the patch is releasing memory rather than trimming
> > it:
> >
> > [...]
> > Jun 27 12:22:56 corneille kernel: **** MTRRs don't cover all of
> > memory, trimmed -65536 pages
> > [...]
>
> From Jesse's patch:
> > +       unsigned long i, base, size, highest_addr = 0, def, dummy;
> > [...]
> > +               printk(KERN_WARNING "**** MTRRs don't cover all of
> > " +                      "memory, trimmed %ld pages\n", end_pfn - +
> >                      (highest_addr >> PAGE_SHIFT));
>
> Since both end_pfn (from arch/x86_64/kernel/e820.c) and highest_addr
> are unsigned long, maybe the problem is just that %ld in the kprintf
> format string? Shouldn't that be %lu?

Yeah, you're right I should use an unsigned format string.  Pim, if you 
change it to %lu does the printk in your dmesg look better?

Thanks,
Jesse
