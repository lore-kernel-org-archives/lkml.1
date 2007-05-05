Return-Path: <linux-kernel-owner+w=401wt.eu-S1423972AbXEEDeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423972AbXEEDeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 23:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423974AbXEEDeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 23:34:44 -0400
Received: from nef2.ens.fr ([129.199.96.40]:4809 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423972AbXEEDen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 23:34:43 -0400
Date: Fri, 4 May 2007 23:34:08 -0400
From: Quentin Godfroy <godfroy@clipper.ens.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Quentin Godfroy <godfroy@clipper.ens.fr>, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: patch: VFS: fix passing of AT_PHDR value in auxv to ELF interpreter
Message-ID: <20070505033408.GB30453@goelette.ens.fr>
References: <20070504140921.GA23122@goelette.ens.fr> <20070504162208.6f4b38b0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504162208.6f4b38b0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Sat, 05 May 2007 05:34:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 04:22:08PM -0700, Andrew Morton wrote:
> This patch kills my FC6 machine (using a config which was derived from RH's
> original):
> 
> Freeing unused kernel memory: 368k freed
> Write protecting the kernel read-only data: 959k
> request_module: runaway loop modprobe binfmt-464c
> request_module: runaway loop modprobe binfmt-464c
> request_module: runaway loop modprobe binfmt-464c
> request_module: runaway loop modprobe binfmt-464c
> request_module: runaway loop modprobe binfmt-464c
> 
> 
> .config: http://userweb.kernel.org/~akpm/config-akpm2.txt

I didn't try it on a 64bit kernel. I'll do as soon as I can reach my
machine. Probably the loop does not find PT_PHDR and then returns noexec.

I had such a problem, but it was because I forgot elf_ppnt = elf_phdata
before the loop.

By the way, is init 32 bits or 64 bits? It could break the ia32
emulation thing, but not the 64bit native mode.

Anyway the problem could be addressed by returning back to the old
behaviour if the loop fails, but it's not clean at all.
