Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbZAFGi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbZAFGi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 01:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZAFGiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 01:38:19 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:7441 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZAFGiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 01:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=TdXRHhjed2Y+6oV0jflo/VxrseNWJ45U8inoEPFqsAM/qH6Bvqlg5Iap6YevQ1KgYz
         +Rzq/lXHZeQcVSOLm6fFG+KhrFeI4pVgT8u/kibUZ7OToU9QGzhXlokTcvNTAfkOWs+G
         5wbIThAPyU1l1iGIrAWCumJKwA+0dvxHFoKhE=
Message-ID: <86802c440901052238x5ff919f1u31360163e547b306@mail.gmail.com>
Date: Mon, 5 Jan 2009 22:38:17 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch] x86: make UV support optional
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, "Cliff Wickman" <cpw@sgi.com>,
       "Jack Steiner" <steiner@sgi.com>, "Russ Anderson" <rja@sgi.com>
In-Reply-To: <20090106060348.GA16738@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090106060348.GA16738@wotan.suse.de>
X-Google-Sender-Auth: 11b58fec214d2d5c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 10:03 PM, Nick Piggin <npiggin@suse.de> wrote:
> UV is fairly rare.... and much of the support is already there to cope with
> 32-bit builds. So this makes sense I think.
>
> --
> Make X86 SGI Ultraviolet support configurable. Saves about 13K of text size
> on my modest config.
>
>   text    data     bss     dec     hex filename
> 6770537 1158680  694356 8623573  8395d5 vmlinux
> 6757492 1157664  694228 8609384  835e68 vmlinux.nouv
>
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  arch/x86/Kconfig                  |    7 +++++++
>  arch/x86/include/asm/genapic.h    |   24 ++++++++++++++++++++++++
>  arch/x86/include/asm/genapic_32.h |    7 -------
>  arch/x86/include/asm/genapic_64.h |    9 ---------
>  arch/x86/kernel/Makefile          |    5 +++--
>  arch/x86/kernel/entry_64.S        |    2 ++
>  arch/x86/kernel/genapic_64.c      |    3 ++-
>  arch/x86/kernel/io_apic.c         |    2 +-
>  8 files changed, 39 insertions(+), 20 deletions(-)

how about
kernel/efi.c:                   efi.uv_systab = config_tables[i].table;
?

YH
