Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbYKWDFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbYKWDFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 22:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYKWDFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 22:05:36 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:22206 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbYKWDFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 22:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CaRb6U5N5S4oQE9ev8mjsitg5vMXkwk/b4KM/i2cGdifhUgs/Ru3PPjnPZq3bGcwDp
         3gnaZMNaR2YM51D/FFkcBhuRiLmiKGW9RGEmGK+EsSYKfvhTHUdi1mVaMxEfwVS8I+lP
         7OCZVaRGo+0xUREJ+Al8fq3pMrXbex3VdDLes=
Message-ID: <4928C891.80405@gmail.com>
Date: Sun, 23 Nov 2008 12:05:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
       Miklos Szeredi <miklos@szeredi.hu>, arjan@linux.intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>, hch@infradead.org,
       Ingo Molnar <mingo@elte.hu>, rminnich@sandia.gov, ericvh@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: poll: allow f_op->poll to sleep, take #3
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu> <20081122123942.GF5707@parisc-linux.org> <4927FE87.6050005@gmail.com> <20081122105356.87856d04.akpm@linux-foundation.org> <4928B162.9030404@gmail.com> <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0811221831550.19456@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Sun, 23 Nov 2008, Tejun Heo wrote:
> 
>> +static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
>> +{
>> +	struct poll_wqueues *pwq = wait->private;
>> +	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
>> +
>> +	set_mb(pwq->triggered, 1);
>> +
>> +	/* perform the default wake up operation */
>> +	return default_wake_function(&dummy_wait, mode, sync, key);
>> +}
> 
> Wouldn't it be nicer to un-static try_to_wake_up() (or a wrapper) instead 
> of setting up a fake wait queue just to use default_wake_function(), just 
> to wake up a task?

I thought try_to_wake_up() was made static to avoid abuse but then again
creating dummy waitqueue is an obvious abuse of waitqueue.  What do
other people think?  I'll be happy to use try_to_wake_up() directly.

Thanks.

-- 
tejun
