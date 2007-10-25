Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbXJYUr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbXJYUr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXJYUrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:47:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55705 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751251AbXJYUrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:47:18 -0400
Date: Thu, 25 Oct 2007 22:47:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Jie Zhang <jzhang.linux@gmail.com>,
       bryan.wu@analog.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] blackfin: "extern inline" -> "static inline"
Message-ID: <20071025204748.GW30533@stusta.de>
References: <40401db90710241947i15e40e78v292e52f5229d9d35@mail.gmail.com> <8bd0f97a0710242000h7b6c97e7ia3f461c69b7d5de5@mail.gmail.com> <47200826.1060801@zytor.com> <20071025150545.GK30533@stusta.de> <8bd0f97a0710250916v5d3f0166qbfacf4abb0fc3d45@mail.gmail.com> <20071025165344.GL30533@stusta.de> <8bd0f97a0710251307m9f45f4dmf6d8cfa93af9fdf5@mail.gmail.com> <20071025201842.GT30533@stusta.de> <8bd0f97a0710251320m3490c53dpe85656a939e8536e@mail.gmail.com> <4720FC54.1020705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4720FC54.1020705@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 01:28:04PM -0700, H. Peter Anvin wrote:
> Mike Frysinger wrote:
>>> Do you have any example for your claim "to get gcc to not inline things
>>> when building debug versions"?
>> $ cat test.c
>> __attribute__((always_inline)) int foo(void) { return 0; }
>> int main(void){ return foo(); }
>> $ gcc -g test.c -o test
>> $ readelf -s test | grep FUNC | grep -v _
>>     61: 00000000004004b8    11 FUNC    GLOBAL DEFAULT   13 foo
>>     68: 00000000004004c3    11 FUNC    GLOBAL DEFAULT   13 main
>> looks pretty straightforward to me
>> -mike
>
> For "debug version" meaning -O0, this is true.

No, "inline __attribute__((always_inline))" works with -O0.

He gets a function emitted since his "foo" is not static.

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

