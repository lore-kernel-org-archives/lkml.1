Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZCaKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZCaKwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZCaKvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:51:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988AbZCaKvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:51:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <kpc.mtd@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] MTD: New ioctl calls for >4GiB device support
Date: Tue, 31 Mar 2009 12:51:03 +0200
User-Agent: KMail/1.9.9
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org
References: <a95a62fe0903301814k75ce56f5xef0a04c5c188012@mail.gmail.com>
In-Reply-To: <a95a62fe0903301814k75ce56f5xef0a04c5c188012@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903311251.04746.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/BshC5GtPiSOkKGaro0byLGIWVJGqZWMLU64F
 /LWd92d12xI4Bht+uHDZD8Nh21fSflD8zdkHYLkPzG0LL9LlRc
 QSnvCv75aSZ7BjZQOC7dg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Kevin Cernekee wrote:
> +struct mtd_oob_buf64 {
> +       uint64_t start;
> +       uint32_t res0;
> +       uint32_t length;
> +       unsigned char __user *ptr;
> +       uint32_t res1[8];
> +};

Does this have to use an indirect pointer? We normally try to avoid
ioctl interfaces like this, because they are hard to trace and you
need a compat wrapper. You might be able to at least avoid the wrapper
by defining the data structure with a __u64 to take the pointer.

If you leave the data structure the way it is, you should at least
move the compat_ioctl handling into mtdchar.c from compat_ioctl.c.
It will simplify your code and help reduce the size of the common
ioctl handling.

	Arnd <><
