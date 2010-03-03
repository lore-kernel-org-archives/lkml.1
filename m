Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab0CCQ0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:26:23 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52025 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab0CCQ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:26:21 -0500
Subject: Re: [PATCH] hpet: factor timer allocate from open
From: john stultz <johnstul@us.ibm.com>
To: Magnus Lynch <maglyx@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
In-Reply-To: <be233a491003030107u3d9fae9cvc6b4a25db7060ec9@mail.gmail.com>
References: <4B8B901E.4050302@ladisch.de>
	 <4b8c226e.0aa1660a.67e2.6fdc@mx.google.com>
	 <1f1b08da1003011259yed7c61bvb18071eb8e465bca@mail.gmail.com>
	 <be233a491003030107u3d9fae9cvc6b4a25db7060ec9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 08:26:09 -0800
Message-ID: <1267633569.1947.23.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 01:07 -0800, Magnus Lynch wrote:
> On Mon, Mar 1, 2010 at 12:59 PM, john stultz <johnstul@us.ibm.com> wrote:
> > Yes, CLOCK_MONOTONIC_RAW was added specifically to create a hardware
> > agnostic interface that provided a 1:1 ratio to the hardware cycle
> > counter used by the timekeeping core. No NTP corrections or slewing
> > are applied and it isn't affected by settimeofday calls.
> >
> > Let me know if you run into any trouble with it.
> > thanks
> 
> Actually I did run into trouble. CLOCK_MONOTONIC_RAW is defined in
> linux/time.h and including that creates a lot of redefinition
> conflicts with time.h. I see the linux/ includes aren't intended for
> user space code.

Oh, right. Sorry about that, Glibc still hasn't picked these up.

I'll have to chase down how to get that done. 

For now, you can just add the following to your code:
#define CLOCK_MONOTONIC_RAW		4

Thanks for bringing it up!
-john


