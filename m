Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZGDFvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZGDFvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 01:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbZGDFvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 01:51:22 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:57584 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZGDFvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 01:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IM3nhKoH+wcWiZMGfWet5iB8iDRzFv4QHnuxKydMwMugHEl1R2MU12BaumKzFrXEbv
         wnEuXvYsZF9JswbRY5f3FQfhROSAZ/+DSrI4+qnZG2xncImobdJkGEcpS8p8BDpgvDE4
         XwELiwDTPgmsA8hc/Lpa4anwkEsViDiz8KNvo=
MIME-Version: 1.0
In-Reply-To: <4A4E9638.20304@kernel.org>
References: <4A4E9638.20304@kernel.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 4 Jul 2009 01:51:04 -0400
Message-ID: <8bd0f97a0907032251p753527e1oac25ea1740a1bfdb@mail.gmail.com>
Subject: Re: [RFC PATCH] linker script: unify usage of discard definition
To: Tejun Heo <tj@kernel.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       Sam Ravnborg <sam@ravnborg.org>, Paul Mundt <lethal@linux-sh.org>,
       Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n645ploU008184

On Fri, Jul 3, 2009 at 19:37, Tejun Heo wrote:> +/*> + * DISCARDS must be the last and archs which want some of the default> + * discarded sections in the kernel image can do so by putting them in> + * earlier section definition.> + */>  #define DISCARDS                                                       \>        /DISCARD/ : {                                                   \>        EXIT_TEXT                                                       \>        EXIT_DATA                                                       \> -       *(.exitcall.exit)                                               \> +       EXIT_CALL                                                       \>        *(.discard)                                                     \>        }
i would add to the comment that some people want to discard exittext/data at runtime rather than link time due to cross-sectionreferences such as alt instructions, bug table, eh_frame, etc...
otherwise, looks good to me.  thanks !
Acked-by: Mike Frysinger <vapier@gentoo.org>-mike���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
