Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbXFZHys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbXFZHys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 03:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFZHyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 03:54:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:58451 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbXFZHyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 03:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kZX3ld5nIZGyB3VG94qrnMqX2n++nJJYzeh5mMxRMSeYnqcXj3Jso9CFqXzd3DwiYdScED7or4GP8XXjtNCN8PBu7+N2Q9+Zv3xMiWBuChVEElikhAffZnghNk065isL/buqO3rTpScrCmCun6nWDb6FsX23/t3D19GDkMtkaqY=
Message-ID: <863e9df20706260054p664635beme3081da113844c2@mail.gmail.com>
Date: Tue, 26 Jun 2007 13:24:36 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: michael@ellerman.id.au
Subject: Re: [PATCH 3/3] Make jprobes a little safer for users
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-ia64@vger.kernel.org, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>, "Christoph Hellwig" <hch@lst.de>,
       anil.s.keshavamurthy@intel.com, ananth@in.ibm.com
In-Reply-To: <1182839683.6673.22.camel@concordia.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <78935473b1f70c863ab0be7d6cf4bcb04922b20b.1182822366.git.michael@ellerman.id.au>
	 <7a070581b2fe53ea65216e86c86abc4f40464341.1182822366.git.michael@ellerman.id.au>
	 <863e9df20706252319j239eaf44wee7a46ad742c9585@mail.gmail.com>
	 <1182839683.6673.22.camel@concordia.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Michael Ellerman <michael@ellerman.id.au> wrote:
> It did occur to me that someone might be doing something crazy like
> branching to code that's not in the kernel/module text - but I was
> hoping that wouldn't be the case. I'm not sure what ITCM is?

The reference to tightly coupled memory (ITCM) was just to have you
consider the possibility of the jprobe handler being outside kernel
text region. Totally paranoid really.

> > >  int __kprobes register_jprobe(struct jprobe *jp)
> > >  {
> > > +       unsigned long addr = arch_deref_entry_point(jp->entry);
> > > +
> > > +       if (!kernel_text_address(addr))
> > > +               return -EINVAL;
> >
> > Seems like you're checking for the jprobe handler to be within
> > kernel/module range. Why not narrow this down to just module range
> > (!module_text_address(addr), say)? Core kernel functions would not be
> > ending with a 'jprobe_return()' anyway.
>
> There's jprobe code in net/ipv4/tcp_probe.c and net/dccp/probe.c that
> can be builtin or modular, so I think kernel_text_address() is right.

Ok..thanks for that clarification.

--
Abhishek Sagar

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
