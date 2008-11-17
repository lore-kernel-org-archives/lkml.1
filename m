Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYKQTxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYKQTxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKQTw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:52:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46634
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbYKQTw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:52:58 -0500
Date: Mon, 17 Nov 2008 11:52:58 -0800 (PST)
Message-Id: <20081117.115258.227376348.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from
 2.6.22 -&gt; 2.6.28
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0811171147380.18283@nehalem.linux-foundation.org>
References: <20081117110119.GL28786@elte.hu>
	<20081117.112157.146825192.davem@davemloft.net>
	<alpine.LFD.2.00.0811171147380.18283@nehalem.linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Nov 2008 11:48:33 -0800 (PST)

> We've asked _you_ to do NMI profiling, it shouldn't be the other way 
> around.

I wasn't able to on these systems, so instead I did cycle level
evaluation of the parts that have to run with interrupts disabled.

And as a result I found that wake_up() is now 4 times slower than it
was in 2.6.22, I even analyzed this for every single kernel release
till now.

It could be a sparc specific issue, because the call chain is deeper
and we eat a lot more register window spills onto the stack.
