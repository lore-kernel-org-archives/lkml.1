Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbYAOMna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbYAOMna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYAOMnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:43:23 -0500
Received: from mail.suse.de ([195.135.220.2]:56350 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYAOMnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:43:22 -0500
From: Andi Kleen <ak@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] [0/31] Great change_page_attr patch series v2
Date: Tue, 15 Jan 2008 13:43:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <200801141116.534682000@suse.de> <200801151106.15452.ak@suse.de> <478CAD42.76E4.0078.0@novell.com>
In-Reply-To: <478CAD42.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151343.22152.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >But you're right that would be an useful feature. But wouldn't it require
> >aligning rodata to 2MB in the vmlinux to be really effective?
>
> Yes, that would be desirable then (and .data should be at a 2/4 Mb
> boundary for this, too).

Yes, rather .rodata/.text together and .data/.bss separately 
aligned to 2MB.

But the problem is it would be quite wasteful -- even on a big 
defconfig kernel data+bss is far less than 2MB and with 4MB
pages it would be even worse.

I'm not sure that would be worth the advantage of write protection for non 
debugging kernels and for debugging kernels just using 4K pages is fine.

There's also the issue where to put the initcode/initdata.

-Andi
