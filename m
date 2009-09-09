Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZIIDPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZIIDPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZIIDPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:15:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZIIDPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:15:07 -0400
Date: Tue, 8 Sep 2009 20:08:43 -0700
From: Greg KH <gregkh@suse.de>
To: Jayson King <dev@jaysonking.com>
Cc: LKML <linux-kernel@vger.kernel.org>, sunil.mushran@oracle.com,
       joel.becker@oracle.com
Subject: Re: [patch 00/48] 2.6.27.32-stable review
Message-ID: <20090909030843.GC10608@suse.de>
References: <4AA66E97.4050500@jaysonking.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AA66E97.4050500@jaysonking.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 09:47:51AM -0500, Jayson King wrote:
> Greetings,
> 
> Patch 41/48 (ocfs2: Initialize the...) of this series causes a build 
> failure:
> 
> fs/ocfs2/aops.c: In function ‘ocfs2_write_cluster’:
> fs/ocfs2/aops.c:1286: error: ‘should_zero’ undeclared (first use in this 
> function)
> fs/ocfs2/aops.c:1286: error: (Each undeclared identifier is reported 
> only once
> fs/ocfs2/aops.c:1286: error: for each function it appears in.)
> fs/ocfs2/aops.c: In function ‘ocfs2_write_cluster_by_desc’:
> fs/ocfs2/aops.c:1360: warning: passing argument 4 of 
> ‘ocfs2_write_cluster’ makes pointer from integer without a cast
> fs/ocfs2/aops.c:1360: warning: passing argument 6 of 
> ‘ocfs2_write_cluster’ from incompatible pointer type
> fs/ocfs2/aops.c:1360: warning: passing argument 7 of 
> ‘ocfs2_write_cluster’ makes integer from pointer without a cast
> fs/ocfs2/aops.c:1360: error: too many arguments to function 
> ‘ocfs2_write_cluster’
> 
> 
> A line from the upstream patch is missing in this patch:
> 
>   static int ocfs2_write_cluster(struct address_space *mapping,
>                      u32 phys, unsigned int unwritten,
> +                   unsigned int should_zero,
>                      struct ocfs2_alloc_context *data_ac,
>                      struct ocfs2_alloc_context *meta_ac,
>                      struct ocfs2_write_ctxt *wc, u32 cpos,
>                      loff_t user_pos, unsigned user_len)
> 
> 
> Attached is the corrected patch with the above line placed back in.

There was an add-on ocfs2 patch that should have now resolved this
issue.  If you still have this problem with the released kernel, please
let me know.

thanks,

greg k-h
