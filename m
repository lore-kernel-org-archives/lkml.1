Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZKIUCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZKIUCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZKIUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:02:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56260 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZKIUCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:02:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rdTYGOGLQltQqmNhmgliCI9LkdJdb5fiQUTzRiL0Zjy9TrWjd/v19LHgj95GIbFX9T
         sWTJ0Hu9yBCWChprTOM4SN/Z8eI+UxvNsLAavduFYBHJZBs/UHXhzydlYSw8Y/BydhDV
         eHQvsIktlFa0tNvKJJ8uUeU93Yp+0ABcXbFuc=
MIME-Version: 1.0
In-Reply-To: <1256712464-21472-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1256712464-21472-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Date: Mon, 9 Nov 2009 22:02:24 +0200
X-Google-Sender-Auth: 53c3436b67556375
Message-ID: <84144f020911091202h26dbfad4qf0651ae327444fc0@mail.gmail.com>
Subject: Re: [PATCH 01/10] Add iommu_init to x86_init_ops
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 8:47 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> We call the detections functions of all the IOMMUs then all their
> initialization functions. THe latter is pointless since we don't
> detect multiple different IOMMUs. What we need to do is calling the
> initialization function of the detected IOMMU.
>
> This adds iommu_init hook to x86_init_ops so if an IOMMU detection
> function can set its initialization function to the hook.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/include/asm/iommu.h    |    1 +
>  arch/x86/include/asm/x86_init.h |    9 +++++++++
>  arch/x86/kernel/pci-dma.c       |    2 ++
>  arch/x86/kernel/x86_init.c      |    5 +++++
>  4 files changed, 17 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
> index fd6d21b..42aa977 100644
> --- a/arch/x86/include/asm/iommu.h
> +++ b/arch/x86/include/asm/iommu.h
> @@ -3,6 +3,7 @@
>
>  extern void pci_iommu_shutdown(void);
>  extern void no_iommu_init(void);
> +static inline int iommu_init_noop(void) { return 0; }

Why is this function not put in x86_init.c?
