Return-Path: <linux-kernel-owner+w=401wt.eu-S1762820AbZATCAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820AbZATCAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 21:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZATCAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 21:00:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:22798 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbZATCAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 21:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WDqidhwfF8wTnelf1WNN3vGAhU/DkOej13NFA9QuuOX06KbEmp8Efw76ogOM1mEwpH
         kt1zRHMI9ZF4BoXNOaQADW78F/9c2pTGX00IYsMZD8MuZO25OK5YD3OR/oxZvxuTFpKK
         tT2UGfyHqVnWLwPb/za87paMU8J7T/KDlQa+I=
MIME-Version: 1.0
In-Reply-To: <20090120011945.GA23380@oksana.dev.rtsoft.ru>
References: <496A89A1.8050302@gmail.com>
	 <646765f40901191650v5320f5e4tcc5fb7da0555ade1@mail.gmail.com>
	 <20090120011945.GA23380@oksana.dev.rtsoft.ru>
Date: Tue, 20 Jan 2009 13:00:19 +1100
Message-ID: <646765f40901191800y27530acaw74edc01abdd13e68@mail.gmail.com>
Subject: Re: [PATCH] mb862xx: Restrict compliation of platform driver to PPC
From: Julian Calaby <julian.calaby@gmail.com>
To: avorontsov@ru.mvista.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Anatolij Gustschin <agust@denx.de>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Matteo Fortini <m.fortini@selcomgroup.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 12:19, Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> Should be Anatolij. ;-)

Who is the first person on the list, I guess he's missed this or isn't
reading his email.

> But I'm interested in this driver as well.
>
> FWIW, the patch looks OK, except for the long lines in the commit log.

I don't expect this to be applied as is. There is a better fix out
there, but I don't know the hardware so I'm not sure what it is.

> Also you'd better mention exact build error in the commit log.

Essentially it's a huge list of missing definitions for functions
which aren't defined for SPARC. I'll reply with it if you really want
it, however they look to be PPC specific. If they were generic I would
have simply included the correct files so that it compiled, rather
than this nasty hack.

It also appears that these functions are not defined in the headers
that this driver includes.

> (Btw, we'd better fix the build for sparc instead of adding another
> "depends on". Could anybody point to some recent, working sparc cross
> toolchain? Last time I googled for it I found only some prehistoric
> versions that I didn't bother to try...)

Before we commit to fixing this properly, is it really worth it? Is
this hardware ever likely to be used with SPARC?

Given that there are PCI and OF versions of the driver, it seems to me
that this is available as a PCI expansion card, and as a graphics chip
built into some PPC motherboards. The initial commit says: "Lime GDC
support is known to work on PPC440EPx based lwmon5 and MPC8544E based
socrates embedded boards, both equipped with Lime GDC." so I'm
guessing that this graphics chip is designed for embedded boards. I
can find references to it's use in embedded automotive applications on
Google but I can't find any reference to the Fujitsu LIME (MB86276)
and SPARC on Google.

Note that the PCI version of this driver compiles fine with both
allyesconfig and allmodconfig.

If you're sure you want to do this, I'd check out crosstool for a
SPARC cross-complier.

Two other things:
1. SPARC32 and SPARC64 can be compiled with the same compiler.
2. These two platforms have slightly different OpenFirmware interfaces
- so fixing it for both of these will be a pain.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: https://sites.google.com/site/juliancalaby/
