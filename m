Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbXGBKXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbXGBKXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 06:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXGBKXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 06:23:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:54682 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbXGBKXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 06:23:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=WBvbM+9QAjqqyF7gstdUvcdCtQJuZhidffzVaMTGgPitGZuVG/yO5xaLlUbCG+oCzaKFqI07H5Vl8tv4DLe4QoLMAGYft4/uA55xBhCa37n4Sg/IJ3LqbNxSvyAvyAIJCqHsQADajtKaqlsoshb4VTAZU/nFgsdeFAlD28MWKHg=
Date: Mon, 2 Jul 2007 13:23:03 +0300
To: Andreas Schwab <schwab@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [i386] Questions regarding provisional page tables initialization
Message-ID: <20070702102303.GA17533@Ahmed>
References: <20070701203833.GA3498@Ahmed> <46882872.7040005@goop.org> <20070702011332.GA3503@Ahmed> <je8x9zrwof.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <je8x9zrwof.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Mon, Jul 02, 2007 at 11:18:08AM +0200, Andreas Schwab wrote:
> "Ahmed S. Darwish" <darwish.07@gmail.com> writes:
> 
> > yes, but isn't the displacement here (0x007) a _bytes_ displacement ?. so
> > effectively, %ecx now contains physical address of pg0 + 7bytes. Is it A 
> > meaningful place/address ?.
> 
> It's not pg0 + 7bytes, it is pg0 plus 3 flag bits.  Since a page address
> is always page aligned, the low bits are reused for flags.
> 

I'm sure there's a problem in _my_ understanding, but isn't the displacement
- as specified by AT&T syntax - represented in bytes ?. I've wrote a small
assembly function to be sure:

.data
integer:
	.string "%d\n"

.text
test_func:
	push	%ebp
	mov	%esp, %ebp
	push	0x008(%ebp)   ## 8 bytes displacement (the first arg), right ?
	push	$integer
	call 	printf
	mov	%ebp, %esp
	pop	%ebp
	ret

The above method works fine and prints "5" to stdout by the code:

.global	main
main:
	mov	$5, %eax
	push	%eax
	call	test_func

	movl	$1, %eax
	movl	$0, %ebx
	int	$0x80

now back to head.S code:
 	leal    0x007(%edi),%ecx	/* Create PDE entry */

Isn't the above line the same condition (bytes, not bits displacement) ?. 
Thanks for your patience !.

(For other kind replies, don't understand me wrong. I did my homework and
 studied the pte format before asking ;). It's just the bytes/bits issue 
 above that confuses me).

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
