Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbYCDGn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbYCDGn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYCDGnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:43:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbYCDGnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:43:16 -0500
Date: Mon, 3 Mar 2008 22:42:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
Message-Id: <20080303224231.86c22ed0.akpm@linux-foundation.org>
In-Reply-To: <20080303121335.GA15381@elte.hu>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi>
	<47C99FE1.8080206@gmail.com>
	<20080301183550.GC25835@cs181133002.pp.htv.fi>
	<20080303085720.GD15943@elte.hu>
	<20080303091314.GC4457@cs181133002.pp.htv.fi>
	<20080303091714.GA18250@elte.hu>
	<20080303093103.GA23651@uranus.ravnborg.org>
	<20080303103933.GC21190@elte.hu>
	<20080303113451.GF4457@cs181133002.pp.htv.fi>
	<20080303114533.GA4183@elte.hu>
	<20080303121335.GA15381@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 13:13:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> +config OPTIMIZE_INLINING
> +	bool "Allow gcc to uninline functions marked 'inline'"
> +	default y
> +	help
> +	  This option determines if the kernel forces gcc to inline the functions
> +	  developers have marked 'inline'. Doing so takes away freedom from gcc to
> +	  do what it thinks is best, which is desirable for the gcc 3.x series of
> +	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
> +	  disabling this option will generate a smaller kernel there. Hopefully
> +	  this algorithm is so good that allowing gcc4 to make the decision can
> +	  become the default in the future, until then this option is there to
> +	  test gcc for this.

urgh.  This will cause whatever problem
4507a6a59cfc6997e532cd812a8bd244181e6205 fixed five years ago to resurface
for incautious gcc-3.x users.

I'd suggest that this

> +#ifndef CONFIG_OPTIMIZE_INLINING

become something along the lines of

> +#ifndef CONFIG_OPTIMIZE_INLINING && (__GNUC__ > 3)

It would be nice to be able to feed the gcc version into the Kconfig logic,
really..

