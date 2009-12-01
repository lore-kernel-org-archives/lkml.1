Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZLARqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZLARqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZLARqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:46:20 -0500
Received: from mail.perches.com ([173.55.12.10]:1209 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbZLARqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:46:20 -0500
Subject: Re: [PATCH] drivers/block/floppy.c: stylistic cleanups
From: Joe Perches <joe@perches.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091201173635.GB2688@joi.lan>
References: <1259001504.16503.79.camel@Joe-Laptop.home>
	 <20091123.104130.117837098.davem@davemloft.net>
	 <1259528449.29779.194.camel@Joe-Laptop.home>
	 <20091129.165557.84377714.davem@davemloft.net>
	 <20091130092837.4998f961@nehalam>
	 <1259640820.13592.37.camel@Joe-Laptop.home> <20091201173635.GB2688@joi.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 09:46:25 -0800
Message-ID: <1259689585.21388.32.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 18:36 +0100, Marcin Slusarz wrote: 
> On Mon, Nov 30, 2009 at 08:13:40PM -0800, Joe Perches wrote:
> > +#define CALL(x)		do { if ((x) == -EINTR) return -EINTR; } while (0)
> > +#define ECALL(x)	do { if ((ret = (x))) return ret; } while (0)
> > +#define _WAIT(x, i)	CALL(ret = wait_til_done((x), i))
> > +#define WAIT(x)		_WAIT((x), interruptible)
> > +#define IWAIT(x)	_WAIT((x), 1)
> 
> why not remove these macros too? (probably in a seperate patch)
> macros which hide "return" are very annoying...

Hence the "still ugly".  I agree these aren't good.

> > +#define LOCK_FDC(drive, interruptible)	    \
> > +	if (lock_fdc(drive, interruptible)) \
> > +		return -EINTR;
> 
> another annoying macro

True. 
  
> > +	if (UNIT(current_drive) < 0) {
> > +		reset_fdc();
> > +		return;
> > +	}
> >  }
> 
> unneeded return

> >  	 * installing the new fdutils package */
> > -	if (cmd == CDROMEJECT ||	/* CD-ROM eject */
> > -	    cmd == 0x6470 /* SunOS floppy eject */ ) {
> > +	if (cmd == CDROMEJECT || cmd == 0x6470) {
> 
> please add descriptive constant

Patches are apparently welcomed by Stephen.
Don't wait for me, I'll catch up.

cheers, Joe

