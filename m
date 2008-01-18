Return-Path: <linux-kernel-owner+w=401wt.eu-S1765495AbYARS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765495AbYARS5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762445AbYARS5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:57:23 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58705 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761813AbYARS5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:57:22 -0500
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, peterz@infradead.org, salikhmetov@gmail.com,
       linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, akpm@linux-foundation.org,
       protasnb@gmail.com, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-reply-to: <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org>
	(message from Linus Torvalds on Fri, 18 Jan 2008 10:43:35 -0800 (PST))
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
References: <12006091182260-git-send-email-salikhmetov@gmail.com>  <12006091211208-git-send-email-salikhmetov@gmail.com>  <E1JFnsg-0008UU-LU@pomaz-ex.szeredi.hu>  <1200651337.5920.9.camel@twins> <1200651958.5920.12.camel@twins>
 <alpine.LFD.1.00.0801180949040.2957@woody.linux-foundation.org> <E1JFvgx-0000zz-2C@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801181033580.2957@woody.linux-foundation.org>
Message-Id: <E1JFwOz-00019k-Uo@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Jan 2008 19:57:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That would need a new page flag (PG_mmap_dirty?).  Do we have one
> > available?
> 
> Yeah, that would be bad. We probably have flags free, but those page flags 
> are always a pain. Scratch that.
> 
> How about just setting a per-vma dirty flag, and then instead of updating 
> the mtime when taking the dirty-page fault, we just set that flag?
> 
> Then, on unmap and msync, we just do
> 
> 	if (vma->dirty-flag) {
> 		vma->dirty_flag = 0;
> 		update_file_times(vma->vm_file);
> 	}
> 
> and be done with it? 

But then background writeout, sync(2), etc, wouldn't update the times.
Dunno.  I don't think actual _physical_ writeout matters much, so it's
not worse to be 30s early with the timestamp, than to be 30s or more
late.

Miklos
