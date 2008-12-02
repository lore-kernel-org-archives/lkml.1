Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbYLBRpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbYLBRpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYLBRpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:45:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57214 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbYLBRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:45:40 -0500
Date: Tue, 2 Dec 2008 17:44:57 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line()
Message-ID: <20081202174457.GA26005@flint.arm.linux.org.uk>
References: <200812012326.03151.rusty@rustcorp.com.au> <20081201131807.GD28971@flint.arm.linux.org.uk> <200812021243.38862.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812021243.38862.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 12:43:37PM +1030, Rusty Russell wrote:
> A couple of #if 0 around code I don't think can happen (even in the orignal
> place I moved it from?)

Looking at just those...

> @@ -697,32 +693,48 @@ void __init setup_arch(char **cmdline_p)
>  	 */
>  	if (tags->hdr.tag != ATAG_CORE)
>  		convert_to_tag_list(tags);
> +#if 0
>  	if (tags->hdr.tag != ATAG_CORE)
>  		tags = (struct tag *)&init_tags;
> +#endif

This prevents 'init_tags' from ever being used, which wil happen if
convert_to_tag_list() doesn't find a param_struct to convert.

> +
> +	if (mdesc->fixup)
> +		mdesc->fixup(mdesc, tags, &meminfo);
> +
> +#if 0
> +	if (tags->hdr.tag == ATAG_CORE) {
> +#endif

This may happen if the memory pointed to by 'tags' gets overwritten for
some reason by a machine specific fixup, but that'll probably never
happen.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
