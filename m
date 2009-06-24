Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbZFXQx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbZFXQx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761518AbZFXQxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:53:48 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41855 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761326AbZFXQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I5D/HcwaLLNncKwWAbzybCodBbZXcrQdPhsrL4PfAmBRjiuF5RQZo8bihR6YWesaOP
         hWTVlZSfHX4t4Ua/s2QpTy3aoig2can2dNCOn0J8YWsSR54VhehIrlJhRAPMEMCjscba
         XfUegj2i6T++ecweCT5VN5rURnfHsob2dHLaI=
Message-ID: <4A425925.7000601@gmail.com>
Date: Wed, 24 Jun 2009 18:49:41 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: David Woodhouse <dwmw2@infradead.org>,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@lazybastard.org>,
       Sam Ravnborg <sam@ravnborg.org>, Tim Bird <tim.bird@am.sony.com>,
       Chris Simmonds <chris@2net.co.uk>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
References: <4A33A7EC.6070008@gmail.com> <200906232355.34134.arnd@arndb.de> <2ea1731b0906232332n2488d452p27419eac7edab7e4@mail.gmail.com> <200906241730.37151.arnd@arndb.de>
In-Reply-To: <200906241730.37151.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 24 June 2009, Marco Stornelli wrote:
>>> Actually, reading from /dev/mem is only valid on real RAM. If the nvram
>>> is part of an IO memory mapping, you have to do mmap()+memcpy() rather
>>> than read(). So dd won't do it, but it's still easy to read from user
>>> space.
>> For "security" reasons pram reserve the region of memory with
>> reserve_mem_region_exclusive().....
> 
> That will only prevent other device drivers from stepping on it,
> /dev/mem does not care about mem_region reservations.
> 
> 	Arnd <><
> 

Userland may not map this resource, so /dev/mem and the sysfs MMIO
access will not be allowed. This restriction depends on STRICT_DEVMEM
option. It's true that currently is only implemented in the x86 world.

Marco

