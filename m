Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYKYK7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYKYK7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYKYK7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:59:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58122 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYKYK7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:59:16 -0500
Date: Tue, 25 Nov 2008 12:09:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.28-rc6] oprofile: "opcontrol --start" output two warnings
Message-ID: <20081125110935.GF6703@one.firstfloor.org>
References: <20081125121212.26C3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <87ljv8ce2j.fsf@basil.nowhere.org> <20081125192316.26E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125192316.26E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if so, I think get_stagger() is a bit strange.
> it depend on caller cpu. then if PREEMPT=Y, it return radom result.

Even without PREEMPT it is random because there is no guarantee the
init code is executing on CPU 0

> 
> I'm not sure about oprofile design.
> but if you are right, I think p4_fill_in_addresses shoudn't use smp_processor_id().

Correct.

> 
> Am I missing any point?

No you're right. Always returning 0 in get_stagger() should be ok
I think, at least it wouldn't make anything worse.

Or perhaps figure out if the per cpu addresses are really needed,
if yes then this would need much more changes. But I hope 
that would not be needed.

But someone should better test it, the P4 perfmon handling is certainly
hairy and I don't claim to understand all its intricate details.

-Andi

-- 
ak@linux.intel.com
