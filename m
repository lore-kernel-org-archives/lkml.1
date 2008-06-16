Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbYFPFfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbYFPFfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 01:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYFPFfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 01:35:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:18380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYFPFfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 01:35:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,650,1204531200"; 
   d="scan'208";a="260910584"
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high
	pages init
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440806152046s71916de8g6f8e3e8d272d336a@mail.gmail.com>
References: <200806132005.45836.yhlu.kernel@gmail.com>
	 <200806140056.32601.yhlu.kernel@gmail.com> <20080614082343.GB11277@elte.hu>
	 <86802c440806140205g3ff113ffq39272c18ef5b9654@mail.gmail.com>
	 <1213579241.2433.7.camel@caritas-dev.intel.com>
	 <86802c440806152046s71916de8g6f8e3e8d272d336a@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 13:37:49 +0800
Message-Id: <1213594669.10376.19.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 05:34:52.0089 (UTC) FILETIME=[B3447A90:01C8CF72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-15 at 20:46 -0700, Yinghai Lu wrote:
[...]
> don't need,
> EFI memmap should be reserved in e820map, so it should not show up in
> early_node_map.

I don't think so. EFI memmap comes from boot-loader not from BIOS. It
contains boot-loader execution information (such as EfiLoaderCode,
EfiLoaderData, etc), and it will be located at different position for
each system reboot.

If it is reserved in E820 memmap, hibernation can not work. Because the
memory area for EFI memmap is not E820 RAM, it is not saved during
hibernating and restored after restoring from disk.

Linked list of struct setup_data has similar requirement too.

Best Regards,
Huang Ying

