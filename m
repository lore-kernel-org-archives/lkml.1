Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYGAW6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYGAW6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYGAW6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:58:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:4946 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbYGAW6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k89OY7kXufk2Z4saZMKhLBASqlferLu60HQgIcXABjctYO8IfMI9o6mwVzK3mEdLim
         MrQ6PYC9qRiiSOb3kJI5uGhn+zbbgUt66hXZ7nSmLeTdjPPqYOz1s6SrF7CbMq33vsXD
         cGKHIFGz/er2K7Mk2Ae8agVvcfQfZ14s4xBKI=
Message-ID: <8bd0f97a0807011558u2c02f6fcre2f3af3d5cced936@mail.gmail.com>
Date: Tue, 1 Jul 2008 18:58:02 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Subject: Re: [PATCH 5/23] make section names compatible with -ffunction-sections -fdata-sections: blackfin
Cc: linux-arch@vger.kernel.org, "Russell King" <rmk@arm.linux.org.uk>,
       "David Howells" <dhowells@redhat.com>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Lennert Buytenhek" <kernel@wantstofly.org>,
       "Josh Boyer" <jwboyer@linux.vnet.ibm.com>,
       "Paul Mackerras" <paulus@samba.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Andi Kleen" <andi@firstfloor.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Tim Bird" <tim.bird@am.sony.com>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Dave Miller" <davem@davemloft.net>
In-Reply-To: <200807020235.08025.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807020235.08025.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 8:35 PM, Denys Vlasenko wrote:
> The purpose of this patch is to make kernel buildable
> with "gcc -ffunction-sections -fdata-sections".
> This patch fixes blackfin architecture.

the comment right above what you changed says it already works for
Blackfin.  so you arent fixing it at all.
>                /* This gets done first, so the glob doesn't suck it in */
>                . = ALIGN(32);
> -               *(.data.cacheline_aligned)
> +               *(.cacheline_aligned.data)

ive built Blackfin kernels with function/data sections a long time ago
... but iirc, there were toolchain problems, so i havent pursued it
since.

if you're going to muck with names, you might as well do it right the
first time: move the names into asm-generic/vmlinux.lds.h so we dont
have to worry about this kind of churn again.
-mike
