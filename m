Return-Path: <linux-kernel-owner+w=401wt.eu-S376292AbXECSov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S376292AbXECSov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S376295AbXECSov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:44:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61426 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S376292AbXECSos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Z83hjyGzIy7ddbRON0oCsUGN62dXIeHKjXSyJnri0S/brSsOCaQZspjcR+PD7w0NwPRIEH3NRRPs8KpRarlUmcHBKSzC/QpJu70sDmJeYsm1Ga4oT+z1u0v62yCftBPO1fU/6B5riso5SIlGKp0NmM6nhub7gh4+l415WmdyDnw=
Date: Thu, 3 May 2007 22:44:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utrace: remove exports
Message-ID: <20070503184450.GA5836@martell.zuzino.mipt.ru>
References: <20070418180113.GA18485@lst.de> <20070430040232.EB3DD1801A4@magilla.sf.frob.com> <20070430091244.GA949@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430091244.GA949@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:12:44AM +0100, Christoph Hellwig wrote:
> On Sun, Apr 29, 2007 at 09:02:32PM -0700, Roland McGrath wrote:
> > > EXPORT_SYMBOL_GPL(utrace_attach);
> > > 
> > > 	There is not modular user of this, so this and the other utrace_
> > > 	functions should not be exported.  Nor do I think that exporting
> > > 	such a low-level process control is nessecary a good idea, but
> > > 	we'll have to evaluate that if patches to add users show up.
> > 
> > If you remove the exports, just throw the whole thing away.
> > The reason utrace exists is to be used by modules.
> 
> used != used by modules.  Even without things exported you can use
> things in the kernel.  Once we have a valid modular use case we can
> add exports.

Christoph, it's at
http://people.redhat.com/roland/utrace/crash-suspend.c

The file crash-suspend.c is a simple example of a loadable kernel module
using the new infrastructure.  It implements the old GNU feature of doing a
job suspend on crash, so you can attach a debugger right then instead of
just looking at the core file afterwards.  Try for example:
	$ sudo /sbin/insmod crash-suspend.ko pid=$$
to load the module and attach it to your shell.  It then attaches to any
children of your shell.  Now run something that crashes and would
ordinarily dump core--you can just run cat or sleep and hit ^\ to crash it
with a SIGQUIT.  See it suspend.  Try "jobs -l" and see it stopped with a
non-stop signal.  If you resume it with "fg" it will go ahead and dump
core.  Or, you can attach a debugger like gdb first, and then debug it.



Most certainly, it should be included into utrace patchset to pin some
exports.

