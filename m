Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZGVQob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZGVQob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZGVQoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:44:30 -0400
Received: from www.tglx.de ([62.245.132.106]:40866 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZGVQo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:44:29 -0400
Date: Wed, 22 Jul 2009 18:43:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
In-Reply-To: <200907220939.33399.david-b@pacbell.net>
Message-ID: <alpine.LFD.2.00.0907221841340.2813@localhost.localdomain>
References: <20090714100634.GA4054@elf.ucw.cz> <20090721160436.GD4352@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain> <200907220939.33399.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, David Brownell wrote:
> On Tuesday 21 July 2009, Thomas Gleixner wrote:
> 
> Interesting.  The model is then to switch over to __set_irq_handler(),
> or maybe set_irq_chip_and_handler(), to replace the toplevel dispatch
> code for will-be-threaded IRQs which happen to be hooked up to inputs
> that don't sense edges.  (Agree, that seems like a goof.  But hardware
> designers sometimes have any choices there.)
> 
> The normal model is that boards don't get involved with that level of
> logic ... all IRQs get set up once on generic code, and flow handlers
> don't change.  Or if they do change, it's done when changing the IRQ's
> trigger mode from edge to level, or vice versa.
> 
> Can that be cleaned up a bit, so that the handle_level_oneshot_irq()
> and unmask_oneshot_irq() stuff kicks in automatically when needed,
> instead of requiring board-specific (or driver-specific) code to get
> that stuff right?

The only way I can see is to set a special trigger flag like
IRQF_TRIGGER_RISING & Co. 

i.e. IRQF_TRIGGER_LEVEL | IRQF_TRIGGER_ONESHOT

That might work.

Thanks,

	tglx
