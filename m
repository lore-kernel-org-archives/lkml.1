Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbYACNHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbYACNHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYACNGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:06:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYACNG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:06:29 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [20/20] x86: Print which shared library/executable faulted in segfault etc. messages
Date: Thu, 3 Jan 2008 14:06:21 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20080103149.088038000@suse.de> <20080103005016.4DA4C14D40@wotan.suse.de> <20080103110034.GG29194@elte.hu>
In-Reply-To: <20080103110034.GG29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031406.21272.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > And printing the offset into a mapping also always allows to find the 
> > correct fault point in a library even with randomized mappings. Previously
> > there was no way to actually find the correct code address inside
> > the randomized mapping.
> > 
> > Relies on earlier patch to shorten the printk formats.
> > 
> > They are often now longer than 80 characters, but I think that's worth 
> > it.
> 
> why not make it multi-line? that way the %lx hack wouldnt be needed 
> either.

I prefer it single-line. I also disagree on %lx being a hack.

> 
> > +void print_vma_addr(char *prefix, unsigned long ip)
> > +{
> > +	struct mm_struct *mm = current->mm;
> > +	struct vm_area_struct *vma;
> > +	down_read(&mm->mmap_sem);
> > +	vma = find_vma(mm, ip);
> 
> grumble. Proper CodingStyle please.


Looks fine to me. If you mean the new line after variables -- that was always optional.

Anyways I'll repost with the error check.

Also it seems like you did apply only parts of the patchkit. If you do that can
you send a list of what patches you didn't add, otherwise it'll be messy to figure
this out from here.

-Andi
