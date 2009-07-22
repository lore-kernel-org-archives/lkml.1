Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZGVQuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZGVQuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZGVQup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:50:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49978 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753576AbZGVQuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:50:44 -0400
Date: Wed, 22 Jul 2009 17:50:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090722165042.GA21186@rakim.wolfsonmicro.main>
References: <20090714100634.GA4054@elf.ucw.cz>
 <20090721160436.GD4352@dtor-d630.eng.vmware.com>
 <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
 <200907220939.33399.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907220939.33399.david-b@pacbell.net>
X-Cookie: Sign here without admitting guilt.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:39:32AM -0700, David Brownell wrote:

> The normal model is that boards don't get involved with that level of
> logic ... all IRQs get set up once on generic code, and flow handlers
> don't change.  Or if they do change, it's done when changing the IRQ's
> trigger mode from edge to level, or vice versa.

> Can that be cleaned up a bit, so that the handle_level_oneshot_irq()
> and unmask_oneshot_irq() stuff kicks in automatically when needed,
> instead of requiring board-specific (or driver-specific) code to get
> that stuff right?

Thomas was reluctant to do that but up till now every single user has
been asking for it.  A flag in the driver requesting the behaviour
sounds OK to me, there are devices that can use threaded IRQs while
interacting with the device in the primary handler NAPI style.
