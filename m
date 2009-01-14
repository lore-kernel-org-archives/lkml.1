Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbZANPT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbZANPT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZANPTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:19:51 -0500
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:33311 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756002AbZANPTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:19:50 -0500
Date: Wed, 14 Jan 2009 16:19:39 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Bodo Eggert <7eggert@gmx.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ftp.linux.org.uk>,
       Alain Knaff <alain@knaff.lu>
Subject: Re: The policy on initramfs decompression failure
In-Reply-To: <20090114054556.GB11153@elte.hu>
Message-ID: <alpine.LSU.0.999.0901141527400.4854@be1.lrz>
References: <bU0fj-7Ap-43@gated-at.bofh.it> <E1LMstm-0001QW-7i@be1.7eggert.dyndns.org>
 <20090114054556.GB11153@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Ingo Molnar wrote:
> * Bodo Eggert <7eggert@gmx.de> wrote:

> > If the initrd is not decompressed successfully, [...]
> 
> No, that's not the issue - i think hpa's description was misleading in 
> that respect.
> 
> This is not some sort of corruption. I have hit this pointless panic 
> during testing: there was nothing wrong with either the initrd or the 
> system, the bzImage simply did not include the right decompressor .config 
> option to even read the initrd.

A unknown-compressed initrd is as good or as bad as a corrupted rd.
The kernel can't decide if it's got /dev/random or e.g. a RAR archive.
Therefore it must and should behave the same.

> The analogue is if i booted a kernel with CONFIG_MODULES disabled. I do it 
> all the time, it always worked without problems and the initrd with 
> modules in it cannot be interpreted in any sane way CONFIG_MODULES - still 
> it works just fine because the initrd is uninteresting as far as the 
> modules go.

> So basically now the kernel has regressed in its bzImage utility: "oh, i 
> dont have a decompressor for the initrd. PANIC!". And that is a step 
> backwards. Unless you use bzImage i dont think you can really appreciate 
> this argument.

If there is no initrd, you won't get a panic. If you use a gzip initrd
with a bz2-only kernel what do you expect? What do you expect if you
say "root=/dev/internal-disk", but /dev/usb/attacker's-USB-stick is
currently the only working alternative?

I think having a kernel parameter ist the right thing, since it
won't decrease security, it gives everything you want and it allows
you to skip even "good" initrds if they turn out not to be good.

> I would not mind a warning message though, that bit makes sense.

"Warning, I'm starting a setup which you didn't intend to start
 at all! Muahahahaha, good luck!"
-- 
Interchangeable parts aren't.
