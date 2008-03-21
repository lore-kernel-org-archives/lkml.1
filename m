Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbYCURC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbYCURC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759833AbYCURCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:02:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34195 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbYCURCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:02:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E3EA27.7020800@s5r6.in-berlin.de>
Date: Fri, 21 Mar 2008 18:02:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
References: <20080320192719.6a32386e.akpm@linux-foundation.org>	<Pine.LNX.4.44L0.0803202301140.16520-100000@netrider.rowland.org>	<20080320201723.b87b3732.akpm@linux-foundation.org> <200803220011.CEC82820.QSOtJOVFFHFMLO@I-love.SAKURA.ne.jp> <47E3E83F.3070508@s5r6.in-berlin.de>
In-Reply-To: <47E3E83F.3070508@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PS,
I wrote:
> Tetsuo Handa wrote:
>> So, it is impossible to know whether I am inside a spinlock or not.
>> OK. That's not what I want to do.
>>
>> I want to make sure that my code (not a device driver) is called only 
>> from a context where use of down()/mutex_lock()/kmalloc(GFP_KERNEL)/
>> get_user_pages()/kmap() etc. are permitted.
>> Is "if (in_atomic()) return;" check a correct method for avoiding 
>> deadlocks when my code was accidentally called from a context
>> where use of down()/mutex_lock()/kmalloc(GFP_KERNEL)/get_user_pages()/
>> kmap() etc. are not permitted?

No.  Quoting Andrew:  "in_atomic() returns false inside spinlock on 
non-preemptible kernels."

> You shouldn't sleep while holding a spinlock.  As soon as another thread 

or interrupt handler or tasklet

> attempts to take the spinlock, it will be stuck in a busy-wait loop.
-- 
Stefan Richter
-=====-==--- --== =-=-=
http://arcgraph.de/sr/
