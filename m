Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZIHAOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZIHAOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZIHAOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:14:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:41691 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbZIHAOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:14:10 -0400
Date: Mon, 7 Sep 2009 17:14:06 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Matt Smith <Matt.Smith@atheros.com>, Kevin Hayes <kevin@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, ic.felix@gmail.com
Subject: Re: Stop using tasklets for bottom halves
Message-ID: <20090907171406.6a4b6116@nehalam>
In-Reply-To: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com>
References: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009 15:58:50 -0700
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> A while ago I had read about an effort to consider removing tasklets
> [1] or at least trying to not use them. I'm unaware of the progress in
> this respect but since reading that article have always tried to
> evaluate whether or not we need tasklets on wireless drivers. I have
> also wondered whether work in irq context in other parts of the kernel
> can be moved to process context, a curious example being timers. I'll
> personally be trying to using only process context on bottom halves on
> future drivers but I figured it may be a good time to ask how serious
> was avoiding tasklets or using wrappers in the future to avoid irq
> context is or is it advised. Do we have a general agreement this is a
> good step forward to take? Has anyone made tests or changes on a
> specific driver from irq context to process context and proven there
> are no significant advantages of using irq context where you would
> have expected it?
> 
> Wireless in particular should IMHO not require taskets for anything
> time sensitive that I can think about except perhaps changing channels
> quickly and to do that appropriately also process pending RX frames
> prior to a switch. It remains to be seen experimentally whether or not
> using a workqueue for RX processing would affect the time to switch
> channels negatively but I doubt it would be significant. I hope to
> test that with ath9k_htc.
> 
> What about gigabit or 10 Gigabit Ethernet drivers ? Do they face any
> challenges which would yet need to be proven would not face issues
> when processing bottom halves in process context?
> 
> [1] http://lwn.net/Articles/239633/
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Why not use NAPI, which is soft irq? Almost all 1G and 10G drivers
use NAPI.

Process context is too slow.

-- 
