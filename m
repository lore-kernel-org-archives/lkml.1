Return-Path: <linux-kernel-owner+w=401wt.eu-S935761AbXJSRtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935761AbXJSRtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbXJSRss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:48:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51867 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765891AbXJSRsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:48:47 -0400
Message-ID: <4718EDFE.40401@garzik.org>
Date: Fri, 19 Oct 2007 13:48:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] irq-remove: core
References: <20071019075443.GA6407@havoc.gtf.org>	<20071019075508.GB6407@havoc.gtf.org> <m1przbggkg.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1przbggkg.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> index 80eab7a..92e1456 100644
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -455,7 +455,7 @@ void free_irq(unsigned int irq, void *dev_id)
>>  			 */
>>  			if (action->flags & IRQF_SHARED) {
>>  				local_irq_save(flags);
>> -				action->handler(irq, dev_id);
>> +				action->handler(dev_id);
>>  				local_irq_restore(flags);
>>  			}
>>  #endif
>> @@ -549,7 +549,7 @@ int request_irq(unsigned int irq, irq_handler_t handler,
>>  		unsigned long flags;
>>  
>>  		local_irq_save(flags);
>> -		handler(irq, dev_id);
>> +		handler(dev_id);
>>  		local_irq_restore(flags);
>>  	}
>>  #endif
> 
> The above two hunks need to call set_irqfunc_irq in your model.

Duh.  Thanks for pointing out an obvious mistake :)

Fixed and checked into 'irq-remove' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

