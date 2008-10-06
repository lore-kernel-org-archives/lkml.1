Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbYJFF0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbYJFF0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 01:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYJFF0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 01:26:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:45169 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYJFF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 01:26:12 -0400
Date: Sun, 5 Oct 2008 22:26:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081005222600.11121739@infradead.org>
In-Reply-To: <20081006052337.GE2186@elte.hu>
References: <20081005180154.7cc12486@infradead.org>
	<20081006052337.GE2186@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008 07:23:37 +0200
Ingo Molnar <mingo@elte.hu> wrote:
> 
> > +int iomem_is_reserved(u64 addr)
> > +{
> > +     struct resource *p = &iomem_resource;

...

> > +              */
> > +             if (p->start >= addr + size)
> > +                     continue;
> 
> do we want to skip all resources that are not IORESOURCE_MEM? Same
> holds for iomem_map_sanity_check(), introduced in tip/core/resources:

if we have non-IORESOURCE_MEM resources in the iomem_resource tree....
then we have bigger problems.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
