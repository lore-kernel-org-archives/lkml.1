Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbXEQOpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbXEQOpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbXEQOou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:44:50 -0400
Received: from www.osadl.org ([213.239.205.134]:50429 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758087AbXEQOot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:44:49 -0400
Subject: Re: [PATCH] INPUT: Sanitize PIT locking in pcspkr
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Richard Henderson <rth@twiddle.net>
In-Reply-To: <d120d5000705170736q4e9eb5d4jab82732e01e377c@mail.gmail.com>
References: <1179408962.3764.72.camel@chaos>
	 <d120d5000705170715s2066ea39r9b129e5efe79c4dd@mail.gmail.com>
	 <1179412525.3764.80.camel@chaos>
	 <d120d5000705170736q4e9eb5d4jab82732e01e377c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 16:49:35 +0200
Message-Id: <1179413375.3764.86.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 10:36 -0400, Dmitry Torokhov wrote:
> > BTW, there are more creative PIT users in drivers/input which use the
> > global lock already, but the PIT usage there is definitely broken on
> > anything >= 2.6.21.
> >
> 
> Are you talking about drivers/input/joystick/analog.c? What is broken there?

drivers/gameport/gameport.c as well.

Both read the PIT directly, which will lead to interesting results. The
PIT is either stopped or it can be used in one shot mode with per event
changing intervals due to the changes introduced by the clock events
layer.

This code should use ktime_get() and not fiddle in the hardware itself.

	tglx


