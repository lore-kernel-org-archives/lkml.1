Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbYFMKJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbYFMKJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 06:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbYFMKJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 06:09:09 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:49722 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbYFMKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 06:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=ljbeSk8q9f8SkMCzSiWJ/d/eE1UCkXPScT0tiHnsxfNqJUairysBDo6uBgCXNxWJMp
         6jM6etnxBYTDesIlraLz/xTe7TUR4+xxBs3JC8A7rzXTyC0pPy/bm/YtJMO2rJ4XL8mV
         +yoa+F4BIs72wfEb9+UT8jN8I92thzUIEauBM=
Date: Fri, 13 Jun 2008 10:13:12 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of
	"int tail"
Message-ID: <20080613101312.GA4319@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612222458.GC2472@ami.dom.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-2008 00:24, Jarek Poplawski wrote:
> On Thu, Jun 12, 2008 at 08:55:50PM +0400, Oleg Nesterov wrote:
>> On 06/12, Oleg Nesterov wrote:
>>> insert_work() inserts the new work_struct before or after cwq->worklist,
>>> depending on the "int tail" parameter. Change it to accept "list_head *"
>>> instead, this shrinks .text a bit and allows us to insert the barrier
>>> after specific work_struct.
>> This allows us to implement
>>
>> 	int flush_work(struct work_struct *work)
>> 	{
> ...
>> 	}
>>
>> suggested by Peter. It only waits for selected work_struct.
>>
>> I doubt it will have a lot of users though. In most cases we need
>> cancel_work_sync() and nothing more.
> 
> I guess it could've had enough users if it were done a bit sooner...
> 
> I didn't check this implementation yet, but if it's "rtnl_lock in
> other works" safe then it could've been used in David Miller's fresh
> patch replacing last uses of flush_scheduled_work() in net drivers'
> ->stop() etc (thread: "Re: 2.6.25rc7 lockdep trace") - there would
> be far less doubts about possible change of functionality.

Hmm... I see it's definitely not for this. I should forget about my
crazy idea. Yes, cancel_work_sync() is mostly enough, and flush_
remains dangerous. (Maybe it's better not to get new users for this?)

Regards,
Jarek P.
