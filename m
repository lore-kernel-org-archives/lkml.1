Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYDJOI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYDJOI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbYDJOIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:08:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:50694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYDJOIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:08:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: joern@logfs.org
Subject: Re: [patch 10/15] fs/logfs/memtree.c
Date: Thu, 10 Apr 2008 16:07:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
References: <20080401181308.512473173@logfs.org> <20080401181332.853833010@logfs.org>
In-Reply-To: <20080401181332.853833010@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804101607.45409.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19PBWIzHVu/cncqtr/HwZxKt/OMQqFJEtS1Cqm
 WJkpt1efb3GjNPghz+PIcp65l0emIS42cZoNT4aqqwfSeV7BAV
 1Hzalu/bEfP8af/YG3Ynw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008, joern@logfs.org wrote:
> +#if BITS_PER_LONG == 32
> +#define BTREE_NODES 20 /* 32bit, 240 byte nodes */
> +#else
> +#define BTREE_NODES 16 /* 64bit, 256 byte nodes */
> +#endif
> +
> +struct btree_node {
> +       u64 key;
> +       struct btree_node *node;
> +};

On 32 bit platforms other than x86, your struct btree_node
is 16 bytes long because of alignment requirements, rather
than the 12 bytes you are assuming.

	Arnd <><
