Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZHGPUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZHGPUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZHGPUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:20:24 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:45755 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZHGPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=DB4kHe7gLMbi9wwBHbG3WaPFgNVxJb3TxI3zmQquAb3DXFVI+Ue5FvXnZdaUI/nG/6
         xyPyPQR/9TcGyJ4hXaTGsNUoRbLTlEHSy3Vi/bYeB8tYQyOTtzJzu3+HQV+hO3qbyRXW
         WqybcWj+GhVsm02phgbd2hY8BotpjXNP/2ZpM=
Date: Fri, 7 Aug 2009 23:28:46 +0800
From: JiSheng Zhang <jszhang3@gmail.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: [UBI UBIFS] replace vmalloc with kmalloc
Message-ID: <20090807232846.34bffdeb@ustc>
In-Reply-To: <4A7BF1C3.4050602@nokia.com>
References: <2df346410908070202i6c16008ckc145559a474129c6@mail.gmail.com>
	<4A7BF1C3.4050602@nokia.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Hunter <adrian.hunter@nokia.com> wrote:
> 
> vmalloc allows large (> 128KiB) buffers, but kmalloc doesn't.
> So we presently have no choice but to use vmalloc.

But vmalloced buffer can't be easily passed to DMA, is there better choice?

> 
> I do not know what hardware you have or exactly what driver you
> are using, but we have UBIFS on OneNAND using DMA.

An arm soc board, the controller driver hasn't been merged upstream.
> See drivers/mtd/onenand/omap2.c
>

One limit of the omap2.c is that the buffer passed to DMA can't be larger than
PAGESIZE?

Jisheng

