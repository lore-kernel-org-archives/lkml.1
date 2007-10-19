Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbXJSRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbXJSRmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbXJSRmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:42:06 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50223 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773AbXJSRmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:42:05 -0400
Date: Fri, 19 Oct 2007 13:38:38 -0400
Message-Id: <200710191738.l9JHccYx011061@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, dwmw2@infradead.org, jffs-dev@axis.com,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: BUG at mm/filemap.c:1749 (2.6.24, jffs2, unionfs) 
In-reply-to: Your message of "Fri, 19 Oct 2007 17:16:53 +1000."
             <200710191716.53470.nickpiggin@yahoo.com.au> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200710191716.53470.nickpiggin@yahoo.com.au>, Nick Piggin writes:
[...]
> Hmm, looks like jffs2_write_end is writing more than we actually ask it
> to, and returns that back.
> 
>         unsigned aligned_start = start & ~3;
> 
> and
> 
>         if (end == PAGE_CACHE_SIZE) {
>                 /* When writing out the end of a page, write out the
>                    _whole_ page. This helps to reduce the number of
>                    nodes in files which have many short writes, like
>                    syslog files. */
>                 start = aligned_start = 0;
>         }
> 
> These "longer" writes are fine, but they shouldn't get propagated back
> to the vm/vfs. Something like the following patch might fix it.
> 
> 
> --Boundary-00=_lnFGHwOggSRGKPd
> Content-Type: text/x-diff;
>   charset="utf-8";
>   name="jffs2-writtenlen-fix.patch"
> Content-Transfer-Encoding: 7bit
> Content-Disposition: attachment;
> 	filename="jffs2-writtenlen-fix.patch"

Nick, the patch worked.  All of my unionfs-over-jffs2 tests passed.

Thanks,
Erez.
