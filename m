Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZI2MqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZI2MqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZI2MqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:46:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:55929 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbZI2MqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:46:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy
Date: Tue, 29 Sep 2009 14:44:06 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com,
       torvalds@linux-foundation.org
References: <20090928113433.5e9b8ea7@infradead.org>
In-Reply-To: <20090928113433.5e9b8ea7@infradead.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291444.06422.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Xz/hMmZ14xaf+gmV4WUAVfAbSLl8dK6N/HBN
 ZfzloNCrW66SwGfN8jCNmq6VBvDHZgmZAcsSrGTY/vOqsiKZYP
 ydxWlMlyZKHp6urf6ESug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 September 2009, Arjan van de Ven wrote:
> 
> GCC provides reasonable memset/memcpy functions itself, with __builtin_memset
> and __builtin_memcpy. For the "unknown" cases, it'll fall back to our
> current existing functions, but for fixed size versions it'll inline
> something smart. Quite often that will be the same as we have now,
> but sometimes it can do something smarter (for example, if the code
> then sets the first member of a struct, it can do a shorter memset).
> 
> In addition, and this is more important, gcc knows which registers and
> such are not clobbered (while for our asm version it pretty much
> acts like a compiler barrier), so for various cases it can avoid reloading
> values.
> 
> The effect on codesize is shown below on my typical laptop .config:
> 
>    text	   data	    bss	    dec	    hex	filename
> 5605675	2041100	6525148	14171923	 d83f13	vmlinux.before
> 5595849	2041668	6525148	14162665	 d81ae9	vmlinux.after
> 

The patch looks good, but is there a reason to keep it architecture
specific? I would guess that the same logic applies to all architectures
with gcc-4.x and could be put into include/linux/compiler-gcc4.h.

	Arnd <><
