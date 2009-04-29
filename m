Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZD2L2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZD2L2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZD2L2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:28:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZD2L2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:28:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 22/30] microblaze_mmu_v1: Update linker script for MMU
Date: Wed, 29 Apr 2009 13:27:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <1240821139-7247-22-git-send-email-monstr@monstr.eu> <1240821139-7247-23-git-send-email-monstr@monstr.eu>
In-Reply-To: <1240821139-7247-23-git-send-email-monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904291327.50092.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+iUtVvqDf5aynnAMrsVVHin/KUtSCtNh671el
 x0x80nsDJAGeq8pHej6ww/2pdEHD6Vs+9o9q9W8qsTPyKTZMm2
 1dSXi+sCixedXpvs2E6CA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, monstr@monstr.eu wrote:
> --- a/arch/microblaze/kernel/vmlinux.lds.S
> +++ b/arch/microblaze/kernel/vmlinux.lds.S
> @@ -17,8 +17,11 @@ ENTRY(_start)
>  jiffies = jiffies_64 + 4;
>  
>  SECTIONS {
> +#ifdef CONFIG_MMU
> +       . = CONFIG_KERNEL_START;
> +#else
>         . = CONFIG_KERNEL_BASE_ADDR;
> -
> +#endif
>         .text : {
>                 _text = . ;
>                 _stext = . ;

This change looks a bit bogus, can't you use the same symbol for
both? I guess either one would be fine, but I don't see a reason
for them to be different.

	Arnd <><
