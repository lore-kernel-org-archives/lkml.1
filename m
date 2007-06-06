Return-Path: <linux-kernel-owner+w=401wt.eu-S1761454AbXFFJrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761454AbXFFJrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXFFJrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:47:06 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:58209 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757499AbXFFJrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:47:05 -0400
Subject: Re: [PATCH 4/4] mm: variable length argument support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, Ollie Wild <aaw@google.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070606094401.GA10393@linux-sh.org>
References: <20070605150523.786600000@chello.nl>
	 <20070605151203.790585000@chello.nl>
	 <20070606013658.20bcbe2f.akpm@linux-foundation.org>
	 <1181120061.7348.177.camel@twins>
	 <20070606020651.19a89dca.akpm@linux-foundation.org>
	 <1181122473.7348.188.camel@twins>  <20070606094401.GA10393@linux-sh.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 11:47:00 +0200
Message-Id: <1181123220.7348.193.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 18:44 +0900, Paul Mundt wrote:
> On Wed, Jun 06, 2007 at 11:34:33AM +0200, Peter Zijlstra wrote:
> > +static void flush_arg_page(struct linux_binprm *bprm, unsigned long pos,
> > +		struct page *page)
> > +{
> > +	flush_cache_page(bprm->vma, pos, page_to_pfn(page));
> > +}
> > +
> [snip]
> 
> > @@ -253,6 +305,17 @@ static void free_arg_pages(struct linux_
> >  		free_arg_page(bprm, i);
> >  }
> >  
> > +static void flush_arg_page(struct linux_binprm *bprm, unsigned long pos,
> > +		struct page *page)
> > +{
> > +}
> > +
> inline?

could do I guess, but doesn't this modern gcc thing auto inline statics
that are so small?

