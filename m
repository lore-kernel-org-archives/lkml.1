Return-Path: <linux-kernel-owner+w=401wt.eu-S1751942AbYIGXfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbYIGXfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 19:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYIGXf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 19:35:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:44112 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYIGXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 19:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D9aSB9yk1eSImaXYRXvllzTFh9KEOBTza/ny2bBFV2tLy0fEHKnZroixw4vdI/oYLh
         55j3F1p+YowlZlf0JEggIclAVxRdMqhXyYJJK5pJXmha8dYaHCWTeRo4+Ts59705zVIK
         m8bUedD8Z+N9pB+qfMS1R9q/Dz7Dzh390vU7k=
Message-ID: <86802c440809071635l1457659bufeefa6e65cc34bdf@mail.gmail.com>
Date: Sun, 7 Sep 2008 16:35:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 7 of 7] x86: always explicitly map acpi memory
Cc: "Ingo Molnar" <mingo@elte.hu>, "Xen Devel" <xen-devel@lists.xensource.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <6f23bad119ae2ed00f1c.1220826079@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <patchbomb.1220826072@localhost>
	 <6f23bad119ae2ed00f1c.1220826079@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 3:21 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Always map acpi tables, rather than assuming we can use the normal
> linear mapping to access the acpi tables.  This is necessary in a
> virtual environment where the linear mappings are to pseudo-physical
> memory, but the acpi tables exist at a real physical address.  It
> doesn't hurt to map in the normal non-virtual case, so just do it
> unconditionally.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/kernel/acpi/boot.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -126,9 +126,6 @@
>
>        if (!phys || !size)
>                return NULL;
> -
> -       if (phys+size <= (max_low_pfn_mapped << PAGE_SHIFT))
> -               return __va(phys);
>
>        if (prev_map)
>                early_iounmap(prev_map, prev_size);
>

actually,
case 1: acpi tables near mmio, range, we don't map them from
2.6.27-rc1, and it is bigger than max_low_mapped...
case 2: some strange system put acpi in the middle of RAM... like when
8G ram installed, but MMIO is 3.5G, BIOS put acpi tables around 2G..

YH
