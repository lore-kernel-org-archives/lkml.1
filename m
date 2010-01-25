Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077Ab0AYAfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0AYAfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 19:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881Ab0AYAft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 19:35:49 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38914 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0AYAft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 19:35:49 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC,PATCH 3/7 v2] arm/versatile: use generic struct clk
Date: Mon, 25 Jan 2010 11:35:41 +1100
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
References: <1263279511.160127.576969496193.0.gpush@pororo> <1263279511.161193.484965724912.3.gpush@pororo> <20100112162539.GH27771@n2100.arm.linux.org.uk>
In-Reply-To: <20100112162539.GH27771@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001251135.41611.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> This doesn't make any sense.  What are you trying to do here?
> 
> The get/put operations go together as one logical set - that's why you
> get both if you're using clkdev, and why you're asked to implement both
> __clk_get() and __clk_put() in arch code to do whatever's necessary
> with the clock.

I'm assuming that clk_put will be specific to the implementation; fixed clocks 
probably won't need to do anything, but others may need a refcount, etc.

We don't have a struct clk to use clk_get on, so it remains a non-clock-
specific function.

We'll probably need the symmetry for some cases though, I think that a 
__clk_get(struct clk *) member of clk_operations would work for this, to be 
called by clk_get.

Cheers,


Jeremy
