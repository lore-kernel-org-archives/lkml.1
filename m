Return-Path: <linux-kernel-owner+w=401wt.eu-S934265AbZLPAJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934265AbZLPAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934233AbZLPAJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:09:23 -0500
Received: from www.tglx.de ([62.245.132.106]:50260 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934136AbZLPAJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:09:21 -0500
Date: Wed, 16 Dec 2009 01:09:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: Keith Mannthey <kmannth@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
In-Reply-To: <20091215164950.1fd41caf@bike.lwn.net>
Message-ID: <alpine.LFD.2.00.0912160105510.2755@localhost.localdomain>
References: <1260907788.6521.10.camel@keith-laptop> <20091215164950.1fd41caf@bike.lwn.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, Jonathan Corbet wrote:
> On Tue, 15 Dec 2009 12:09:48 -0800
> Keith Mannthey <kmannth@us.ibm.com> wrote:
>
> > +#include <linux/sysdev.h>
> > +#include <asm/byteorder.h>
> > +#include "rtl.h"
> > +
> > +static spinlock_t rtl_lock;
> 
> You should probably include <linux/spinlock.h> for this.

And use:

DEFINE_SPINLOCK(rtl_lock);

because the lock is uninitialized otherwise. Running that code with
lockdep would have warned about that.

Thanks,

	tglx
