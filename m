Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZKWXZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZKWXZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZKWXZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:25:16 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:16597 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982AbZKWXZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:25:15 -0500
Date: Mon, 23 Nov 2009 16:25:20 -0700
From: Alex Chiang <achiang@hp.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tony Luck <tony.luck@gmail.com>,
       James.Bottomley@suse.de, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] modpost: fix modules on ia64 - use @fptr() on exported
	function symbols
Message-ID: <20091123232520.GA18976@ldl.fc.hp.com>
References: <4B0B10FA.7030402@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0B10FA.7030402@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> On function descriptor architectures (powerpc and ia64), we need to export
> the address of the function descriptor and not the actual function.
> The C compiler naturally does this for us.  However we now export vmlinux
> symbols using the assembler, in order to sort the exports.
>
> This is not a problem on powerpc.  On powerpc, the function descriptor
> is simply "printk" (the action function entry point is ".printk").
> But ia64 assembly needs special handling.  The function descriptor for
> printk(), for example, is "@fptr(printk)".
>
> I have tested that modpost now generates the desired assembly code when
> run against an IA64 module.  I have not tested with an actual IA64
> vmlinux, assembler, compiler or processor.  I assume that the IA64
> assembler defines __ia64__, just as the i386 assembler defines __i386__.
>
> Reported-by: Alex Chiang <achiang@hp.com>

I applied this patch to a tree that had 20ba8ef1de7e77e4c
(kbuild: sort the list of symbols exported by the kernel
(__ksymtab)) as a HEAD.

Without the patch, I get a panic. With the patch, boot succeeds.

I also applied this patch on top of 9d5bf6fad2 (Add linux-next
specific files for 20091123), and verified that boot also
succeeds.

So for ia64, you can add my:

Tested-by: Alex Chiang <achiang@hp.com>

However, I've cc'ed James Bottomley who is currently testing
parisc. parsic is another function descriptor architecture, and
due to your very specific #ifdef __ia64__ in the patch, it
clearly won't fix parisc (if indeed it is broken).

James mentioned something about needing an fptr arch symbol, but
I'll let him expand on his idea.

Thanks,
/ac
