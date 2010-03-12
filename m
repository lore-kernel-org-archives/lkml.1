Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0CLWjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:39:43 -0500
Received: from ist.d-labs.de ([213.239.218.44]:52091 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab0CLWjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:39:41 -0500
Date: Fri, 12 Mar 2010 23:39:25 +0100
From: Florian Mickler <florian@mickler.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] enhance sysfs rfkill interface
Message-ID: <20100312233925.74effc7d@schatten.dmk.lab>
In-Reply-To: <20100312212025.GA17712@core.coreip.homeip.net>
References: <1268416988-24862-1-git-send-email-florian@mickler.org>
	<1268416988-24862-2-git-send-email-florian@mickler.org>
	<1268416988-24862-3-git-send-email-florian@mickler.org>
	<20100312182209.GB8736@core.coreip.homeip.net>
	<20100312215743.7671d173@schatten.dmk.lab>
	<20100312212025.GA17712@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 13:20:26 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Fri, Mar 12, 2010 at 09:57:43PM +0100, Florian Mickler wrote:
> > On Fri, 12 Mar 2010 10:22:09 -0800
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > On Fri, Mar 12, 2010 at 07:03:08PM +0100, florian@mickler.org wrote:
> > > >  
> > > > +static ssize_t rfkill_hard_show(struct device *dev,
> > > > +				 struct device_attribute *attr,
> > > > +				 char *buf)
> > > > +{
> > > > +	struct rfkill *rfkill = to_rfkill(dev);
> > > > +	unsigned long flags;
> > > > +	u32 state;
> > > > +
> > > > +	spin_lock_irqsave(&rfkill->lock, flags);
> > > > +	state = rfkill->state;
> > > > +	spin_unlock_irqrestore(&rfkill->lock, flags);
> > > 
> > > Why exactly is this lock needed?
> > 
> > The rfkill state is updated from multiple contexts... Am I overlooking
> > smth obvious here?
> > 
> 
> You are not updating but reading... Are you concerned about seeing
> a partial write to u32? It does not happen.
> 
Hm.. You shure? On every arch that supports wireless drivers? 

I've just copied that code from the old sysfs state-file handler.
So I assumed that reading partial updated state can happen... Also I
just searched a little but did not find anything, cause i didn't know
where to look. Who garantees this? Is it a gcc thing? 

