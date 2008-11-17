Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYKQEqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYKQEqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYKQEqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:46:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988AbYKQEqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:46:17 -0500
Message-ID: <4920F649.60901@zytor.com>
Date: Sun, 16 Nov 2008 20:42:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu>	 <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu>	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>	 <20081110094033.GL22392@elte.hu>	 <20081110015511.453a801e.akpm@linux-foundation.org>	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>	 <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu>	 <491C8B38.9060901@kernel.org>	 <20081113131850.d94fb229.akpm@linux-foundation.org>	 <1226869137.7178.175.camel@pasglop> <4920B069.5020203@kernel.org>	 <4920B15E.6090200@zytor.com> <1226895741.7178.183.camel@pasglop>
In-Reply-To: <1226895741.7178.183.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> 
> IRQ numbers are arbitrary, some platforms make up numbers out of the
> blue, or they can be hypervisor internal tokens etc...
> 
> The only sane way to handle this generically IMHO is to do what we do
> on powerpc (and I think sparc64) which is to totally disconnect the HW
> number from the "linux" number.
> 

Yes, that's what I want to see, too.  On x86, it's important to preserve
the first 16 (BIOS-compatible, XT-PIC) numbers, as they are widely used
as a user interface, but for the rest, there is no point.

It is probably desirable to do that by overlaying the first (primary,
south bridge) IO-APIC, which also takes care of the "semi-legacy" IRQ
16-23 numbers.

	-hpa
