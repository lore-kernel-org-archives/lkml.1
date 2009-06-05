Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZFEJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZFEJ2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZFEJ2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:28:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZFEJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:28:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH 2/6] headers_check fix: ia64, fpswa.h
Date: Fri, 5 Jun 2009 10:26:33 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <1244118599.5172.31.camel@ht.satnam>
In-Reply-To: <1244118599.5172.31.camel@ht.satnam>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906051026.34046.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+gicu0uTjnWNMZQwxKvj+seeqh/iYFRsuVVoX
 wLaJIBdr1/tIs4Nn1qxAZQBlFepajH1YGHDkMYZaFOuoqTWwPp
 nFgf5W7Gw23mYHYSHSOqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Jaswinder Singh Rajput wrote:

> index 62edfce..797b064 100644
> --- a/arch/ia64/include/asm/fpswa.h
> +++ b/arch/ia64/include/asm/fpswa.h
> @@ -68,6 +68,7 @@ typedef struct {
>  	efi_fpswa_t	 fpswa;
>  } fpswa_interface_t;
>  
> +#ifdef __KERNEL__
>  extern fpswa_interface_t *fpswa_interface;
> -
> +#endif
>  #endif /* _ASM_IA64_FPSWA_H */

It's pretty obvious that the above data structure also doesn't
apply in user space. In fact it looks like the whole file should
just not be exported. Your patch is not helpful there because
it just silences the warning.

	Arnd <><
