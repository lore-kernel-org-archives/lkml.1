Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYKQE1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYKQE1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYKQE12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:27:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:41464 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607AbYKQE11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:27:27 -0500
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       travis@sgi.com
In-Reply-To: <4920BA3A.5090100@zytor.com>
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
	 <4920B15E.6090200@zytor.com> <4920B2A4.4040900@kernel.org>
	 <4920B3E3.4050707@zytor.com> <4920B911.7060504@kernel.org>
	 <4920BA3A.5090100@zytor.com>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 15:26:58 +1100
Message-Id: <1226896018.7178.188.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-16 at 16:26 -0800, H. Peter Anvin wrote:
> It would, however, be a good idea if IOAPICs had their numbers assigned
> at detection time, as opposed to when the interrupt is registered, thus
> making it a stable number for a single boot, at least.  The same is
> probably true for MSI(-X); we could assign it a range of numbers when
> the device is enumerated (as opposed to when a driver is activated), but
> I don't know to what extent that is likely to cause more troubles than
> it solves.

On powerpc, we establish the mapping at PCI probe time so it's
reasonably stable. In fact, we even try to use virq == hwirq number if
the hwirq number fits and is available though I'm tempted to remove that
"feature" as it can make things more confusing in the end with some
interrupts having matching HW numbers and some not.

Cheers,
Ben.

