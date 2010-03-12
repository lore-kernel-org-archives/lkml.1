Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631Ab0CLVUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:20:38 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56995 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab0CLVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vNp4F3uRN6BF07JLMi4MlOWyf/+0fF+Hkyd1dEcbloo4kNOanXk4BJBKRz4gd05B/2
         4c5rTxpasUamMcP6PN5YdMArfNChtd34vMpmEYrIID6jU0hdGC+94adGbaTIS5IRe6y3
         iygMq7STeq6DqF4ink9BEY4Jt/Ev+3mImJbds=
Date: Fri, 12 Mar 2010 13:20:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] enhance sysfs rfkill interface
Message-ID: <20100312212025.GA17712@core.coreip.homeip.net>
References: <1268416988-24862-1-git-send-email-florian@mickler.org>
 <1268416988-24862-2-git-send-email-florian@mickler.org>
 <1268416988-24862-3-git-send-email-florian@mickler.org>
 <20100312182209.GB8736@core.coreip.homeip.net>
 <20100312215743.7671d173@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100312215743.7671d173@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 09:57:43PM +0100, Florian Mickler wrote:
> On Fri, 12 Mar 2010 10:22:09 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Fri, Mar 12, 2010 at 07:03:08PM +0100, florian@mickler.org wrote:
> > >  
> > > +static ssize_t rfkill_hard_show(struct device *dev,
> > > +				 struct device_attribute *attr,
> > > +				 char *buf)
> > > +{
> > > +	struct rfkill *rfkill = to_rfkill(dev);
> > > +	unsigned long flags;
> > > +	u32 state;
> > > +
> > > +	spin_lock_irqsave(&rfkill->lock, flags);
> > > +	state = rfkill->state;
> > > +	spin_unlock_irqrestore(&rfkill->lock, flags);
> > 
> > Why exactly is this lock needed?
> 
> The rfkill state is updated from multiple contexts... Am I overlooking
> smth obvious here?
> 

You are not updating but reading... Are you concerned about seeing
a partial write to u32? It does not happen.

-- 
Dmitry
