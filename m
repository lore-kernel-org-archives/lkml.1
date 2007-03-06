Return-Path: <linux-kernel-owner+w=401wt.eu-S933838AbXCFByP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838AbXCFByP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933840AbXCFByO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:54:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46253 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933838AbXCFByN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:54:13 -0500
Date: Mon, 5 Mar 2007 17:54:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Robert Peterson <rpeterso@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc1] Extend print_symbol capability TRY #2
Message-Id: <20070305175402.1803cbd3.akpm@linux-foundation.org>
In-Reply-To: <20070305173756.4b52e3d4.randy.dunlap@oracle.com>
References: <45ECAFEF.3030607@redhat.com>
	<20070305173756.4b52e3d4.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007 17:37:56 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 05 Mar 2007 18:03:59 -0600 Robert Peterson wrote:
> 
> > This is try #2 for this patch, with corrections based on feedback. 
> > It is the same as the previous patch except:
> > (1) The function has been renamed from lookup_symbol to sprint_symbol
> >     as requested by Paulo Marques.
> > (2) I fixed the "return NULL;" to "return;" as pointed out by Paulo Marques
> >     for the case where the kallsyms function is not selected in .config
> > (3) I changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL as
> >     requested by Roman Zippel. (Andrew, I thought you said you changed this,
> >     but I didn't see it in mm1).
> > 
> > I hope this patch attaches with proper spacing and without word wrap.
> > If it doesn't, my apologies (I'm using Thunderbird, but suggestions 
> > welcome).
> > 
> > Original comment:
> > 
> > Today's print_symbol function dumps a kernel symbol with printk.
> > This patch extends the functionality of kallsyms.c so that the symbol
> > lookup function may be used without the printk.  This is
> > useful for modules that want to dump symbols elsewhere, for
> > example, to debugfs.  I intend to use the new function call in the
> > GFS2 file system (which will be a separate patch).
> > 
> > Signed-off-by: Robert Peterson <rpeterso@redhat.com>
> > ---
> 
> argh, attachment, harder to review/comment on....
> 
> I had commented on this comment, but you seem to have missed it.
> 
> +/* Replace "%s" in format with address, or returns -errno. */
> +void __print_symbol(const char *fmt, unsigned long address)
> +{
> 
> This function does not "returns -errno" at all.

I think the arguments to sprint_symbol() are backwards.  Would prefer

	sprint_symbol(char *buffer, unsigned long addr)

like all the other print-into-a-buffer functions.
