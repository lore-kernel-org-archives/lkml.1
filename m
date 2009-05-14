Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbZENDA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbZENDA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 23:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761774AbZENDAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 23:00:17 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43547 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761319AbZENDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 23:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CR+WbNofGZqRC07dIOMC7kqX6vwz2G6AZWZzhPyYmBjfldfTOOFVj6hFOZxB32AOKQ
         svO5qSChfRVmqbirO0LZS0jVYkZSAEL1aTI0SCZA92noZXFzlyBwVkClnR5SALyo26ms
         DdqNq/8i00K3ikfqScF4Yfuk4cCerrQYG/ao4=
MIME-Version: 1.0
In-Reply-To: <1242253628.3364.26.camel@localhost.localdomain>
References: <1242253628.3364.26.camel@localhost.localdomain>
Date: Thu, 14 May 2009 07:00:16 +0400
Message-ID: <aa79d98a0905132000g18629ebx7f260eca03a810fc@mail.gmail.com>
Subject: Re: [PATCH -tip] x86: amd_iommu_init.c use NULL pointer
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/09, Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/amd_iommu_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/amd_iommu_init.c
> b/arch/x86/kernel/amd_iommu_init.c
> index 8c0be09..f728b12 100644
> --- a/arch/x86/kernel/amd_iommu_init.c
> +++ b/arch/x86/kernel/amd_iommu_init.c
> @@ -898,7 +898,7 @@ static int __init init_exclusion_range(struct
> ivmd_header *m)
>  /* called for unity map ACPI definition */
>  static int __init init_unity_map_range(struct ivmd_header *m)
>  {
> -	struct unity_map_entry *e = 0;
> +	struct unity_map_entry *e = NULL;
>
>  	e = kzalloc(sizeof(*e), GFP_KERNEL);
>  	if (e == NULL)
> --
> 1.6.0.6
>
Hi Jaswinder,
I believe you could get rid of such init completely. We do check 'e'
after kzalloc anyway.
