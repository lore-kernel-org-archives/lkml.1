Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYCZQPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYCZQPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYCZQPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:15:42 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:26465 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752625AbYCZQPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:15:41 -0400
Date: Thu, 27 Mar 2008 01:14:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, tony@atomide.com, rmk+kernel@arm.linux.org.uk,
       paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Message-ID: <20080326161456.GA12490@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	hskinnemoen@atmel.com, domen.puncer@telargo.com, tony@atomide.com,
	rmk+kernel@arm.linux.org.uk, paul@pwsan.com
References: <20080326154913.GA15326@doriath.ww600.siemens.net> <20080326155203.GA15405@doriath.ww600.siemens.net> <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 05:04:41PM +0100, Haavard Skinnemoen wrote:
> On Wed, 26 Mar 2008 18:52:03 +0300
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
> > +struct clk {
> > +	struct list_head node;
> > +	struct clk	*parent;
> > +
> > +	const char	*name;
> > +	struct module	*owner;
> > +
> > +	int		users;
> > +	unsigned long	rate;
> > +	int		delay;
> > +
> > +	int (*can_get)	(struct clk *, struct device *);
> > +	int (*set_parent) (struct clk *, struct clk *);
> > +	int (*enable)	(struct clk *);
> > +	void (*disable)	(struct clk *);
> > +	unsigned long (*getrate) (struct clk*);
> > +	int (*setrate)	(struct clk *, unsigned long);
> > +	long (*roundrate) (struct clk *, unsigned long);
> > +
> > +	void		*priv;
> > +};
> 
> Hmm...this is exactly twice as big as the struct I'm currently using,
> it doesn't contain all the fields I need, and it's undocumented.
> 
Conversely it also has fields that I don't need. If struct clk could have
been done generically without growing to insane sizes, it would have been
done so in linux/clk.h a long time ago. The main thing there is API
consistency for drivers, leaving the details up to the architecture.

It's true that there is significant overlap between the different users
of the clock framework, but it's also not clear that there's any clean
way to share a common implementation (especially since struct clk means
totally different things on different architectures). I suspect everyone
in the CC list has been through this before, also.
