Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbXGTMHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbXGTMHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbXGTMH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:07:27 -0400
Received: from kuber.nabble.com ([216.139.236.158]:47685 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXGTMH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:07:26 -0400
Message-ID: <11706967.post@talk.nabble.com>
Date: Fri, 20 Jul 2007 05:07:25 -0700 (PDT)
From: Misbah khan <misbah_khan@engineer.com>
To: linux-kernel@vger.kernel.org
Subject: Re: workqueue is not working?
In-Reply-To: <4ae3c140511171505j33dc4c2ere731f1b3c55f9741@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: misbah_khan@engineer.com
References: <4ae3c140511171505j33dc4c2ere731f1b3c55f9741@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I didnt got very clearly what you actually did. But i guess you did faced
some problem to work with work queue ( Bottom half of the handler ) I
suggest you with an example code so that you could try with it and hope your
doubt would get cleared.

/* work queue register and initialize */
static DECLARE_WORK(queue_name,(void *)func_name,func_arq_ptr);

eg :-

static DECLARE_WORK(my_queue,(void *)my_func,NULL);

/* In the Interrupt handler you need to call the bottom half of the function
*/

schedule_work(&my_queue);

/* The function defination is like this */
void my_func(void)
{
       printk(" Hello from kernal land \n");
}

I hope this example will make your code to work for you , for any
clarification please let me know 

thanks 




Xin Zhao wrote:
> 
> I tried to schedule some work in an softirq handler. The way I did is
> as follows:
> 
> I use create_workqueue to initialize a workqueue "vrpciod_workqueue",
> 
> in the softirq, I do INIT_WORK(work, func, data), and then
> queue_work(vrpciod_workqueue, work);
> 
> I think func() should be called a bit later. However, I noticed that
> func() is never called by the workqueue. I don't know why.
> 
> Can soneone give me some suggestions? Many thanks!
> 
> Xin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
View this message in context: http://www.nabble.com/workqueue-is-not-working--tf573889.html#a11706967
Sent from the linux-kernel mailing list archive at Nabble.com.

