Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZFDUky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZFDUky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZFDUkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:40:47 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:57364 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZFDUkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XO24Q5JzyN8cneiMjlqUK4qUjtv/kZ7310WL5rpjv+Ik9EivZCmi4KTUFR/yQYGsUo
         ET7y5cKOLBBgQ70Yzgy+lNhFwJJQIxUFvp0jMpp7ump3Xna89l6dPQZl3lTzOE78qXxJ
         La1N+rnG9g991zS1v+JWrvsrYY3H75Ul+NG68=
MIME-Version: 1.0
In-Reply-To: <20090604180736.GA24902@kroah.com>
References: <20090604133132.19010.16577.sendpatchset@subratamodak.linux.ibm.com>
	 <20090604180736.GA24902@kroah.com>
Date: Thu, 4 Jun 2009 22:40:47 +0200
X-Google-Sender-Auth: a3b8cef4759b8925
Message-ID: <10f740e80906041340x4f51b5f0ra542b60d758a4b54@mail.gmail.com>
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig 
	[drivers/staging/comedi/drivers.o]
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 20:07, Greg KH <greg@kroah.com> wrote:
> On Thu, Jun 04, 2009 at 07:01:32PM +0530, Subrata Modak wrote:
>> CC [M]  drivers/staging/comedi/drivers.o
>> drivers/staging/comedi/drivers.c: In function ‘comedi_buf_alloc’:
>> drivers/staging/comedi/drivers.c:496: error: ‘PAGE_KERNEL_NOCACHE’ undeclared (first use in this function)
>> drivers/staging/comedi/drivers.c:496: error: (Each undeclared identifier is reported only once
>> drivers/staging/comedi/drivers.c:496: error: for each function it appears in.)
>> make[3]: *** [drivers/staging/comedi/drivers.o] Error 1
>> make[2]: *** [drivers/staging/comedi] Error 2
>> make[1]: *** [drivers/staging] Error 2
>> make: *** [drivers] Error 2
>>
>> Is it still normal to expect this failure ?
>
> No.
>
>> I reported them long back during April:
>> http://www.gossamer-threads.com/lists/linux/kernel/1065227,
>
> Yes, and I took some patches that were supposed to fix this.  I can't
> duplicate this here, care to send a patch that would fix it?

PAGE_KERNEL_NOCACHE is defined on a few architectures only, namely
frv, m32r, mn10300, sh, and x86[*]. On all others, it will fail.

[*] Interestingly, sparc refers to it in one of its include files,
without providing a
    definition, Probably that code is unused.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
