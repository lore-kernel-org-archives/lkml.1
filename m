Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZIHSOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZIHSOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZIHSOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:14:12 -0400
Received: from kroah.org ([198.145.64.141]:36915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZIHSOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:14:11 -0400
Date: Tue, 8 Sep 2009 11:11:09 -0700
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RT + staging] buildfailures
Message-ID: <20090908181109.GB21413@kroah.com>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20090614112802.GA4502@kroah.com>
 <20090614230044.GA21624@pengutronix.de>
 <20090622151515.GA16627@pengutronix.de>
 <20090907162029.GA855@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090907162029.GA855@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 06:20:29PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> I just tried to compile 2.6.31-rc8-rt9 on amd64 and got the following
> compiler errors in drivers/staging:
> 
>  - drivers/staging/comedi:
> 
> 	  CC [M]  drivers/staging/comedi/drivers/quatech_daqp_cs.o
> 	drivers/staging/comedi/drivers/quatech_daqp_cs.c: In function ‘daqp_interrupt’:
> 	drivers/staging/comedi/drivers/quatech_daqp_cs.c:308: error: implicit declaration of function ‘up’
> 	drivers/staging/comedi/drivers/quatech_daqp_cs.c: In function ‘daqp_ai_insn_read’:
> 	drivers/staging/comedi/drivers/quatech_daqp_cs.c:421: error: implicit declaration of function ‘sema_init’
> 	drivers/staging/comedi/drivers/quatech_daqp_cs.c:434: error: implicit declaration of function ‘down_interruptible’
> 
>    Possible fix: #include <linux/semaphore.h> in
>    drivers/staging/comedi/comedidev.h

Patches welcome :)

>  - drivers/staging/rt2870:
> 	  CC [M]  drivers/staging/rt2870/common/2870_rtmp_init.o
> 	drivers/staging/rt2870/common/2870_rtmp_init.c: In function ‘CreateThreads’:
> 	drivers/staging/rt2870/common/2870_rtmp_init.c:754: error: implicit declaration of function ‘semaphore_init_locked’
> 
>    with PREEMPT_RT semaphore_init_locked doesn't exist.  The driver
>    needs to be converted to use mutexes instead.
> 
>    Hhhhm, tglx introduced these in
> 
> 	041e313 (staging: Bulk convert the semaphore mess)
> 
>    !?
> 
>    drivers/staging/rt3070/common/2870_rtmp_init.c includes
>    ../../rt2870/common/2870_rtmp_init.c, so RT3070 has the same problem.

Then he might want to resolve them, as this code has changed a _lot_ in
the linux-next tree :)

thanks,

greg k-h
