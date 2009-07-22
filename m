Return-Path: <linux-kernel-owner+w=401wt.eu-S1751755AbZGVOcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbZGVOcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZGVOcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:32:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59151 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153AbZGVOcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:32:13 -0400
Date: Wed, 22 Jul 2009 15:32:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090722143211.GB29404@rakim.wolfsonmicro.main>
References: <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
 <20090721124933.GA5668@rakim.wolfsonmicro.main>
 <20090721160436.GD4352@dtor-d630.eng.vmware.com>
 <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
 <20090721222547.GA1948@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
 <20090722121800.GD21171@rakim.wolfsonmicro.main>
 <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
 <1248269443.27058.1449.camel@twins>
 <alpine.LFD.2.00.0907221615480.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907221615480.2813@localhost.localdomain>
X-Cookie: revolutionary, adj.:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 04:18:26PM +0200, Thomas Gleixner wrote:
> On Wed, 22 Jul 2009, Peter Zijlstra wrote:

> > Also, how important is it that subhandler1..n run in their own thread?
> > That is, can't we let them run from the thread that is otherwise waiting
> > for the completino anyway?

> In those cases I suspect we can do that. I guess there can be async
> handling as well: the main handler queries the pending interrupts,
> masks them, wakes the handlers and returns. No wait for all threads to
> finish necessary before unmasking the main interrupt line.

The chips I'm deling with can certainly support doing that but I'm not
sure there'd be enormous advantages - a lot of the interrupt handlers
will either be trivial (eg, RTC ticks or alarms) or be serialised by a
need to interact with the chip anyway.  I'd expect this to be generally
true, though ICBW.
