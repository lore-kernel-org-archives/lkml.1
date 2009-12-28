Return-Path: <linux-kernel-owner+w=401wt.eu-S1751340AbZL1TX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbZL1TX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 14:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZL1TX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 14:23:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55314 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZL1TX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 14:23:28 -0500
Date: Mon, 28 Dec 2009 20:23:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, Nitin Gupta <ngupta@vflare.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm] Add notifiers for various swap events
Message-ID: <20091228192325.GG4994@basil.fritz.box>
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org> <87eimf87m5.fsf@basil.nowhere.org> <4B38D0CF.9000403@vflare.org> <20091228172903.GF4994@basil.fritz.box> <4B38FC42.7000204@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B38FC42.7000204@cs.helsinki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> The first question to ask is if compressed swap is worth
>>>> it. Do you have benchmark numbers showing it to be an improvement?
>>>> Are there cases where it is slower than uncompressed swap?
>>>>
>>> http://code.google.com/p/compcache/wiki/Performance
>>
>> That should be included in the changelog of the patches.
>
> Which patches? The driver is already in staging and there's a pointer to 
> the home page in

How can it be in staging if there are no hooks for it yet?

>>> ramzswap is an optional module.
>>
>> I have some doubts on the wisdom of making swap algorithms modular.
>> Better compile them in. Then you don't need messy notifiers either.
>
> What's so messy about them? The whole point of having the notifiers is to 
> avoid CONFIG_RAMZSWAP in core kernel code...

They make the code much harder to read and follow. When you try to follow
the code flow and you find a notifier it's always a complicated operation
to figure out what code will end up being called.

Sometimes they are needed, but they have a high cost in maintainability.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
