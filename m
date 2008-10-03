Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYJCF0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYJCF0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYJCF0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:26:34 -0400
Received: from mylar.outflux.net ([69.93.193.226]:46624 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbYJCF0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:26:34 -0400
Date: Thu, 2 Oct 2008 22:25:39 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081003052539.GR10632@outflux.net>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 02:43:40AM +0200, Jakub Jelinek wrote:
> On Thu, Oct 02, 2008 at 05:16:16PM -0700, Kees Cook wrote:
> > @@ -196,6 +198,18 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
> >  			return -EFAULT;
> >  	}
> >  
> > +	rand_size = CONFIG_SECURITY_AUXV_RANDOM_SIZE * sizeof(unsigned long);
> 
> I believe you want sizeof (elf_addr_t) here instead.
> 
> > +	u_rand_bytes = NULL;
> > +	if (rand_size) {
> > +		unsigned char k_rand_bytes[CONFIG_SECURITY_AUXV_RANDOM_SIZE *
> > +					   sizeof(unsigned long)];
> 
> And here too, because having a 64-bit kernel supply twice as much random
> data to 32-bit programs as a 32-bit kernel would supply would be certainly
> unexpected.

Ah-ha!  I see the 32-vs-64 elf_addr_t magic in fs/compat_binfmt_elf.c now.
Excellent, I will send an updated patch.

Thanks!

-Kees

-- 
Kees Cook
Ubuntu Security Team
