Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYJCO6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYJCO6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYJCO6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:58:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbYJCO6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:58:40 -0400
Date: Fri, 3 Oct 2008 16:57:54 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for glibc PRNG seeding
Message-ID: <20081003145754.GH32682@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com> <20081003052938.GS10632@outflux.net> <20081002225718.6a0d803a@infradead.org> <48E5BAC6.9070007@redhat.com> <20081003145054.GU10632@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003145054.GU10632@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 07:50:54AM -0700, Kees Cook wrote:
> @@ -152,6 +160,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  	elf_addr_t __user *sp;
>  	elf_addr_t __user *u_platform;
>  	elf_addr_t __user *u_base_platform;
> +	elf_addr_t __user *u_rand_bytes;
> +	unsigned int rand_size;
>  	const char *k_platform = ELF_PLATFORM;
>  	const char *k_base_platform = ELF_BASE_PLATFORM;
>  	int items;

Why are you introducing the rand_size variable at all?  The only thing it
can cause is confuse somebody to change it, which might do bad things as
k_rand_bytes var uses ELF_AUXV_RANDOM_SIZE directly.  Just use
ELF_AUXV_RANDOM_SIZE in all places you use rand_size ATM (except the
assignment and declaration of course).

	Jakub
