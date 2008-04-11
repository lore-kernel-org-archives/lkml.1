Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYDKOrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYDKOrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYDKOrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:47:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604AbYDKOrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:47:31 -0400
Date: Fri, 11 Apr 2008 07:46:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] Fix compile breakage caused by asmlinkage_protect
In-Reply-To: <20080411114654.GA12270@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org> <20080410223738.80A8326F992@magilla.localdomain> <20080411114654.GA12270@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Apr 2008, Heiko Carstens wrote:
> 
> git commit 54a015104136974262afa4b8ddd943ea70dec8a2
> "asmlinkage_protect replaces prevent_tail_call" causes this build failure
> on s390:
> 
>   AS      arch/s390/kernel/entry64.o
> In file included from arch/s390/kernel/entry64.S:14:
> include/linux/linkage.h:34: error: syntax error in macro parameter list
> make[1]: *** [arch/s390/kernel/entry64.o] Error 1
> make: *** [arch/s390/kernel] Error 2

Ok, that's just _odd_.

> So just surround the new define with an #ifndef __ASSEMBLY__ to prevent
> any side effects on asm code.

There are no side effects on asm code. It just adds a #define that 
obviously won't be used.

Is the s390 assembler using some strange C pre-processor that is different 
from the main C preprocessor and doesn't understand this pattern?

I really think you should fix *that*, because otherwise you'll hit these 
kinds of bugs occasionally. There aren't that many asm files, it's not 
worth it optimizing them to use some faster-but-stupider preprocessor.

			Linus
