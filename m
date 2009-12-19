Return-Path: <linux-kernel-owner+w=401wt.eu-S1751013AbZLSJNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbZLSJNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 04:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbZLSJNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 04:13:18 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33061 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZLSJNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 04:13:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LuRGcvAAyL0TvlxlkLFbikFEVNBNWt8ozqreHZ2VpR9hTEf3guoBDQJUvogEuoku+T
         lspw7glDymKykw4WPWVC1pWl77iqZuM/rx4Z0IV/7yStTBa0rayQsNrSJjuFjt8bn6zq
         xL7KuERB4JGfLhXdqwYO3kYQYh+ri4KuEAMmI=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.0912181147200.9874@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912181147200.9874@filesrv1.baby-dragons.com>
Date: Sat, 19 Dec 2009 01:13:11 -0800
Message-ID: <c32efac40912190113i5292a395tcc257c16a4870f3b@mail.gmail.com>
Subject: Re: drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to 
	`__udivdi3'
From: Dave Hylands <dhylands@gmail.com>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev@vger.kernel.org,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On Fri, Dec 18, 2009 at 12:54 PM, Mr. James W. Laferriere
<babydr@baby-dragons.com> wrote:
>        Hello Benjamin ,  I am not having a good time compiling 2.6.32.1 .
> First RCU 'inline' difficulties then fusion-mpt 'inline' difficulty ,  Now
> this .
>        This one is not a simple as removing 'inline' from a statement .
>        Would you please look into this ?  Anything else you need please just
> ask .
>        Please cc: me as I am not subscribed to linux-fbdev .
>
>                Tia ,  JimL
>
...snip...
> drivers/built-in.o(.text+0x11345a): In function `radeon_test_moves':
> drivers/gpu/drm/radeon/radeon_test.c:45: undefined reference to `__udivdi3'
> make: *** [.tmp_vmlinux1] Error 1

__udivdi3 is a gcc helper function used to do 64-bit division. This
form of 64-bit division is not supported from within the kernel (which
is why you get the undefined symbol).

There is <asm/div64.h> which contains a macro called do_div which can
perform a 64-bit dvision by a 32-bit divisor.

-- 
Dave Hylands
Shuswap, BC, Canada
http://www.DaveHylands.com/
