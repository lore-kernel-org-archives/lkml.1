Return-Path: <linux-kernel-owner+w=401wt.eu-S1161560AbXEDXbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161560AbXEDXbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbXEDXbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:31:48 -0400
Received: from gw.goop.org ([64.81.55.164]:57536 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbXEDXbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:31:47 -0400
Message-ID: <463BC265.7050507@goop.org>
Date: Fri, 04 May 2007 16:31:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Quentin Godfroy <godfroy@clipper.ens.fr>
CC: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: patch: VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
References: <20070504140921.GA23122@goelette.ens.fr>
In-Reply-To: <20070504140921.GA23122@goelette.ens.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quentin Godfroy wrote:
> +	elf_ppnt = elf_phdata;
> +	for (i = 0; i< loc->elf_ex.e_phnum; i++, elf_ppnt++)
> +		if (elf_ppnt->p_type == PT_PHDR) {
> +			phdr_addr = elf_ppnt->p_vaddr;
>   

Won't this break with ET_DYN executables?  And besides, isn't this the
same thing?  Shouldn't PT_PHDR->p_vaddr point to the vaddr of the Phdr
table itself?

    J
