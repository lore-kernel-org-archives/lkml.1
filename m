Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbZIRBty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbZIRBty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 21:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZIRBtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 21:49:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:60978 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZIRBtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 21:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rSjAdt8zLQmOUNTSd7tPim1K2VHm9WZc4+7nfDtHS0nVGv8f3/7Q+3ybe0nLdIQ13H
         2zYz4VjtT4KnpWOOdBCHAtoLyYuw2SABzKGG1+DRRLKp3y23vsKHBsPXXVPGmpF0mBGk
         i2MXlX4j8iFExQGSiUHA9iSEMupQqp+BYQe8o=
MIME-Version: 1.0
In-Reply-To: <200909171345.30988.arnd@arndb.de>
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
	 <200909171345.30988.arnd@arndb.de>
Date: Fri, 18 Sep 2009 09:49:53 +0800
Message-ID: <2375c9f90909171849n429bc474heabdc4d4fd064226@mail.gmail.com>
Subject: Re: [patch] Makefile: can't build modules outside the kernel tree if 
	it was built using O=
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Caveh Jalali <ecaveh@gmail.com>, sam@ravnborg.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n8I1o516026428

On Thu, Sep 17, 2009 at 7:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:> On Thursday 17 September 2009, Caveh Jalali wrote:>>> when the platform specific include directories were shuffled around>> without updating the>> top level Makefile. Â however, i think this FAIL is generic, and not>> limited to powerpc.>> here's a patch to the top level Makefile to teach it about the shuffled files:>>>>>> --- /local/caveh/linux/linux-2.6.31/Makefile Â  Â 2009-09-09>> 15:13:59.000000000 -0700>> +++ Makefile Â  Â 2009-09-16 12:23:05.000000000 -0700>> @@ -958,9 +958,9 @@ ifneq ($(KBUILD_SRC),)>> Â  Â  Â  Â  Â  Â  Â  Â  echo " Â in the '$(srctree)' directory.";\>> Â  Â  Â  Â  Â  Â  Â  Â  /bin/false; \>> Â  Â  Â  Â  fi;>> - Â  Â  Â  $(Q)if [ ! -d include2 ]; then Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â \>> - Â  Â  Â  Â  Â  mkdir -p include2; Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â \>> - Â  Â  Â  Â  Â  ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm; Â  Â  \>> + Â  Â  Â  $(Q)if [ ! -d include2 ]; then Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  \>> + Â  Â  Â  Â  Â  mkdir -p include2; Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  \>> + Â  Â  Â  Â  Â  ln -fsn $(srctree)/arch/$(SRCARCH)/include/asm include2/asm; \>> Â  Â  Â  Â  fi>> Â endif>> I think we should no longer have the include2 directory at all with new kernels.>> LINUXINCLUDE already contains the right path in theory:>> LINUXINCLUDE Â  Â := -Iinclude \> Â  Â  Â  Â  Â  Â  Â  Â  Â  $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \> Â  Â  Â  Â  Â  Â  Â  Â  Â  -I$(srctree)/arch/$(hdr-arch)/include Â  Â  Â  Â  Â  Â  Â  \> Â  Â  Â  Â  Â  Â  Â  Â  Â  -include include/linux/autoconf.h
Hmm, at least in mmotm, we still have include2...
Maybe Sam is queueing the patches to remove include2?ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
