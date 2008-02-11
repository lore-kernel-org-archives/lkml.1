Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYBKTCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYBKTCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYBKTCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:02:48 -0500
Received: from waste.org ([66.93.16.53]:47931 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbYBKTCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:02:47 -0500
Subject: Re: [PATCH] Configure out DMI scanning code
From: Matt Mackall <mpm@selenic.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080211175844.3358a49b@crazy>
References: <20080211175844.3358a49b@crazy>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 13:01:18 -0600
Message-Id: <1202756478.28085.35.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 17:58 +0100, Thomas Petazzoni wrote:
> Hi,
> 
> The enclosed patch allows to remove the DMI scanning code when
> CONFIG_EMBEDDED is defined. It's basically the dma_blacklist patch of
> Linux-Tiny ported to 2.6.25-rc1, with the required modifications. It
> allows to remove ~10k from the kernel code/data size.

Looks ok. Please preserve original authorship (ie me) in some fashion in
your description.

> On top of this patch, I've tested if removing the big dmi tables in the
> code (for example in arch/x86/kernel/reboot.c) would allow to make more
> space optimizations. However, it seems that simply defining
> dmi_check_system() to an empty static inlined function already allows
> gcc to optimize out the dmi tables, because there are not present in
> the code. Is that possible, or is my understanding incorrect ?

That's possible with modern gccs, yes.

-- 
Mathematics is the supreme nostalgia of our time.

