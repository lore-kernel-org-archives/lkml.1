Return-Path: <linux-kernel-owner+w=401wt.eu-S936007AbYD1R2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936007AbYD1R2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933196AbYD1R1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:27:39 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:56764 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbYD1R1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:27:37 -0400
Date: Mon, 28 Apr 2008 13:26:36 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [git pull] generic bitops, take 2
Message-ID: <20080428172636.GF7334@c2.user-mode-linux.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426172222.GD17345@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 07:22:22PM +0200, Ingo Molnar wrote:
> > It also makes me wonder why Kconfig.i386 can just include 
> > arch/x86/Kconfig.cpu, but x86_64 cannot?
> 
> hm, indeed arch/um/Kconfig.i386 is assymetric to Kconfig.x86_64. Jeff 
> Cc:-ed.

In current git, they look pretty symmetric to me, and it boots and runs.

>  arch/um/os-Linux/helper.c: In function 'run_helper':
>  arch/um/os-Linux/helper.c:73: error: 'PATH_MAX' undeclared (first use in this function)
> 
> it needs the patch below.

Applied, thanks.

> then it fails with:
> 
>  mm/filemap.c: In function '__generic_file_aio_write_nolock':
>  mm/filemap.c:1831: sorry, unimplemented: inlining failed in call to
> 'generic_write_checks': function body not available

Looks like Adrian just hit that too.  As Linus pointed out,
__generic_file_aio_write_nolock calls generic_write_checks at line
2383, and that's available at line 1831, which the error message
helpfully points out.  I don't see how gcc can be claiming that the
function body isn't available when it's telling you exactly where it
is.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
