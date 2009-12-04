Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZLDT5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZLDT5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 14:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757144AbZLDT5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 14:57:20 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:60667 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbZLDT5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 14:57:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=UOUg69cZEKIlj9J1hMUWWNorqwgogL0tfuTKyLFY9+GxlFn7og/QxeSRXc64OrxqPJ
         hOGYNfrj7UlD8Kc2sqx8x866rkUt3aUJzKKXW3o4By3PEKLvoWLvZv/vI1DQI6rv6aJM
         pn0PIn8e+zJ24EJ3IcOy8syhQCdlj6QQkmX2s=
MIME-Version: 1.0
In-Reply-To: <4B13CC00.9080607@codesourcery.com>
References: <alpine.DEB.2.00.0911252213340.31650@ayla.of.borg>
	 <4B13CC00.9080607@codesourcery.com>
Date: Fri, 4 Dec 2009 20:57:25 +0100
X-Google-Sender-Auth: 72c56947876273fa
Message-ID: <10f740e80912041157j41984f4ay6ca2e56d70ac08e2@mail.gmail.com>
Subject: Re: M68k tree updates
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maxim Kuvyrkov <maxim@codesourcery.com>, Greg Ungerer <gerg@snapgear.com>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 14:43, Maxim Kuvyrkov <maxim@codesourcery.com> wrote:
> Geert Uytterhoeven wrote:
>>
>> It took me a while, but finally I managed to update
>> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git again.
>
> ...
>>
>> If anything is missing, please tell me. Thx!
>
> How about the NPTL patch (0001-Add-NPTL-support-for-m68k.patch,
> http://marc.info/?l=linux-m68k&m=125447760017098&w=2)?

As you're adding syscalls (which are shared with m68knommu), I'll have
to ask whether
you will make it work on nommu, too?

Furthermore, when building for Sun3:

arch/m68k/kernel/sys_m68k.c:706: warning: passing argument 1 of
'kunmap' from incompatible pointer type
arch/m68k/kernel/sys_m68k.c:714: warning: passing argument 1 of
'kunmap' from incompatible pointer type

Which looks like a problem with the Sun 3 version of pte_unmap().

I'm gonna add it to the m68k tree though, unless someone complains.

> Also, this trivial fix (0004-Fix-m68k-s-asm-swab.h-for-ColdFire.patch,
> http://marc.info/?l=linux-m68k&m=125447494213740&w=2) can go in.

I want to run this one by the nommu people as well...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
