Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXLDWbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXLDWbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbXLDWbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:31:35 -0500
Received: from mx1.riseup.net ([204.13.164.18]:60284 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbXLDWbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:31:34 -0500
Date: Tue, 4 Dec 2007 23:31:51 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: gregkh@suse.de, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: [PATCH] USB testing driver: convert dev->sem to mutex
Message-ID: <20071204223151.GB480@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Daniel Walker <dwalker@mvista.com>, gregkh@suse.de,
	linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <20071204165540.GH6729@traven> <1196795342.1568.41.camel@jnielson-xp.ddns.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196795342.1568.41.camel@jnielson-xp.ddns.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, Dec 04, 2007 at 11:09:02AM -0800 Daniel Walker ha dit:

> On Tue, 2007-12-04 at 17:55 +0100, Matthias Kaehlcke wrote:
> > @@ -1990,7 +1991,7 @@ static void usbtest_disconnect (struct
> > usb_interface *intf)
> >  {
> >         struct usbtest_dev      *dev = usb_get_intfdata (intf);
> >  
> > -       down (&dev->sem);
> > +       mutex_lock(&dev->lock);
> >  
> >         usb_set_intfdata (intf, NULL);
> >         dev_dbg (&intf->dev, "disconnect\n"); 
> 
> This looks like a bit of an anomaly.. The code that isn't shown above is
> the "kfree(dev)" .. So this isn't legal since it's freeing a locked
> mutex. Here's a excerpt from the comment above mutex_lock(),
> 
>  * The mutex must later on be released by the same task that
>  * acquired it. Recursive locking is not allowed. The task
>  * may not exit without first unlocking the mutex. Also, kernel
>  * memory where the mutex resides mutex must not be freed with
>  * the mutex still locked. The mutex must first be initialized
>  * (or statically defined) before it can be locked. memset()-ing
>  * the mutex to 0 is not allowed.

you're absolutely right that freeing a locked mutex isn't a good idea

thanks for pointing it out!

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
