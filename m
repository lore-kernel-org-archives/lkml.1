Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbXI2UCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbXI2UCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXI2UCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:02:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbXI2UCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:02:45 -0400
Date: Sat, 29 Sep 2007 13:02:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Message-Id: <20070929130234.e5f0f777.akpm@linux-foundation.org>
In-Reply-To: <200709292140.23593.elendil@planet.nl>
References: <200709282225.21530.elendil@planet.nl>
	<200709290232.44573.elendil@planet.nl>
	<20070929013702.f56ba268.akpm@linux-foundation.org>
	<200709292140.23593.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 21:40:22 +0200 Frans Pop <elendil@planet.nl> wrote:

> On Saturday 29 September 2007, you wrote:
> > On Sat, 29 Sep 2007 02:32:44 +0200 Frans Pop <elendil@planet.nl> wrote:
> > > On Friday 28 September 2007, Frans Pop wrote:
> > > > My Toshiba Satellite A40 (i386, P4 Mobile) hangs during boot after:
> > > > Marking TSC unstable due to: possible TSC halt in C2.
> > > > Time: acpi_pm clocksource has been installed.
> > >
> > > A few new boot attempts show the problem is more likely at:
> > > Probing IDE interface ide0...
> 
> Looks like it is both: hpet killing IDE?
> 
> > Two iterations should get you into the culprit zone.
> 
> Thanks for the pointers. Luckily I ended up in a quite narrow zone between 
> two of the points you indicated (10 iterations).
> 
> And the winner is:
> 
> 3fe6c0016fd863b233097a8219a0d8577c2fd503 is first bad commit
> commit 3fe6c0016fd863b233097a8219a0d8577c2fd503
> Author: Udo A. Steinberg <...>
>     hpet-force-enable-on-ich34
> 
> Guess the comments about thin ice and testing were justified :-)
> 
> lspci and a 2.6.23-rc6 dmesg for this system can be found in:
> http://lkml.org/lkml/2007/9/19/300

Great, thanks for doing that.

I guess I'll drop the patch for now in that case.
