Return-Path: <linux-kernel-owner+w=401wt.eu-S933722AbZDHMSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbZDHMSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764440AbZDHMSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:18:14 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44925 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZDHMSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U74CmJtt9I6R0vkkcYiICaMSp5oJAJoIRRqydeh4u53wBeOJacoFh28BLFJxydVzIf
         zbQj5OQHdEZX3uTyeFVFn/48N/yy7GIQMIZZwJ7alxcFYmt+Uiz5U80rby7S0GOV/T6a
         zix/099pLtkeLuKPci0K4EtITnguMz3q8frv4=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 14:18:09 +0200
Message-ID: <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com>
Subject: Re: [PATCH 54/56] x86: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n38CInqu029843

On Wed, Apr 8, 2009 at 13:22, Jack Stone <jwjstone@fastmail.fm> wrote:> Remove uneeded void casts>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>> --->  arch/x86/kernel/machine_kexec_64.c |    8 ++++---->  arch/x86/kernel/microcode_amd.c    |    2 +->  arch/x86/mm/fault.c                |    2 +->  arch/x86/mm/init_32.c              |    4 ++-->  arch/x86/mm/init_64.c              |   10 +++++----->  arch/x86/mm/pageattr.c             |    4 ++-->  6 files changed, 15 insertions(+), 15 deletions(-)>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c> index a03b727..025e4ac 100644> --- a/arch/x86/mm/fault.c> +++ b/arch/x86/mm/fault.c> @@ -368,7 +368,7 @@ void vmalloc_sync_all(void)>                spin_lock_irqsave(&pgd_lock, flags);>                list_for_each_entry(page, &pgd_list, lru) {>                        pgd_t *pgd;> -                       pgd = (pgd_t *)page_address(page) + pgd_index(address);> +                       pgd = page_address(page) + pgd_index(address);Probably wrong again because of math.
>                        if (pgd_none(*pgd))>                                set_pgd(pgd, *pgd_ref);>                        else> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c> index d71e1b6..55d3c7c 100644> --- a/arch/x86/mm/pageattr.c> +++ b/arch/x86/mm/pageattr.c> @@ -343,7 +343,7 @@ static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)>                        pud_t *pud;>                        pmd_t *pmd;>> -                       pgd = (pgd_t *)page_address(page) + pgd_index(address);> +                       pgd = page_address(page) + pgd_index(address);Probably wrong again because of math.
>                        pud = pud_offset(pgd, address);>                        pmd = pmd_offset(pud, address);>                        set_pte_atomic((pte_t *)pmd, pte);> --Bert���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
