Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253Ab0AENqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0AENqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179Ab0AENqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:46:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50261 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0AENqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:46:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: strict copy_from_user checks issues?
Date: Tue, 5 Jan 2010 14:45:25 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <20100105094857.GB5480@osiris.boeblingen.de.ibm.com> <20100105053443.4a43fc18@infradead.org>
In-Reply-To: <20100105053443.4a43fc18@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001051445.26149.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+udSP2y8bhj7Sqvn8IygLKxTp3ovvg1FGVEGr
 45WJkIahwwN36kM9bo8CZGG4z0Mtn2S2LM5RkxU1Of8KbsoHE9
 FisJm8MjDB5dx//YuntmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Arjan van de Ven wrote:
> > In file included
> > from /home2/heicarst/cfu/arch/s390/include/asm/mmu_context.h:13,
> > from /home2/heicarst/cfu/arch/s390/include/asm/elf.h:133, from
> > include/linux/elf.h:7, from include/linux/module.h:14, from
> > drivers/net/tun.c:42: In function 'copy_from_user',
> >     inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1124:
> > /home2/heicarst/cfu/arch/s390/include/asm/uaccess.h:299: warning:
> > call to 'copy_from_user_overflow' declared with attribute warning:
> > copy_from_user() buffer size is not provably correct
> 
> this one is ... interesting btw... I have trouble myself finding where
> the check is done... so I can understand gcc having trouble too.
> 

I think it will get inlined on 32 bit machines or without CONFIG_COMPAT,
but not when CONFIG_COMPAT is enabled, because then there are two
call-sites.

The tun_chr_compat_ioctl was only merged in 2.6.33-rc1, so 2.6.32 could
still inline the function all the time.

If the compiler is really smart (haven't tried), it can optimize away
tun_chr_compat_ioctl entirely on i386 and make it an alias to
tun_chr_ioctl, but not on s390 because that uses a nontrivial compat_ptr()
function.

	Arnd
