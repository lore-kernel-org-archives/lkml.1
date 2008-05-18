Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYERT4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYERT4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYERT4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 15:56:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42588 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYERTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 15:55:59 -0400
Date: Sun, 18 May 2008 21:55:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Adrian Bunk <bunk@kernel.org>
cc: Jiri Slaby <jirislaby@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: Re: crossbuild fails in modpost
In-Reply-To: <20080515204632.GG1936@cs181133002.pp.htv.fi>
Message-ID: <alpine.LNX.1.10.0805182155011.15590@fbirervta.pbzchgretzou.qr>
References: <482C3E3E.9090204@gmail.com> <482C6F02.1000205@gmail.com> <20080515173539.GA23959@uranus.ravnborg.org> <20080515174015.GA24024@uranus.ravnborg.org> <482C8CBE.2060101@gmail.com> <20080515204632.GG1936@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-15 22:46, Adrian Bunk wrote:
>>
>> Well, the compiler is the same, but it's told to compile the kernel with  
>> -m64. It runs on x86_64 kernel and i386 userspace. It's debian i386 gcc  
>> package which understands x86_64 objects too. No SUBARCH option, it seems 
>> to default to x86_64.
>>...
>
>Unless you manually fiddle with ARCH you can only build a kernel with 
>the same 32<->64bit setting as your currently running kernel (no matter 
>which userspace you use)...

echo -en '#!/bin/bash\nexec gcc -m32 "$@"\n' >/usr/local/bin/i386-linux-gcc
make CC=i386-linux-gcc
then the if($(CC),$(HOSTCC)) check should get true.
