Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbZEDWFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbZEDWFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZEDWEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:04:47 -0400
Received: from kroah.org ([198.145.64.141]:60297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZEDWEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:04:46 -0400
Date: Mon, 4 May 2009 14:53:25 -0700
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dave Airlie <airlied@gmail.com>, stable@kernel.org,
       Dave Airlie <airlied@redhat.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] i2c: fix bit algorithm timeout for low values.
Message-ID: <20090504215325.GA31248@kroah.com>
References: <1240528153-5370-1-git-send-email-airlied@gmail.com> <20090424114259.70f74ccd@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424114259.70f74ccd@hyperion.delvare>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 11:42:59AM +0200, Jean Delvare wrote:
> Hi Dave,
> 
> On Fri, 24 Apr 2009 09:09:13 +1000, Dave Airlie wrote:
> > From: Dave Airlie <airlied@redhat.com>
> > 
> > When fetching DDC using i2c algo bit, we were often seeing timeouts
> > before getting valid EDID on a retry. The VESA spec states 2ms is the
> > DDC timeout, so when this translates into 1 jiffie and we are close
> > to the end of the time period, it could return with a timeout less than
> > 2ms.
> > 
> > Change this code to use time_after instead of time_after_eq.
> > 
> > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > ---
> >  drivers/i2c/algos/i2c-algo-bit.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
> > index d420cc5..e25e139 100644
> > --- a/drivers/i2c/algos/i2c-algo-bit.c
> > +++ b/drivers/i2c/algos/i2c-algo-bit.c
> > @@ -104,7 +104,7 @@ static int sclhi(struct i2c_algo_bit_data *adap)
> >  		 * chips may hold it low ("clock stretching") while they
> >  		 * are processing data internally.
> >  		 */
> > -		if (time_after_eq(jiffies, start + adap->timeout))
> > +		if (time_after(jiffies, start + adap->timeout))
> >  			return -ETIMEDOUT;
> >  		cond_resched();
> >  	}
> 
> Applied, thanks. I agree this should go in stable.

I don't see this in Linus's tree anywhere, am I just missing it?

thanks,

greg k-h
