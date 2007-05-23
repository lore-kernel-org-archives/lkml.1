Return-Path: <linux-kernel-owner+w=401wt.eu-S934346AbXEWN5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346AbXEWN5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 09:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbXEWN5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 09:57:06 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:60544
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757348AbXEWN5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 09:57:04 -0400
Date: Wed, 23 May 2007 15:59:11 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Simon Arlott <simon@fire.lp0.eu>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix unchecked mutex_lock_interruptible (was Re: use mutex instead of semaphore in RocketPort driver)
Message-ID: <20070523135911.GC31790@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Satyam Sharma <satyam.sharma@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, Simon Arlott <simon@fire.lp0.eu>,
	Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <a781481a0705230555j6fcf46eav43cc95f6d1a7ae6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705230555j6fcf46eav43cc95f6d1a7ae6f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, May 23, 2007 at 06:25:49PM +0530 Satyam Sharma ha dit:

> On 5/23/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> >Simon Arlott napsal(a):
> >> On 22/05/07 21:06, Matthias Kaehlcke wrote:
> >>> would the following resolve the problem?
> >>>
> >>> if(mutex_lock_interruptible(&info->write_mtx))         return
> >>> -ERESTARTSYS
> >>>
> >>> thanks for your comments
> 
> Hum. I remember suggesting the fix when this came few weeks back,
> somehow the older version seems to have made it into Linus' tree.

i also remembered your suggestion but thought it was a similar case in
another driver. i think it's my fault that the older version made it
into the Linus tree cause i sent the patch in a new thread instead of
responding to the initial post :(
 
> >> No. At least one user of tty_operations/tty_driver's write function
> >> doesn't check the return value so it would never be retried, mutex_lock
> >> should be used instead.
> 
> Replacing mutex_lock_interruptible() with a mutex_lock() could be a
> change in behaviour visible to userspace. Best to continue to use
> _interruptible. Returning EINTR would be safe choice because if
> Simon's right that this isn't retried, we could end up breaking
> userspace that isn't quite ready to see ERESTARTSYS coming out of
> a write(2), but ...

thanks for your fix!

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

       The yellow ships hung in the air just like bricks dont do
                 (The Hitch-Hiker's Guide to the Galaxy)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
