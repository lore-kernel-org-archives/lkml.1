Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbYC1UJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbYC1UJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYC1UIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:08:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1322 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753938AbYC1UIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:08:39 -0400
Date: Fri, 28 Mar 2008 15:23:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, lethal@linux-sh.org, tony@atomide.com,
       rmk+kernel@arm.linux.org.uk, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Message-ID: <20080328142340.GE4404@ucw.cz>
References: <20080326154913.GA15326@doriath.ww600.siemens.net> <20080326155203.GA15405@doriath.ww600.siemens.net> <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-26 17:04:41, Haavard Skinnemoen wrote:
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

Like unifying 15-or-so versions of clock framework that are out there?

> I have quite a few clocks, so the increased memory consumption is quite
> significant. What are the advantages of this?

How many clocks do you have?



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
