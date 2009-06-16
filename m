Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbZFPKfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbZFPKfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbZFPKew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:34:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:21219 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbZFPKev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Xkbj2PPbECnv5IjsgGQtkVdaq0v84Ydg85RhjYQzliwUa0ZhKBc+rd5b5f9/78r8Pz
         mB8Tta4NSCtHS4vECC/OAHRkj0n3CExjej3I2Vup0mcKyY3xBHZN+rYsCgmGj96vPHiQ
         xKWdJgLuj1aQrs8Lndkvn2XSv9FsDIjZA7ZmI=
MIME-Version: 1.0
In-Reply-To: <200906142217.50997.arnd@arndb.de>
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org> 
	<1244959204-11269-4-git-send-email-vapier@gentoo.org> <200906142217.50997.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 16 Jun 2009 06:34:34 -0400
Message-ID: <8bd0f97a0906160334rc85a3bei29bfbfd65f3fab3d@mail.gmail.com>
Subject: Re: [PATCH 4/4] asm-generic: uaccess: fix access_ok() prototype
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 16:17, Arnd Bergmann wrote:
> On Sunday 14 June 2009, Mike Frysinger wrote:
>> @@ -37,14 +37,14 @@ static inline void set_fs(mm_segment_t fs)
>>  #define VERIFY_READ    0
>>  #define VERIFY_WRITE   1
>>
>> -#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
>> +#define access_ok(type, addr, size) __access_ok((addr), (size))
>>
>>  /*
>>   * The architecture should really override this if possible, at least
>
> Upon actually testing this change, it turns out that this causes more
> trouble because of having to pass down pointers that may have 'const'
> or 'volatile' modifiers. I'm sure there is a way to do this correctly,
> but most architectures seem to cope well with 'unsigned long' here,
> and your patch 3/4 solves the original problem nicely.

yeah, i ended up making the Blackfin access_ok replacement cast the
first argument to an unsigned long to avoid those warnings ;).  i
guess we can just leave this alone for a rainy day ...
-mike
