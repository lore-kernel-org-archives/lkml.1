Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbZIDJhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbZIDJhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbZIDJhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:37:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:56030 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbZIDJhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TL9vfXJ6OC6vcpB51r35TJQ3l16brb9foixOHMVB+bdSTLE63WWjGBnnit/GW4HaAv
         FGl2Whw/Agv7a1R9WO/z9+ahUyKeMsWZepXn9YSx42fsdBOqOB8UmfSR6kRJSpv5LxaY
         97HoGSUVCLCXtLZNBZkUxpShw2XuJb3BqCZxQ=
MIME-Version: 1.0
In-Reply-To: <817ecb6f0909031813n335279a3pb974b9efa8989095@mail.gmail.com>
References: <817ecb6f0909031813n335279a3pb974b9efa8989095@mail.gmail.com>
Date: Fri, 4 Sep 2009 17:37:42 +0800
Message-ID: <2375c9f90909040237r493e721ap9ec20111097e080b@mail.gmail.com>
Subject: Re: [PATCH V3] x86: NX protection for kernel data
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 9:13 AM, Siarhei Liakh<sliakh.lkml@gmail.com> wrote:
> This patch expands functionality of CONFIG_DEBUG_RODATA to set main
> (static) kernel data area as NX.
> The following steps are taken to achieve this:
> 1. Linker script is adjusted so .text always starts and ends on a page boundary
> 2. Linker script is adjusted so .rodata and .data always start and
> end on a page boundary
> 3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
> functionality: NX is set for all pages from _etext through _end.
> 4. mark_nxdata_nx() called from free_initmem() (after init has been released)
> 5. free_init_pages() sets released memory NX in arch/x86/mm/init.c
>
> The patch have been developed for Linux 2.6.31-rc7 x86 by Siarhei Liakh
> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
>
> V1:  initial patch for 2.6.30
> V2:  patch for 2.6.31-rc7
> V3:  moved all code into arch/x86, adjusted credits


Looks fine, but I don't think it is necessary to bother "CREDITS",
because now we have git. :)

Thanks.
