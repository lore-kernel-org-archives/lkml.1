Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYDXN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYDXN7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbYDXN7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:59:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2878 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYDXN7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:59:30 -0400
References: <480F8936.5030406@hp.com> <87ve27gz4u.fsf@basil.nowhere.org>
Message-Id: <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
To: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <87ve27gz4u.fsf@basil.nowhere.org>
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
X-Mailer: iPhone Mail (4A102)
Mime-Version: 1.0 (iPhone Mail 4A102)
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Apr 2008 15:59:00 +0200
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/04/2008, at 15.29, Andi Kleen <andi@firstfloor.org> wrote:

> "Alan D. Brunelle" <Alan.Brunelle@hp.com> writes:
>
>> The block I/O + elevator + I/O scheduler code spends a lot of time
>> trying to merge I/Os -- rightfully so under "normal" circumstances.
>> However, if one were to know that the incoming I/O stream was /very/
>> random in nature, the cycles are wasted. (This can be the case, for
>> example, during OLTP-type runs.)
>>
>> This patch stream adds a per-request_queue tunable that (when set)
>> disables merge attempts, thus freeing up a non-trivial amount of  
>> CPU cycles.
>
> It sounds interesting. But explicit tunables are always bad because
> they will be only used by a elite few. Do you think it would be
> possible instead to keep some statistics on how successfull merging  
> is and
> when the success rate is very low disable it automatically for some
> time until a time out?
>
> This way nearly everybody could get most of the benefit from this
> change.

Not a good idea IMHO, it's much better with an explicit setting. That  
way you don't introduce indeterministic behavior. 
