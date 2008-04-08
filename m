Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYDHNKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYDHNKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYDHNKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:10:35 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:39345 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYDHNKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UDuHysDXrypSpR0UhbR59tte6BUWhHKpkJfZ+4zI483Jc8QcmOIbAGTJDeoJ6d6odmclbW4p9tUcZw1itILeah+h1KIOBlJDqY5/pjQ4T3m+Z/6OTiYZSRuGC662yCozehiTg/diSU5ekpbyc0IhQMUHH4Jd90KTA6GzCCRKO5U=
Message-ID: <1ee641e10804080610r5a81b96dr277de5953d0dbae6@mail.gmail.com>
Date: Tue, 8 Apr 2008 15:10:33 +0200
From: "Simon Braunschmidt" <sbraunschmidt.linuxlists@googlemail.com>
To: linux-kernel@vger.kernel.org, arthur.mielimonka@teleca.com
Subject: Fwd: [kbuild, arch/arm] - kernel images do not reflect changed .config >> RESOLVED
In-Reply-To: <1ee641e10804080551r51f611cfv85565b1375d9fc32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ee641e10804080551r51f611cfv85565b1375d9fc32@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resolved, was due to usage of a (very old version) of a c compiler
cache (cachecc1)

2008/4/4, Simon Braunschmidt <sbraunschmidt.linuxlists@googlemail.com>:
> Hi
>
> Problem:
> After changing anything in the .config, updated objects get only into
> arch/arm/boot/Image but not into the other targets.
>
> Steps to reproduce:
> -checkout clean 2.6.24
> -change in Makefile:
> ARCH=arm
> CROSS_COMPILE=arm-none-linux-gnueabi- (codesourcery toolchain to
> support armv7 (cortex a8))
> then:
> #make integrator_defconfig (I tried integrator_defconfig and
> omap_osk_5912_defconfig)
> #make uImage
> #ls -la arch/arm/boot
> #ls -la arch/arm/boot/compressed
> -note the size of :
> boot/Image
> boot/zImage
> boot/uImage
> compressed/vmlinux
> compressed/piggy.gz
> compressed/piggy.o
>
> -now change the .config, for example deactivate FP emulator and
> binformat support
> -save your .config
> #make distclean
> -restore your .config
> #make uImage
>
> only boot/Image and compressed/piggy.gz will have changed, even after
> distclean. Weird.
>
> Is this already fixed? I'm sorry I cannot check easily since i'm not
> allowed to use git in my corporate environment. *duck*
>
> Regards, Gruessla
>
> Simon Braunschmidt
>
