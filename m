Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYJCAo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYJCAo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYJCAoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:44:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbYJCAoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:44:17 -0400
Date: Fri, 3 Oct 2008 02:43:40 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>, libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
Message-ID: <20081003004340.GF32682@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20081001201116.GD12527@outflux.net> <48E3EFD6.2010704@redhat.com> <20081001215657.GH12527@outflux.net> <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003001616.GN10632@outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 05:16:16PM -0700, Kees Cook wrote:
> @@ -196,6 +198,18 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  			return -EFAULT;
>  	}
>  
> +	rand_size = CONFIG_SECURITY_AUXV_RANDOM_SIZE * sizeof(unsigned long);

I believe you want sizeof (elf_addr_t) here instead.

> +	u_rand_bytes = NULL;
> +	if (rand_size) {
> +		unsigned char k_rand_bytes[CONFIG_SECURITY_AUXV_RANDOM_SIZE *
> +					   sizeof(unsigned long)];

And here too, because having a 64-bit kernel supply twice as much random
data to 32-bit programs as a 32-bit kernel would supply would be certainly
unexpected.

	Jakub
