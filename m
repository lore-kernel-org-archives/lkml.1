Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYJWNvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYJWNvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbYJWNva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:51:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45911 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbYJWNv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:51:29 -0400
Subject: Re: [Devel] Re: [PATCH 06/10] Introduce functions to dump mm
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: devel@openvz.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810231243.42181.major@openvz.org>
References: <1224285098-573-1-git-send-email-major@openvz.org>
	 <1224285098-573-7-git-send-email-major@openvz.org>
	 <1224523278.1848.123.camel@nimitz>  <200810231243.42181.major@openvz.org>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 06:51:20 -0700
Message-Id: <1224769880.12673.15.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 12:43 +0400, Andrey Mirkin wrote:
> > > +#ifdef CONFIG_X86
> > > +       if (pmd_huge(*pmd)) {
> > > +               eprintk("page_huge\n");
> > > +               goto out_unsupported;
> > > +       }
> > > +#endif
> >
> > I take it you know that this breaks with the 1GB (x86_64) and 16GB (ppc)
> > large pages.
> >
> > Since you have the VMA, why not use is_vm_hugetlb_page()?
> Right now I'm checking VM_HUGETLB flag on VMAs in dump_one_vma().
> This checks were added for sanity purpose just to throw out all unsupported 
> right now cases.

I'm telling you that it's no good.  Not only should this path never be
hit.  But, if it is, you'll crash anyway in some cases.

It's a bad check.  At best it misleads the reader to think that you've
covered your bases.

-- Dave

