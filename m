Return-Path: <linux-kernel-owner+w=401wt.eu-S1031731AbXEEDY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031731AbXEEDY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 23:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031729AbXEEDYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 23:24:55 -0400
Received: from nef2.ens.fr ([129.199.96.40]:2112 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031725AbXEEDYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 23:24:54 -0400
Date: Fri, 4 May 2007 23:23:48 -0400
From: Quentin Godfroy <godfroy@clipper.ens.fr>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Quentin Godfroy <godfroy@clipper.ens.fr>, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: patch: VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
Message-ID: <20070505032348.GA30453@goelette.ens.fr>
References: <20070504140921.GA23122@goelette.ens.fr> <463BC265.7050507@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463BC265.7050507@goop.org>
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Sat, 05 May 2007 05:24:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 04:31:49PM -0700, Jeremy Fitzhardinge wrote:
> Quentin Godfroy wrote:
> > +	elf_ppnt = elf_phdata;
> > +	for (i = 0; i< loc->elf_ex.e_phnum; i++, elf_ppnt++)
> > +		if (elf_ppnt->p_type == PT_PHDR) {
> > +			phdr_addr = elf_ppnt->p_vaddr;
> >   
> 
> Won't this break with ET_DYN executables?  And besides, isn't this the
> same thing?                                                           

Indeed, I haven't seen that. For ET_DYN executables, it could be done a
thing like load_addr+elf_ppnt->p_vaddr (in the function that creates the
auxv, as ity has access to the elf header), and for ET_EXEC do what I
propose. I think this is trivial to do. I'll do it as soon as I come back
in front of my machine.


>              Shouldn't PT_PHDR->p_vaddr point to the vaddr of the Phdr
> table itself?

I don't understand. Yes it is what it is supposed to be, and the kernel
is supposed to give the vaddr of the phdr table to the interpreter and
not load addr + offset of phdr in file, which is sometimes wrong.
