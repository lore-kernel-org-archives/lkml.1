Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbZAPGRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbZAPGRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbZAPGRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:17:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:57251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZAPGRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MlrULZIo3INZbFQ/7+6PIZSiH13c3co6F+cr94fzPokKvBXIgrR6AjkwKnRuy2hSm9
         ui9Ce1+LVSpJCsvI0WplwNmonufZHA4/qo1Tu0JIELuI/2rFO6d+k83bJJ00lxREo4KA
         sTY6J7hCdmRGssmDdZuyK3SJJThlOQuup/xko=
Date: Fri, 16 Jan 2009 15:16:57 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove needless flush_dcache_page call
Message-ID: <20090116061657.GC6515@barrios-desktop>
References: <20090116052804.GA18737@barrios-desktop> <20090116053338.GC31013@parisc-linux.org> <20090116055119.GA6515@barrios-desktop> <20090116055729.GF31013@parisc-linux.org> <20090116060830.GB6515@barrios-desktop> <20090116061341.GB22810@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116061341.GB22810@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 07:13:41AM +0100, Nick Piggin wrote:
> On Fri, Jan 16, 2009 at 03:08:30PM +0900, MinChan Kim wrote:
> > On Thu, Jan 15, 2009 at 10:57:30PM -0700, Matthew Wilcox wrote:
> > > Most I/O devices will do DMA to the page in question and thus the kernel
> > > hasn't written to it and the CPU won't have the data in cache.  For the
> > > few devices which can't do DMA, it's the responsibility of the device
> > > driver to call flush_dcache_page() (or some other flushing primitive).
> > 
> > Hmm.. Now I am confusing. 
> > If devicer driver or with DMA makes sure cache consistency,
> > Why filesystem code have to handle it ?
> 
> Because the filesystem is accessing the page directly rathe rthan going to
> IO.
> 
> Basically, whoever reads or writes the page is responsible to avoid user
> aliases. You see these calls in the VM for anonymous pages, in bounce
> buffer layers, in filesystems that read or write from pages that are
> exposed to userspace (ie. metadata generally need not be flushed because
> it will not be mmapped by userspace).

Totally, understand.
Thanks for kind answering to my poor question in patience.
