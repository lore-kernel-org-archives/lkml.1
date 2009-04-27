Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZD0Kza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZD0Kza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZD0KzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:55:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57269 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZD0KzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:55:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 10/30] microblaze_mmu_v1: Context handling - mmu_context.c/h
Date: Mon, 27 Apr 2009 12:55:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <1240821139-7247-10-git-send-email-monstr@monstr.eu> <1240821139-7247-11-git-send-email-monstr@monstr.eu>
In-Reply-To: <1240821139-7247-11-git-send-email-monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904271255.08500.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19qWQYBDumARo/iKopUIJa2URKg2ksOC8VOlhU
 ZgmAPkf5Gq0L7ETcDyErGH2/fCRdpC4GEJf7rEZD26Jr11Ozon
 kDjyai+cIAp60wGPscFWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, monstr@monstr.eu wrote:
>  arch/microblaze/include/asm/mmu_context.h |  134 +++++++++++++++++++++++++++++
>  arch/microblaze/mm/mmu_context.c          |   70 +++++++++++++++
>  2 files changed, 204 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/mm/mmu_context.c
> 

Your mmu_context.h is basically

#ifdef CONFIG_MMU
 /* MMU code */
#else
 /* NOMMU code */
#endif

but doesn't have any shared code at all. In cases like this, I'd
recommend having three separate files as m68k does: mmu_context_no.h
mmu_context_mm.h and mmu_context.h that has a simple switch between
them.

	Arnd <><
