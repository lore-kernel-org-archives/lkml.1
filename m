Return-Path: <linux-kernel-owner+w=401wt.eu-S1765278AbYBBWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765278AbYBBWcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbYBBWcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:32:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:4237 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762617AbYBBWcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O4aIqJ2UTSLCqA1B5tYCJIc+h/4VF1dFhN4rKwfWACE7y/KPTyJPXF2CVoLWdhQQ1GLDg5s0UHx1LW8Ak7KFUrde8EbDSzabTq4VpKkPvoTLkMOeqPWPOCDrLxxcqiiZ7lNKdDMeQtEcBq/n/G81IihNYYx449dpX4RTbafAIcc=
Message-ID: <aa79d98a0802021432t794eb9e2p14011ec53ab63725@mail.gmail.com>
Date: Sun, 3 Feb 2008 01:32:31 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] x86: setup code_bytes - use mask to restrict it's size
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <47A4EDC5.3050104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080202221211.GA6749@cvg> <47A4EDC5.3050104@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for review. Agreed with you absolutely. Silly patch, sorry :(

On 2/3/08, H. Peter Anvin <hpa@zytor.com> wrote:
> Cyrill Gorcunov wrote:
> > This patch strips off 8 bytes from text section. Not a really
> > big advantage (especially for __init section). It seems 8192
> > bytes of disassembled code is rare used anyway.
> >
> > before:
> > 	text    data     bss     dec     hex filename
> > 	9900     176      20   10096    2770 arch/x86/kernel/traps_64.o.old
> > after:
> > 	text    data     bss     dec     hex filename
> > 	9892     176      20   10088    2768 arch/x86/kernel/traps_64.o
> >
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > ---
> >
> > If there is no benefit at all - just drop the patch.
> > Any comments are welcome ;)
>
> I don't think this is the behaviour we want (wrapping around); worse, if
> people enter a larger power of two they will get zero.
>
> So NAK on this patch, IMO.
>
> 	-hpa
>
