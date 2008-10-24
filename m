Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbYJXEHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbYJXEHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYJXEHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:07:38 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27292 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbYJXEHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:07:37 -0400
From: Andrey Mirkin <major@openvz.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [Devel] Re: [PATCH 06/10] Introduce functions to dump mm
Date: Fri, 24 Oct 2008 08:07:01 +0400
User-Agent: KMail/1.8.2
Cc: devel@openvz.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1224285098-573-1-git-send-email-major@openvz.org> <200810231243.42181.major@openvz.org> <1224769880.12673.15.camel@nimitz>
In-Reply-To: <1224769880.12673.15.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240807.02820.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 17:51 Dave Hansen wrote:
> On Thu, 2008-10-23 at 12:43 +0400, Andrey Mirkin wrote:
> > > > +#ifdef CONFIG_X86
> > > > +       if (pmd_huge(*pmd)) {
> > > > +               eprintk("page_huge\n");
> > > > +               goto out_unsupported;
> > > > +       }
> > > > +#endif
> > >
> > > I take it you know that this breaks with the 1GB (x86_64) and 16GB
> > > (ppc) large pages.
> > >
> > > Since you have the VMA, why not use is_vm_hugetlb_page()?
> >
> > Right now I'm checking VM_HUGETLB flag on VMAs in dump_one_vma().
> > This checks were added for sanity purpose just to throw out all
> > unsupported right now cases.
>
> I'm telling you that it's no good.  Not only should this path never be
> hit.  But, if it is, you'll crash anyway in some cases.
>
> It's a bad check.  At best it misleads the reader to think that you've
> covered your bases.

Agree, I will rework this.

Andrey
