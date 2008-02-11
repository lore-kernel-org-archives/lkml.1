Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbYBKSc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbYBKSc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYBKScT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:32:19 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:54917 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYBKScS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:32:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HcmtaPNTjvk06ektYlwn+qEcMj3HXOpXt6y81a5GT2iE0SGpIQnVrzuc4Zwq7/m6p3iDaBKTHVTIP7uVvwDLgslDun4RSLtOR7hmaenOb54blETHPzueK15BK+rA4gLF3pZgrhc7+8Ws3T4a6c1ZGqHxSJGBpCOwzP20w4k26v4=
Message-ID: <15577be70802111032l6ea6d2fagba2da4462c739d66@mail.gmail.com>
Date: Mon, 11 Feb 2008 19:32:17 +0100
From: "Abel Bernabeu" <abelbg@m2grp.com>
Reply-To: abelbg@m2grp.com
To: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Elf loader crash while zero-filling .bss
In-Reply-To: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com>
X-Google-Sender-Auth: 8640d86849dbaac5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/11, Abel Bernabeu <abelbg@m2grp.com>:
> I've finally found a solution for the crash in load_binary_elf I
> reported last week:
>
> http://lkml.org/lkml/2008/1/30/171
>
> The attached patch solves my problem, but please test it yourself...
>
> set_brk(start, end) allocs just page aligned regions (by "colapsing"
> both extremes to the start of the page in which they lay)... That
> means than even if both pointers are not equal there are still some
> chances that set_brk has allocated no space at all because
> ELF_PAGEALIGN(elf_bss) != ELF_PAGEALIGN(elf_brk).

Sorry this was an errata in my comment:  no space is allocated at all
because ELF_PAGEALIGN(elf_bss) == ELF_PAGEALIGN(elf_brk)
