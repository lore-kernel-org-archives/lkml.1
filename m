Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYIQT2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYIQT2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYIQT2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:28:30 -0400
Received: from 8bytes.org ([88.198.83.132]:60115 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYIQT23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:28:29 -0400
Date: Wed, 17 Sep 2008 21:28:27 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
Message-ID: <20080917192827.GA18515@8bytes.org>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com> <1221670377-19295-4-git-send-email-joerg.roedel@amd.com> <20080918041104K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918041104K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 04:20:18AM +0900, FUJITA Tomonori wrote:
> On Wed, 17 Sep 2008 18:52:37 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > The IO/TLB flushing on every unmaping operation is the most expensive
> > part there and not strictly necessary. It is sufficient to do the flush
> > before any entries are reused. This is patch implements lazy IO/TLB
> > flushing which does exactly this.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  Documentation/kernel-parameters.txt |    5 +++++
> >  arch/x86/kernel/amd_iommu.c         |   26 ++++++++++++++++++++++----
> >  arch/x86/kernel/amd_iommu_init.c    |   10 +++++++++-
> >  include/asm-x86/amd_iommu_types.h   |    9 +++++++++
> >  4 files changed, 45 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index c2e00ee..5f0aefe 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
> >  			isolate - enable device isolation (each device, as far
> >  			          as possible, will get its own protection
> >  			          domain)
> > +			unmap_flush - enable flushing of IO/TLB entries when
> > +			              they are unmapped. Otherwise they are
> > +				      flushed before they will be reused, which
> > +				      is a lot of faster
> > +
> 
> Would it be nice to have consistency of IOMMU parameters?

True. We should merge common parameters across IOMMUs into the
iommu= parameter some time in the future, I think. It would also be the
place for the IOMMU size parameter.

> VT-d also has the kernel-boot option for this lazy flushing trick
> though VT-d 'strict' option is more vague than 'unmap_flush'
> 
> It would be also nice to have consistency of IOMMU behavior.
> 
> VT-d enables the lazy flushing trick by default and has the boot
> option to disable it.

This is exactly what AMD IOMMU with this patch does too. The
amd_iommu=unmap_flush parameter disables lazy IO/TLB flushing.


Joerg
