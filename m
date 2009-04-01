Return-Path: <linux-kernel-owner+w=401wt.eu-S1765368AbZDAAPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765368AbZDAAPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZDAAOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:14:39 -0400
Received: from outbound-mail-145.bluehost.com ([67.222.38.35]:37761 "HELO
	outbound-mail-145.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764768AbZDAAOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:14:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=httxRjkVGLAAfhZhfcUQYDhZasRW56qmLJw/LOjCNu6iRjBSfr90gTJKlqyVpsICD6ggSVyNESCECHjOYoNYAvSIQqON5Iiu7c0C1YFyrrj5aF42bP9roTYBQy2vPxCl;
Date: Tue, 31 Mar 2009 17:14:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: PAGE_CACHE_WC strikes again
Message-ID: <20090331171431.69ad044f@hobbes>
In-Reply-To: <1238544647.8369.682.camel@gaiman.anholt.net>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 17:10:47 -0700
Eric Anholt <eric@anholt.net> wrote:

> I just tracked down what was cutting performance 10x on one of my
> systems on a microbenchmark I'd just written:
> 
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -540,7 +540,7 @@ int drm_gem_mmap(struct file *filp, struct
> vm_area_struct *vma)
>  	/* FIXME: use pgprot_writecombine when available */
>  	prot = pgprot_val(vma->vm_page_prot);
>  #ifdef CONFIG_X86
> -	prot |= _PAGE_CACHE_WC;
> +	/*prot |= _PAGE_CACHE_WC;*/
>  #endif
>  	vma->vm_page_prot = __pgprot(prot);
>  
> Turns out that setting PAGE_CACHE_WC disables the WC effect of the
> MTRR on my non-PAT (disabled due to CPU errata) 945GM system, and this
> workaround took GTT-mapped writes from 120MB/s to 1180MB/s.

What the...  There's a pgprot_writecombine now, but it basically does
the same thing.  Why is WC so broken?  Venki is the fix for this
covered in your last patchset?

-- 
Jesse Barnes, Intel Open Source Technology Center
