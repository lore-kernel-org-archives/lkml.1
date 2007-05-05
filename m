Return-Path: <linux-kernel-owner+w=401wt.eu-S1767986AbXEEEYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767986AbXEEEYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 00:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767984AbXEEEYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 00:24:05 -0400
Received: from gw.goop.org ([64.81.55.164]:48111 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767981AbXEEEYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 00:24:04 -0400
Message-ID: <463C06E5.8050201@goop.org>
Date: Fri, 04 May 2007 21:24:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Quentin Godfroy <godfroy@clipper.ens.fr>
CC: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: patch: VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
References: <20070504140921.GA23122@goelette.ens.fr> <463BC265.7050507@goop.org> <20070505032348.GA30453@goelette.ens.fr>
In-Reply-To: <20070505032348.GA30453@goelette.ens.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quentin Godfroy wrote:
>> Won't this break with ET_DYN executables?  And besides, isn't this the
>> same thing?                                                           
>>     
>
> Indeed, I haven't seen that. For ET_DYN executables, it could be done a
> thing like load_addr+elf_ppnt->p_vaddr (in the function that creates the
> auxv, as ity has access to the elf header), and for ET_EXEC do what I
> propose. I think this is trivial to do. I'll do it as soon as I come back
> in front of my machine.
>   

I don't think you need to special-case it.  You can compute the offset
between the linked address and the load address (first
PT_LOAD[0]->p_vaddr - load_addr) and use that to offset all the other
addresses.


> I don't understand. Yes it is what it is supposed to be, and the kernel
> is supposed to give the vaddr of the phdr table to the interpreter and
> not load addr + offset of phdr in file, which is sometimes wrong.
>   

How can it be wrong?  Does the PT_PHDR point to a different array of
Phdr entries?

    J
