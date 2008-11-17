Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYKQGx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYKQGx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 01:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYKQGxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 01:53:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:47487 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYKQGxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 01:53:48 -0500
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       travis@sgi.com
In-Reply-To: <4920F649.60901@zytor.com>
References: <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu>
	 <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu>
	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
	 <20081110094033.GL22392@elte.hu>
	 <20081110015511.453a801e.akpm@linux-foundation.org>
	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>
	 <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu>
	 <491C8B38.9060901@kernel.org>
	 <20081113131850.d94fb229.akpm@linux-foundation.org>
	 <1226869137.7178.175.camel@pasglop> <4920B069.5020203@kernel.org>
	 <4920B15E.6090200@zytor.com> <1226895741.7178.183.camel@pasglop>
	 <4920F649.60901@zytor.com>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 17:52:35 +1100
Message-Id: <1226904755.7178.223.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-16 at 20:42 -0800, H. Peter Anvin wrote:
> Benjamin Herrenschmidt wrote:
> > 
> > IRQ numbers are arbitrary, some platforms make up numbers out of the
> > blue, or they can be hypervisor internal tokens etc...
> > 
> > The only sane way to handle this generically IMHO is to do what we do
> > on powerpc (and I think sparc64) which is to totally disconnect the HW
> > number from the "linux" number.
> > 
> 
> Yes, that's what I want to see, too.  On x86, it's important to preserve
> the first 16 (BIOS-compatible, XT-PIC) numbers, as they are widely used
> as a user interface, but for the rest, there is no point.

Right, and I do that on powerpc by reserving those numbers so they get
automatically assigned to and only to the PIC that comes up as claiming
the legacy number space (if any, if none, then they remain unassigned to
avoid problems with old crappy modules hard coding IRQ numbers and
trying to request them).

> It is probably desirable to do that by overlaying the first (primary,
> south bridge) IO-APIC, which also takes care of the "semi-legacy" IRQ
> 16-23 numbers.

Would make sense indeed to treat those numbers specifically.

Ben.


