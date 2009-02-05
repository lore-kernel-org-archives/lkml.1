Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbZBESrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbZBESrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZBESrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:47:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZBESrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:47:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Make exported headers use strict posix types
Date: Thu, 5 Feb 2009 19:45:03 +0100
User-Agent: KMail/1.9.9
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, x86@kernel.org,
       sam@ravnborg.org, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, mchehab@infradead.org,
       jens.axboe@oracle.com, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
References: <20090204064307.GA18415@gondor.apana.org.au> <498B0315.5080804@zytor.com> <200902051707.55457.arnd@arndb.de>
In-Reply-To: <200902051707.55457.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200902051945.05466.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19NK4R0EFc0kym4gA++Irffy4fdIVH8YG8AzYT
 Cq5bcGD2JOmr1MnoA/hzJKtECzA5yc9lFzoh3o6TsFsmC0c0JY
 f0+/PSOJJS4PkiCBtZF8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n15IlPwM008029

On Thursday 05 February 2009, Arnd Bergmann wrote:> @@ -9,6 +9,7 @@> Â #endif> Â #include <linux/ptrace.h>> Â > +#error this doesn't compile> Â struct elf_siginfo> Â {> Â Â Â Â Â Â Â Â intÂ Â Â Â Â si_signo;Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â Â /* signal number */
This hunk obviously was not meant to be part of the patch, and should haveserved as an reminder to fix <linux/elfcore.h>, which cannot be used fromuser space any more because it actually depends on elf_greg_t fromasm/elf.h, which is no longer exported...
Any idea what to do about this?
	Arnd <><
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
