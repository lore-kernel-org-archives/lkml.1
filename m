Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZFNUSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZFNUSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZFNURy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:17:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58020 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZFNURx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:17:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 4/4] asm-generic: uaccess: fix access_ok() prototype
Date: Sun, 14 Jun 2009 22:17:50 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org> <1244959204-11269-4-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244959204-11269-4-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906142217.50997.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/jbp+YqG7tEZh81fzB4uO3vmqB7BJVwBW7TlO
 cj8OLnlwTA6PcLNdKhf/uNTSjPzBB7CLsw806Jwev9EI1GhrZM
 BindMwt2xX9mgw+mWi9Gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> @@ -37,14 +37,14 @@ static inline void set_fs(mm_segment_t fs)
>  #define VERIFY_READ    0
>  #define VERIFY_WRITE   1
>  
> -#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
> +#define access_ok(type, addr, size) __access_ok((addr), (size))
>  
>  /*
>   * The architecture should really override this if possible, at least

Upon actually testing this change, it turns out that this causes more
trouble because of having to pass down pointers that may have 'const'
or 'volatile' modifiers. I'm sure there is a way to do this correctly,
but most architectures seem to cope well with 'unsigned long' here,
and your patch 3/4 solves the original problem nicely.

	Arnd <><
