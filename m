Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbXJUQGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbXJUQGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 12:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXJUQGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 12:06:23 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:57207 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751514AbXJUQGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 12:06:22 -0400
Date: Sun, 21 Oct 2007 18:06:26 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Message-ID: <20071021180626.0ce07c79@siona>
In-Reply-To: <ffb7oo$k26$1@ger.gmane.org>
References: <200710181551.24912.florian.fainelli@telecomint.eu>
	<20071018173828.159b15dd@ephemeral>
	<200710191401.56916.florian.fainelli@telecomint.eu>
	<ffb7oo$k26$1@ger.gmane.org>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 21:32:08 +0000 (UTC)
Jordan Crouse <jordan.crouse@amd.com> wrote:

> > This one was discussed mostly on the ARM mailing-list and finally
> > made his way to the mainline kernel. Though it lacks some functions
> > to change for instance a entire GPIO line and not a single bit, it
> > is used on ARM and MIPS systems so I would conform with this one
> > for now because it is used by at least two or more architectures.  

Make that four: AVR32 and Blackfin use the generic GPIO API too.

> Its reasonable to expect that the API will expand over time as it is
> thrust into new situations.  There is nothing wrong with the existing
> API, it does an admirable job of simple GPIO frobbing.  But on the
> Geode, GPIOs can do much more then just simple input and output.  We
> can cause events, use input filtering for debouncing, set various
> drain options, and more.

There are many other architectures that can do things like that. But
since there are lots of variations in this kind of functionality from
architecture to architecture (and even chip to chip), it has been
excluded from the generic GPIO API.

> And these are not bullet points from the
> datasheet that we want to implement for completeness; these functions
> are actually being used right now in the kernel on real hardware.

How is it used? In many cases, you can get away with simply configuring
the port with the required features like debouncing, pullup, drain
options, etc. in the platform setup code where you can freely use
platform-specific port configuration calls.

> Just because other architectures haven't found a need to expand the
> API doesn't mean that we shouldn't expand it now.  And bear in mind,
> the Geode isn't unique - I'll bet beers that there are MIPS and ARM
> architectures that have these features too, and they would use the
> API if it existed.

These features are certainly being utilized in the platform setup code
on various platforms. I guess the current API might be too simple for
drivers that need to reconfigure the port on the fly, but I haven't
really seen any such drivers so far.

For example, the generic i2c-gpio driver supports three different ways
of driving the i2c lines depending on how the port was configured by
the platform.

Håvard
