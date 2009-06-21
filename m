Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbZFULg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbZFULg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZFULgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:36:21 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:13376 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbZFULgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:36:21 -0400
X-Trace: 214880603/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.36.136/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.36.136
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiUFAIe3PUpPRSSI/2dsb2JhbACBUcpmhAoF
X-IronPort-AV: E=Sophos;i="4.42,262,1243810800"; 
   d="scan'208";a="214880603"
Date: Sun, 21 Jun 2009 12:36:22 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrey Borzenkov <arvidjaar@mail.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: Why half of slabs are not shown in /proc/slabinfo?
In-Reply-To: <200906211152.25100.arvidjaar@mail.ru>
Message-ID: <Pine.LNX.4.64.0906211230590.5000@sister.anvils>
References: <200906211152.25100.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009, Andrey Borzenkov wrote:
> Mandriva kernel 2.6.30 using SLUB:
> 
> {pts/1}% grep SLUB /boot/config
> CONFIG_SLUB_DEBUG=y
> CONFIG_SLUB=y
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> 
> Some of slabs (e.g. filp) are not shown in /proc/slabinfo; comparing 
> number of entries under /sys and slabinfo results in
> 
> {pts/0}% =ls -1 /sys/kernel/slab | grep -v : | wc -l
> 131
> {pts/0}% wc -l /proc/slabinfo
> 68 /proc/slabinfo
> {pts/0}%
> 
> so almost half of the all entries are missing. Is it expected or there 
> is something wrong here?

With SLUB it is expected: unlike SLAB, it merges together caches
of the same size.

"slabinfo -a" (from Documentation/vm/slabinfo.c) should show you
which caches have got aliased together.

It can be quite tiresome if you're doing an investigation:
booting with "slub_nomerge" stops it behaving like that.

Hugh
