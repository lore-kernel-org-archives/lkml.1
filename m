Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbZCJUHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbZCJUHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZCJUHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:07:33 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:26820 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654AbZCJUHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=KUo49PlnZBjhhvKTF8lk55w1GRFXvHadzhewMLJuzWxvM4w173hrCcYqZoDckUbncy
         geZaLi3yAsxdIqYcm+RtlDGMS/37X5tiqa+0CZHVqo7uk5X8zNg+wwUSLYLaONlgpIr+
         8rXJp0+nF6A+UncHtB6spLs6cKujvUByseXaw=
MIME-Version: 1.0
Date: Tue, 10 Mar 2009 21:07:25 +0100
X-Google-Sender-Auth: 62f1492cf07fd00e
Message-ID: <10f740e80903101307v70000e0cm61e261050411a715@mail.gmail.com>
Subject: Re: linux-next: Tree for March 10 (m68k/tlbflush.h)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

http://kisskb.ellerman.id.au/kisskb/buildresult/180587/
| arch/m68k/kernel/traps.c:274: error: implicit declaration of
function '__flush_tlb040_one'

http://kisskb.ellerman.id.au/kisskb/buildresult/180591/
| mm/vmalloc.c:555: error: implicit declaration of function
'flush_tlb_kernel_range'

Caused by:

| commit 7fa69761ea82752b97502383f7f2d3fdfa509115
| Author: Greg Ungerer <gerg@uclinux.org>
| Date:   Tue Feb 17 14:40:47 2009 +1000
|
|     m68k: merge the mmu and non-mmu versions of tlbflush.h
|
|     Simple merge of the mmu and non-mmu versions of tlbflush.h
|
|     Signed-off-by: Greg Ungerer <gerg@uclinux.org>

Seems like you merged the wrong way:

| diff --git a/arch/m68k/include/asm/tlbflush.h
b/arch/m68k/include/asm/tlbflush.h
| index b6f93b3..79050d0 100644
| --- a/arch/m68k/include/asm/tlbflush.h
| +++ b/arch/m68k/include/asm/tlbflush.h
| @@ -1,5 +1,267 @@
| -#ifdef __uClinux__
| -#include "tlbflush_no.h"
| +#ifndef _M68K_TLBFLUSH_H
| +#define _M68K_TLBFLUSH_H
| +
| +#ifndef CONFIG_MMU
    ^^^^^
    ifdef

| +#ifndef CONFIG_SUN3

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
