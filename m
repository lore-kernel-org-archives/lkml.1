Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbXFFIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbXFFIpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXFFIpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 04:45:22 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:36165 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXFFIpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 04:45:20 -0400
Date: Wed, 6 Jun 2007 17:44:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, Ollie Wild <aaw@google.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 4/4] mm: variable length argument support
Message-ID: <20070606084407.GA9975@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
	linux-mm@kvack.org, linux-arch@vger.kernel.org,
	Ollie Wild <aaw@google.com>, Ingo Molnar <mingo@elte.hu>,
	Andi Kleen <ak@suse.de>
References: <20070605150523.786600000@chello.nl> <20070605151203.790585000@chello.nl> <20070606013658.20bcbe2f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606013658.20bcbe2f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 01:36:58AM -0700, Andrew Morton wrote:
> On Tue, 05 Jun 2007 17:05:27 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > From: Ollie Wild <aaw@google.com>
> > 
> > Remove the arg+env limit of MAX_ARG_PAGES by copying the strings directly
> > from the old mm into the new mm.
> > 
> > We create the new mm before the binfmt code runs, and place the new stack
> > at the very top of the address space. Once the binfmt code runs and figures
> > out where the stack should be, we move it downwards.
> > 
> > It is a bit peculiar in that we have one task with two mm's, one of which is
> > inactive.
> > 
> > ...
> >
> > +				flush_cache_page(bprm->vma, kpos,
> > +						 page_to_pfn(kmapped_page));
> 
> Breaks SuperH:
> 
> fs/exec.c: In function `bprm_mm_init':
> fs/exec.c:268: warning: unused variable `vma'
> fs/exec.c: In function `copy_strings':
> fs/exec.c:431: error: structure has no member named `vma'
> 
More pointedly, bprm->vma doesn't exist if CONFIG_MMU=n, which Andrew's
config seems to have ;-)
