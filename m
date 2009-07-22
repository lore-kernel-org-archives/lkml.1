Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZGVQlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZGVQlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbZGVQlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:41:21 -0400
Received: from www.tglx.de ([62.245.132.106]:38241 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZGVQlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:41:20 -0400
Date: Wed, 22 Jul 2009 18:40:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
In-Reply-To: <20090722155811.GA2775@dtor-d630.eng.vmware.com>
Message-ID: <alpine.LFD.2.00.0907221830410.2813@localhost.localdomain>
References: <20090721113642.GC13286@sirena.org.uk> <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com> <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com> <20090721124933.GA5668@rakim.wolfsonmicro.main> <20090721160436.GD4352@dtor-d630.eng.vmware.com>
 <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain> <20090721222547.GA1948@opensource.wolfsonmicro.com> <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain> <20090722121800.GD21171@rakim.wolfsonmicro.main> <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
 <20090722155811.GA2775@dtor-d630.eng.vmware.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, Dmitry Torokhov wrote:
> > I don't think it belongs into the driver code. It belongs into the
> > platform code which sets up the system and knows what's on which
> > interrupt line.
> >  
> 
> I do think this should be set up by the driver - the platform/arch code
> can't be 100% certain what model of servicing interrupts driver will
> chose, nor the driver can know whether arch code set things up for
> threaded or classic interrupt handling.
> 
> Since handle_level_oneshot_irq requires drivers to use threaded IRQ
> model (in absence of thread interrupt will never be unmasked) it would
> be better if we did set it up automatically, right there in
> request_threaded_irq(). This would reduce maintenance issues between
> platform and driver code.

No, it's the wrong way round. 

The platform code sets up the platform devices. So there is no real
good reason that the platform code does not know about the details.

If it conveys the wrong irq number then it wont work, if it sets the
wrong handler it wont work either. So what ?

If the driver is implemented to use a threaded handler, which it
better is no matter what as it uses a bus, and the interrupt
controller logic is proper implemented as well then the driver does
not care about those details at all. It will magically work with any
interrupt controller you put in front of it.

If the platform maintainer sets the wrong handler or the wrong
platform data then it's not the driver writers problem.

Thanks,

	tglx
