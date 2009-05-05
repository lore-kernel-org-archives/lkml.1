Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZEEGGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZEEGGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZEEGGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:06:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:48543 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZEEGGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:06:23 -0400
Date: Tue, 5 May 2009 08:05:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, Dave Airlie <airlied@redhat.com>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] i2c: fix bit algorithm timeout for low values.
Message-ID: <20090505080543.50b9e569@hyperion.delvare>
In-Reply-To: <20090504215325.GA31248@kroah.com>
References: <1240528153-5370-1-git-send-email-airlied@gmail.com>
	<20090424114259.70f74ccd@hyperion.delvare>
	<20090504215325.GA31248@kroah.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 4 May 2009 14:53:25 -0700, Greg KH wrote:
> On Fri, Apr 24, 2009 at 11:42:59AM +0200, Jean Delvare wrote:
> > Hi Dave,
> > 
> > On Fri, 24 Apr 2009 09:09:13 +1000, Dave Airlie wrote:
> > > From: Dave Airlie <airlied@redhat.com>
> > > 
> > > When fetching DDC using i2c algo bit, we were often seeing timeouts
> > > before getting valid EDID on a retry. The VESA spec states 2ms is the
> > > DDC timeout, so when this translates into 1 jiffie and we are close
> > > to the end of the time period, it could return with a timeout less than
> > > 2ms.
> > > 
> > > Change this code to use time_after instead of time_after_eq.
> > > 
> > > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > > ---
> > >  drivers/i2c/algos/i2c-algo-bit.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
> > > index d420cc5..e25e139 100644
> > > --- a/drivers/i2c/algos/i2c-algo-bit.c
> > > +++ b/drivers/i2c/algos/i2c-algo-bit.c
> > > @@ -104,7 +104,7 @@ static int sclhi(struct i2c_algo_bit_data *adap)
> > >  		 * chips may hold it low ("clock stretching") while they
> > >  		 * are processing data internally.
> > >  		 */
> > > -		if (time_after_eq(jiffies, start + adap->timeout))
> > > +		if (time_after(jiffies, start + adap->timeout))
> > >  			return -ETIMEDOUT;
> > >  		cond_resched();
> > >  	}
> > 
> > Applied, thanks. I agree this should go in stable.
> 
> I don't see this in Linus's tree anywhere, am I just missing it?

You're correct, it's not there yet, I'll push it to Linus today. Busy
busy busy.

-- 
Jean Delvare
