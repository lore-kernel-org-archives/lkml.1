Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYHYSbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYHYSbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYHYSbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:31:08 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42603 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYHYSbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yGppYfAsRf+HFeUKf75E/2eUOGWYHvwGX2alO506XkO4l4duNC2hnqM8hL2F9eKfC0
         0e1qcxzB7uOR4mtn8BCowm1q3YdH5H5/sbBV4wX+C9lnr9nEr8EGBIb0k5l9T4Tl/xrx
         +3DS2FwFVjBipppBxa96mx6coUlrUcI0Es0Fg=
Message-ID: <19f34abd0808251131t511d2d8g925b3dae94620e9a@mail.gmail.com>
Date: Mon, 25 Aug 2008 20:31:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Jones" <davej@redhat.com>, "H. Peter Anvin" <hpa@kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
In-Reply-To: <20080824181304.GA5963@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>
	 <20080820013930.GN9807@one.firstfloor.org>
	 <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com>
	 <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org>
	 <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com>
	 <48B19799.6090703@kernel.org>
	 <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com>
	 <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com>
	 <20080824181304.GA5963@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 8:13 PM, Dave Jones <davej@redhat.com> wrote:
> On Sun, Aug 24, 2008 at 07:45:48PM +0200, Vegard Nossum wrote:
>  > Why is MHz on 375!? I tried cpufreq-selector, but nothing changed. Maybe
>  >
>  > calling  acpi_cpufreq_init+0x0/0x90
>  > initcall acpi_cpufreq_init+0x0/0x90 returned -19 after 0 msecs
>
> -ENODEV.  Because you don't have frequency scaling capable CPU.
>
>  > Okay, now I used cpufreq-selector to change to "ondemand" governor,
>  > and MHz goes back to 3000. Weird. Why would "performance" governor put
>  > my machine to a constant 375?
>
> Probably because you're using p4-clockmod, and it's crap.

On Sun, Aug 24, 2008 at 7:59 PM, H. Peter Anvin <hpa@kernel.org> wrote:
> That would be a problem... I presume this problem is independent of the
> patch, though?

I sorted it -- thanks! It turned out to be pretty obscure; my tty
setting for the receiving end of the serial console was set to echo.
So when the machine booted, it was echoing lots of characters into the
Fedora 7 init, which would prompt for the starting of cpuspeed
initscript. Turning off echo for the tty was what triggered the
slowness; removing cpuspeed from the runlevel entirely solved the
problem.

Don't know why cpuspeed would select a governor which runs the CPU at
a constant 300 MHz, though.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
