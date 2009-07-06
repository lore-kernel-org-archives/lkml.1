Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbZGFI0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbZGFI0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbZGFI0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:26:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZGFI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:26:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/5] sparc: use asm-generic/dma-mapping-common.h
Date: Mon, 6 Jul 2009 10:26:28 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-9-generic; KDE/4.2.95; x86_64; ; )
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, reif@earthlink.net
References: <1246860820-20629-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1246860820-20629-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1246860820-20629-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907061026.28878.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX192dS9mKdNdjEWCH2VSs/NXUj9LcDEyNZLtmQl
 RIiTCpklySRjX61cBH1QhyL/xotp4a2XWFssW4BVcW8o4tiJel
 UJq8FN3zWx1XaQyOKS7EgY2nKH/EJZ1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009, FUJITA Tomonori wrote:
> +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> +{
> +       return dma_ops;
> +}
> +
> +#define flush_write_buffers()
> +
> +#include <asm-generic/dma-mapping-common.h>

I still think the flush_write_buffers() x86-ism should not be required
to use dma-mapping-common.h and only be used in arch/x86/kernel/pci-nommu.c
so you don't have to add dummy definitions to all architectures.

See http://lkml.org/lkml/2009/6/30/134

Otherwise, your series looks good!

	Arnd <><
