Return-Path: <linux-kernel-owner+w=401wt.eu-S965565AbXCLNZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbXCLNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965566AbXCLNZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:25:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49222 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565AbXCLNZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:25:55 -0400
Date: Mon, 12 Mar 2007 14:25:53 +0100
From: Jan Kara <jack@suse.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
Subject: Re: [PATCH 1/7] revoke: special mmap handling
Message-ID: <20070312132553.GG30777@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0703091012530.32320@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703091012530.32320@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> This adds special handling for revoked memory mappings.  We want to
> raise SIGBUS when accessing revoked mappings and return ENODEV when
> trying to remap with mmap(2).
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  include/linux/mm.h |    2 ++
>  mm/memory.c        |    3 +++
>  mm/mmap.c          |   12 ++++++++----
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> Index: uml-2.6/include/linux/mm.h
> ===================================================================
> --- uml-2.6.orig/include/linux/mm.h	2007-03-08 10:24:24.000000000 +0200
> +++ uml-2.6/include/linux/mm.h	2007-03-08 10:24:25.000000000 +0200
> @@ -170,6 +170,8 @@
>  #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
>  #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
>  
> +#define VM_REVOKED	0x04000000	/* Mapping has been revoked */
> +
  Is it intended to conflict with VM_ALWAYSDUMP? I'd guess not and if
yes, it definitely deserves a comment...

										Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
