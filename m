Return-Path: <linux-kernel-owner+w=401wt.eu-S1763141AbXKJChp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763141AbXKJChp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 21:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXKJChi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 21:37:38 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43971 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXKJChh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 21:37:37 -0500
Date: Fri, 9 Nov 2007 21:36:36 -0500
Message-Id: <200711100236.lAA2aaV2017025@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: ezk@cs.sunysb.edu, akpm@osdl.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH 1/2] create file_drop_write_access() helper 
In-reply-to: Your message of "Fri, 09 Nov 2007 13:04:39 PST."
             <20071109210439.122065A3@kernel> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20071109210439.122065A3@kernel>, Dave Hansen writes:
> 
> These should fix the bug that Erez Zadok <ezk@cs.sunysb.edu>
> reported:
> 
> Stopping RPC idmapd:
> 
> kernel: __fput() of writeable file with no mnt_want_write()
> kernel: WARNING: at fs/file_table.c:262 __fput()
> kernel:  [<c010283e>] show_trace_log_lvl+0x12/0x25
> kernel:  [<c0103042>] show_trace+0xd/0x10
> ...
> 
> The actual bug was a missed mnt_want_write() when a
> filp was allocated with get_empty_filp() and then
> made writable.  Using alloc_file(), instead, fixes
> that.
[...]

I can confirm that this patch fixes the bug I reported earlier today.

Thanks,
Erez.
