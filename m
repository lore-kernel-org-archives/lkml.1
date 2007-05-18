Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbXERE2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbXERE2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 00:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbXERE1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 00:27:55 -0400
Received: from mx1.suse.de ([195.135.220.2]:54746 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106AbXERE1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 00:27:54 -0400
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] INPUT: Sanitize PIT locking in pcspkr
Date: Fri, 18 May 2007 06:27:00 +0200
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Richard Henderson <rth@twiddle.net>
References: <1179408962.3764.72.camel@chaos> <d120d5000705170736q4e9eb5d4jab82732e01e377c@mail.gmail.com> <1179413375.3764.86.camel@chaos>
In-Reply-To: <1179413375.3764.86.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705180627.01224.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007 16:49, Thomas Gleixner wrote:

> Both read the PIT directly, which will lead to interesting results. The
> PIT is either stopped or it can be used in one shot mode with per event
> changing intervals due to the changes introduced by the clock events
> layer.
>
> This code should use ktime_get() and not fiddle in the hardware itself.

The gameport code also does TSC accesses directly which is similarly
broken. I remember complaining about that some time ago, but it never
got fixed in the end.

-Andi
