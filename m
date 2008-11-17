Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYKQT6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYKQT6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYKQT6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:58:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbYKQT6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:58:35 -0500
Date: Mon, 17 Nov 2008 11:57:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <20081117.115258.227376348.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0811171156080.18283@nehalem.linux-foundation.org>
References: <20081117110119.GL28786@elte.hu> <20081117.112157.146825192.davem@davemloft.net> <alpine.LFD.2.00.0811171147380.18283@nehalem.linux-foundation.org> <20081117.115258.227376348.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, David Miller wrote:
> 
> And as a result I found that wake_up() is now 4 times slower than it
> was in 2.6.22, I even analyzed this for every single kernel release
> till now.

..and that's the one where you then pointed to hrtimers, and now you claim 
that was fixed?

At least I haven't seen any new analysis since then.

> It could be a sparc specific issue, because the call chain is deeper
> and we eat a lot more register window spills onto the stack.

Oh, easily. In-order machines tend to have serious problems with indirect 
function calls in particular. x86, in contrast, tends to not even notice, 
especially if the indirect function is fairly static per call-site, and 
predicts well.

There is a reason my machine is 15-20 times faster than yours.

			Linus
