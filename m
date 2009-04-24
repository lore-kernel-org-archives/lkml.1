Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZDXOtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZDXOtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZDXOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:49:12 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:56861 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZDXOtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dG3uyWsLTz7unwWZyt/c/7Ssw96m7xkKVsOsC1vUZmQNytl7TxM7h0aPYdC9efqH4s
         hL+loprQ+ZiYiDH1KQu9oG/2mB+Ppg+tTpY3VVRmBZs2Lno6zDjNb/FXGp8VYC8ClVSH
         D16+Vng/3CZw1nJ43Qd3FfeDkxIXPOhAtej2E=
MIME-Version: 1.0
In-Reply-To: <1240414831-20429-1-git-send-email-anemo@mba.ocn.ne.jp>
References: <1240414831-20429-1-git-send-email-anemo@mba.ocn.ne.jp>
Date: Fri, 24 Apr 2009 07:49:10 -0700
X-Google-Sender-Auth: 103c66f36e12f74e
Message-ID: <e9c3a7c20904240749g79b7b54cufa64149e44b5753a@mail.gmail.com>
Subject: Re: [PATCH] DMA: TXx9 Soc DMA Controller driver (v3)
From: Dan Williams <dan.j.williams@intel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 8:40 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> This patch adds support for the integrated DMAC of the TXx9 family.
>
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: Dan Williams <dan.j.williams@intel.com>

> +static void
> +txx9dmac_descriptor_complete(struct txx9dmac_chan *dc,
> +                            struct txx9dmac_desc *desc)
[..]
> +       /*
> +        * We use dma_unmap_page() regardless of how the buffers were
> +        * mapped before they were submitted...
> +        */

This will be caught by the new dma-mapping debug infrastructure that
went in for 2.6.30, but I would not hold up merging this driver for
this issue.  Once Maciej's fix [1] goes upstream you can fix up your
driver to use the new "unmap single" flags.

Thanks,
Dan

[1]: http://marc.info/?l=linux-kernel&m=124049040806961&w=2
