Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbZETIJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbZETIJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZETIIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:08:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32888 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbZETIIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:08:45 -0400
Date: Wed, 20 May 2009 10:14:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [RFC] mod_timer() helper functions?
Message-ID: <20090520081443.GA8684@one.firstfloor.org>
References: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com> <87eiumq3w2.fsf@basil.nowhere.org> <a24804730905200011l202733abh89f5d4feaf69610e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a24804730905200011l202733abh89f5d4feaf69610e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> /**
>  * timer_settime_msecs - modify a timer's timeout
>  * @timer: the timer to be modified
>  * @msecs: minimum time in milliseconds to sleep for
>  */
> int timer_settime_msecs(struct timer_list *timer, int msecs)

At least this function needs something that indicates it is very approximate
(upto 900% error for 1ms with HZ=100)
The old open coded pattern showed this. 

Or perhaps better drop the msecs version and just keep the seconds version.

People who want msecs accuracy likely should use hrtimers anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
