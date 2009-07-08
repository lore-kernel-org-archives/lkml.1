Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbZGHT2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbZGHT2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbZGHT21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:28:27 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:53680 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbZGHT20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SBqr9oL5dMv6uYlwNuxSUTo7vC/jR53seC6EbyEVG2NNAthSKWFWNugUpsJ8CAjG+B
         rdHqo5ZLh8DxAfh038RwpVAlEfaOCDE2L1VLQLh8sYg8MQ9g9CJScz2AWwqSaMtbHXoz
         LD0eHio7ZFX76L2542zsoyDGK7M+pbAiu+M1c=
MIME-Version: 1.0
In-Reply-To: <1246873983.20908.0.camel@johannes.local>
References: <1246873983.20908.0.camel@johannes.local>
Date: Wed, 8 Jul 2009 21:28:24 +0200
Message-ID: <19f34abd0907081228p541d1cdao85f37aaa479fcfc5@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: fix sparse warning
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-sparse@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n68JSbXx027343

2009/7/6 Johannes Berg <johannes@sipsolutions.net>:> Whether or not the sparse warning>> warning: do-while statement is not a compound statement>> is justified or not in this case, it is annoying and> trivial to fix.>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>> --->  include/linux/kmemcheck.h |    4 ++-->  1 file changed, 2 insertions(+), 2 deletions(-)>> --- wireless-testing.orig/include/linux/kmemcheck.h     2009-07-06 11:41:16.000000000 +0200> +++ wireless-testing/include/linux/kmemcheck.h  2009-07-06 11:41:30.000000000 +0200> @@ -137,13 +137,13 @@ static inline void kmemcheck_mark_initia>        int name##_end[0];>>  #define kmemcheck_annotate_bitfield(ptr, name)                         \> -       do if (ptr) {                                                   \> +       do { if (ptr) {                                                 \>                int _n = (long) &((ptr)->name##_end)                    \>                        - (long) &((ptr)->name##_begin);                \>                BUILD_BUG_ON(_n < 0);                                   \>                                                                        \>                kmemcheck_mark_initialized(&((ptr)->name##_begin), _n); \> -       } while (0)> +       } } while (0)>>  #define kmemcheck_annotate_variable(var)                               \>        do {                                                            \>>>
I'll change the patch title to "kmemcheck: work around bogus sparsewarning" and fix the indentation, sounds ok?
Meanwhile, I Cced sparse mailing list in case somebody else knowsanything else about this warning (what it means, whether it'sjustified in this case, whether it should be fixed in sparse, etc.).
Thanks.

Vegard���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
