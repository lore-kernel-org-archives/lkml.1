Return-Path: <linux-kernel-owner+w=401wt.eu-S933986AbXCTEeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbXCTEeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 00:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933981AbXCTEeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 00:34:31 -0400
Received: from ozlabs.org ([203.10.76.45]:57933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933986AbXCTEea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 00:34:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17919.20743.384741.398444@cargo.ozlabs.ibm.com>
Date: Tue, 20 Mar 2007 14:12:07 +1100
From: Paul Mackerras <paulus@samba.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
In-Reply-To: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter writes:

> +static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
> +{

...

> +	p = (void *)__get_free_page(flags | __GFP_ZERO);

This will cause problems on 64-bit powerpc, at least with 4k pages,
since the pmd and pgd levels only use 1/4 of a page.

Paul.
