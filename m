Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbZDBGk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbZDBGk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZDBGku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:40:50 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:38669 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZDBGks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=d83MqDHJ7et2P5bqOxONaLDHt3q2oOxp+pJ7voDNEb0+ZAcSZysC5rP1GGVYBnZcPX
         FuTJPcdm6NohKcNDwA24SE/24sjaMIixsExRCtTIrUN6M2OTHluIG0tIGV8i4uzmVe1Y
         I93kfLopFtnoXOcwk6WfPhqjkPe8IU7zWZiqo=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.29 git master and PAT problems
Date: Thu, 2 Apr 2009 08:40:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200904011223.50050.a.miskiewicz@gmail.com> <20090401230401.GD10490@linux-os.sc.intel.com>
In-Reply-To: <20090401230401.GD10490@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904020840.42847.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 of April 2009, Pallipadi, Venkatesh wrote:
> On Wed, Apr 01, 2009 at 03:23:49AM -0700, Arkadiusz Miskiewicz wrote:
> > On Wednesday 01 of April 2009, Pallipadi, Venkatesh wrote:
> > > On Tue, Mar 31, 2009 at 12:44:32AM -0700, Arkadiusz Miskiewicz wrote:
> > > > On Tuesday 31 of March 2009, Pallipadi, Venkatesh wrote:
> > > > > On Mon, Mar 30, 2009 at 04:25:11PM -0700, Arkadiusz Miskiewicz 
wrote:
> > > > > > On Tuesday 31 of March 2009, Arkadiusz Miskiewicz wrote:
> > > > > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > > > > > >
> > > > > > > More info follows. Now I've switched to
> > > > > > > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest
> > > > > > > drm fixes and now I get much lower numbers of PAT errors but
> > > > > > > still.
> > > > > >
> > > > > > Also when I switch t400 into discrete mode (radeon hd 3400
> > > > > > instead of integrated intel GM45) I get such errors (probably
> > > > > > unrelated to these seen when using intel):
> > > > > >
> > > > > > [  419.187657] X:10550 conflicting memory types cfff0000-d0000000
> > > > > > uncached<->uncached-minus [  419.187670] reserve_memtype failed
> > > > > > 0xcfff0000-0xd0000000, track uncached, req write-back [ 
> > > > > > 419.553914] X:10550 conflicting memory types cfff0000-d0000000
> > > > > > uncached<->uncached-minus [  419.553923] reserve_memtype failed
> > > > > > 0xcfff0000-0xd0000000, track uncached, req write-back [ 
> > > > > > 419.813592] X:10550 conflicting memory types cfff0000-d0000000
> > > > > > uncached<->uncached-minus [  419.813601] reserve_memtype failed
> > > > > > 0xcfff0000-0xd0000000, track uncached, req write-back [ 
> > > > > > 420.100102] X:10550 conflicting memory types cfff0000-d0000000
> > > > > > uncached<->uncached-minus [  420.100111] reserve_memtype failed
> > > > > > 0xcfff0000-0xd0000000, track uncached, req write-back
> > > > >
> > > > > Yes. This is a different problem than the freeing invalid type one.
> > > > > Are these errors also with latest git kernel? Can you try the patch
> > > > > below (which is a part of a bigger cleanup patch I have lined up).
> > > >
> > > > It's a latest git kernel as of today morning
> > > > (latest commit is 15f7176eb1cccec0a332541285ee752b935c1c85)
> > > > + your patch. Problem persists:
> > > >
> > > > [   74.696353] [drm] Setting GART location based on new memory map
> > > > [   74.711520] [drm] Loading RV620 CP Microcode
> > > > [   74.711792] [drm] Loading RV620 PFP Microcode
> > > > [   74.726719] [drm] Resetting GPU
> > > > [   74.726776] [drm] writeback test succeeded in 1 usecs
> > > > [   75.256034] X:5366 conflicting memory types d0000000-e0000000
> > > > uncached-minus<->write-combining [   75.256043] reserve_memtype
> > > > failed 0xd0000000-0xe0000000, track uncached-minus, req write-back [
> > > > 75.849951] X:5366 conflicting memory types d0000000-e0000000
> > > > uncached-minus<->write-combining [   75.849960] reserve_memtype
> > > > failed 0xd0000000-0xe0000000, track uncached-minus, req write-back [
> > > > 76.054374] X:5366 conflicting memory types d0000000-e0000000
> > > > uncached-minus<->write-combining [   76.054377] reserve_memtype
> > > > failed 0xd0000000-0xe0000000, track uncached-minus, req write-back [
> > > > 76.074481] X:5378 freeing invalid memtype d0000000-e0000000
> > > > [   76.176881] X:5366 conflicting memory types d0000000-e0000000
> > > > uncached-minus<->write-combining [   76.176885] reserve_memtype
> > > > failed 0xd0000000-0xe0000000, track uncached-minus, req write-back [
> > > > 76.207734] X:5380 freeing invalid memtype d0000000-e0000000
> > >
> > > OK. We now have a theory on what is going wrong here.
> > >
> > > The problem seems to be pci mmap uses vm_page_prot flag to remember the
> > > memtype for this region. Looks like that memtype is somehow getting
> > > cleared in this case. We still don't know where it is getting cleared.
> > > But, with debug patch below we can be sure that it is indeed getting
> > > cleared, which is causing problems on fork() as child wont know the
> > > memtype that parent got.
> > >
> > > Can you please try the below debug patch over upstream git and check
> > > whether you indeed hit the warnon.
> >
> > warns triggered:
>
> OK. Below patch should resolve this problem.



The issue is gone with this patch. Thanks!




>
> Thanks,
> Venki
>
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: [PATCH] x86, PAT: Remove duplicate memtype reserve in pci mmap
>
> pci mmap code was doing memtype reserve for a while now. Recently we
> added memtype tracking in remap_pfn_range, and pci code indirectly calls
> remap_pfn_range. So, we don't need seperate tracking in pci code
> anymore. Which means a patch that removes ~50 lines of code :-).
>
> Also, recently we found out that the pci tracking is not working as we
> expect it to work in some cases. Specifically, userlevel X mmap of pci,
> with some recent version of X, is having a problem with vm_page_prot
> getting reset. The pci tracking uses vm_page_prot to pass on the protection
> type from parent to child during fork.
> a) Parent does a pci mmap
> b) We look at PAT and get either UC_MINUS or WC mapping for parent
> c) Store that mapping type in vma vm_page_prot for future use
> d) This thread does a fork
> e) Fork results in mmap_ops ->open for the child process
> f) We get the vm_page_prot from vma and reserve that type for the child
> process
>
> But, between c) and e) above, the vma vm_page_prot is getting reset to
> zero. This results in PAT reserve failing at the time of fork as in here.
> http://marc.info/?l=linux-kernel&m=123858163103240&w=2
>
> This cleanup makes the above problem go away as we do not depend on
> vm_page_prot in our PAT code anymore.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  arch/x86/pci/i386.c |   46 ----------------------------------------------
>  1 file changed, 46 deletions(-)
>
> Index: linux-2.6/arch/x86/pci/i386.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/i386.c	2009-04-01 10:29:49.000000000 -0700
> +++ linux-2.6/arch/x86/pci/i386.c	2009-04-01 10:33:18.000000000 -0700
> @@ -258,24 +258,7 @@ void pcibios_set_master(struct pci_dev *
>  	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
>  }
>
> -static void pci_unmap_page_range(struct vm_area_struct *vma)
> -{
> -	u64 addr = (u64)vma->vm_pgoff << PAGE_SHIFT;
> -	free_memtype(addr, addr + vma->vm_end - vma->vm_start);
> -}
> -
> -static void pci_track_mmap_page_range(struct vm_area_struct *vma)
> -{
> -	u64 addr = (u64)vma->vm_pgoff << PAGE_SHIFT;
> -	unsigned long flags = pgprot_val(vma->vm_page_prot)
> -						& _PAGE_CACHE_MASK;
> -
> -	reserve_memtype(addr, addr + vma->vm_end - vma->vm_start, flags, NULL);
> -}
> -
>  static struct vm_operations_struct pci_mmap_ops = {
> -	.open  = pci_track_mmap_page_range,
> -	.close = pci_unmap_page_range,
>  	.access = generic_access_phys,
>  };
>
> @@ -283,11 +266,6 @@ int pci_mmap_page_range(struct pci_dev *
>  			enum pci_mmap_state mmap_state, int write_combine)
>  {
>  	unsigned long prot;
> -	u64 addr = vma->vm_pgoff << PAGE_SHIFT;
> -	unsigned long len = vma->vm_end - vma->vm_start;
> -	unsigned long flags;
> -	unsigned long new_flags;
> -	int retval;
>
>  	/* I/O space cannot be accessed via normal processor loads and
>  	 * stores on this platform.
> @@ -308,30 +286,6 @@ int pci_mmap_page_range(struct pci_dev *
>
>  	vma->vm_page_prot = __pgprot(prot);
>
> -	flags = pgprot_val(vma->vm_page_prot) & _PAGE_CACHE_MASK;
> -	retval = reserve_memtype(addr, addr + len, flags, &new_flags);
> -	if (retval)
> -		return retval;
> -
> -	if (flags != new_flags) {
> -		if (!is_new_memtype_allowed(flags, new_flags)) {
> -			free_memtype(addr, addr+len);
> -			return -EINVAL;
> -		}
> -		flags = new_flags;
> -		vma->vm_page_prot = __pgprot(
> -			(pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK) |
> -			flags);
> -	}
> -
> -	if (((vma->vm_pgoff < max_low_pfn_mapped) ||
> -	     (vma->vm_pgoff >= (1UL<<(32 - PAGE_SHIFT)) &&
> -	      vma->vm_pgoff < max_pfn_mapped)) &&
> -	    ioremap_change_attr((unsigned long)__va(addr), len, flags)) {
> -		free_memtype(addr, addr + len);
> -		return -EINVAL;
> -	}
> -
>  	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>  			       vma->vm_end - vma->vm_start,
>  			       vma->vm_page_prot))


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

