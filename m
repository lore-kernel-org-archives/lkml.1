Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbXFKQfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbXFKQfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXFKQfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:35:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54082 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXFKQfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:35:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NnFMA2XNw3hvZcrAayuLvTC7qK+BnwIflfTgEZmI3PL0dgUKpBZPmMJPuU3C06gqaOCZYFldlDBvqwpWfNSIrfa/95XG8A24lUcMd45FpsPwM/I03zJqonE9JX2AgY8c/H1D6ToiQTKLB4h0cR2KPBoeqwrKurs/SyZkmxeXtzw=
Date: Mon, 11 Jun 2007 20:41:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Bernd Schubert <bernd-schubert@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: API changes / 2.6.21 sysctl changes
Message-ID: <20070611164132.GB5715@martell.zuzino.mipt.ru>
References: <200706111513.12998.bernd-schubert@gmx.de> <20070611154627.GA5715@martell.zuzino.mipt.ru> <200706111759.45774.bernd-schubert@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706111759.45774.bernd-schubert@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 05:59:45PM +0200, Bernd Schubert wrote:
> On Monday 11 June 2007 17:46:27 Alexey Dobriyan wrote:
> > On Mon, Jun 11, 2007 at 03:13:12PM +0200, Bernd Schubert wrote:
> > > in 2.6.21 register_sysctl_table(), struct ctl_table and probably
> > > something else did change. Unfortunately so far I didn't figure out the
> > > "something else".
> >
> > Do you have a problem porting your sysctls to newer kernels?
>
> A little bit, yes. Well, I got it working, but I don't understand why I had to
> do that whay.
>
> I'm porting lustre to newer kernel versions and up to 2.6.20 the procfs/sysctl
> logic was
>
> 1.) register_sysctl_table() -> creates /proc/sys/lnet
>
> 2.) create_proc_entry()  -> add additional files in /proc/sys/lnet

Glue all your ctl_table's in tree and register it with one call. See how
XFS does this: fs/xfs/linux-2.6/xfs_sysctl.c

> With 2.6.21 creating additional entries in /proc/sys/lnet fails and I have to
> first call "proc_mkdir("sys/lnet", NULL)". I did this proc_mkdir() call even
> before the register_sysctl_table() call, hoping that its correct.
>
> My guess is that register_sysctl_table() doesn't create /proc/sys/lnet
> anymore, but I have now idea why. Either I did something wrong or its
> intended.

