Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYJQM5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYJQM5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbYJQM5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:57:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYJQM5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:57:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ibm_newemac: Fix new MAL feature handling
Date: Fri, 17 Oct 2008 14:56:52 +0200
User-Agent: KMail/1.9.9
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081015213337.a99a9595.akpm@linux-foundation.org> <1224133010.8157.543.camel@pasglop> <20081016143840.GA29805@yoda.jdub.homelinux.org>
In-Reply-To: <20081016143840.GA29805@yoda.jdub.homelinux.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810171456.53599.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+VwFaLhN2PBnAnH/4Iw03sVnWHCI7mZ2hLLay
 JYvOO51d/iLED3pw8LVusUUCkQ88ctln5wbIfPpR5q/N5mplrc
 gZJrqjB4ZGIcRGE4C0BaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Josh Boyer wrote:
> +#ifdef CONFIG_PPC_DCR_NATIVE
>         if (mal_has_feature(mal, MAL_FTR_CLEAR_ICINTSTAT))
>                 mtdcri(SDR0, DCRN_SDR_ICINTSTAT,
>                                 (mfdcri(SDR0, DCRN_SDR_ICINTSTAT) | ICINTSTAT_ICTX));
> +#endif
>  

So what if you have a mmio based DRC implementation and still want to use
this feature?

I guess you really should use dcr_read/dcr_write here instead of mtdcr/mfdcr.

	Arnd <><
