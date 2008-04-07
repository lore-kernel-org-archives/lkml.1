Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbYDGW5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbYDGW5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYDGW47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:56:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324AbYDGW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:56:58 -0400
Date: Mon, 7 Apr 2008 15:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 1/6] Clocklib: add generic framework for managing
 clocks.
Message-Id: <20080407155559.cf7e2d24.akpm@linux-foundation.org>
In-Reply-To: <20080403132329.GA26971@doriath.ww600.siemens.net>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	<20080403132329.GA26971@doriath.ww600.siemens.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 17:23:29 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Provide a generic framework that platform may choose
> to support clocks api. In particular this provides
> platform-independant struct clk definition, a full
> implementation of clocks api and a set of functions
> for registering and unregistering clocks in a safe way.
> 
> +static void __maybe_unused clks_unregister(struct clk **clks, size_t num)
> +static int __must_check __maybe_unused clks_register(struct clk **clks, size_t num)
> +static void __maybe_unused clk_free_functions(
> +		struct clk_function *funcs,
> +		int num)
> +static int __must_check __maybe_unused clk_alloc_functions(
> +		struct clk_function *funcs,
> +		int num)

What are all these __maybe_unused markers doing here?

> ...
>
> +int __must_check clk_alloc_function(const char *parent, struct clk *clk);

This should be `static int'.  I'm surprised the compiler doesn't get
upset.

> +	for (i = num - 1; i >= 0; i--) {
> +		clk_unregister(&funcs[i].clk);
> +	}
>
> ...
>
> +	if (rc) {
> +		kfree(clk);
> +	}

There are a few coding-style glitches in here.  Please run
scripts/checkpatch.pl and consider its reportage.

