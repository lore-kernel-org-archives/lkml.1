Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYCZQGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYCZQGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYCZQG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:06:27 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:42468 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752424AbYCZQG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:06:26 -0400
Date: Wed, 26 Mar 2008 17:04:41 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hskinnemoen@atmel.com, domen.puncer@telargo.com, lethal@linux-sh.org,
       tony@atomide.com, rmk+kernel@arm.linux.org.uk, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080326155203.GA15405@doriath.ww600.siemens.net>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	<20080326155203.GA15405@doriath.ww600.siemens.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2008 16:04:42.0136 (UTC) FILETIME=[1A048980:01C88F5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 18:52:03 +0300
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> +struct clk {
> +	struct list_head node;
> +	struct clk	*parent;
> +
> +	const char	*name;
> +	struct module	*owner;
> +
> +	int		users;
> +	unsigned long	rate;
> +	int		delay;
> +
> +	int (*can_get)	(struct clk *, struct device *);
> +	int (*set_parent) (struct clk *, struct clk *);
> +	int (*enable)	(struct clk *);
> +	void (*disable)	(struct clk *);
> +	unsigned long (*getrate) (struct clk*);
> +	int (*setrate)	(struct clk *, unsigned long);
> +	long (*roundrate) (struct clk *, unsigned long);
> +
> +	void		*priv;
> +};

Hmm...this is exactly twice as big as the struct I'm currently using,
it doesn't contain all the fields I need, and it's undocumented.

I have quite a few clocks, so the increased memory consumption is quite
significant. What are the advantages of this?

Haavard
