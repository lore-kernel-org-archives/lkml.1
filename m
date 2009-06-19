Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbZFSPAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbZFSPAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 11:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZFSO7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:59:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47931 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZFSO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:59:54 -0400
Date: Fri, 19 Jun 2009 16:59:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Greg Kroah-Hartman <greg@kroah.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
Message-ID: <20090619145938.GB1389@ucw.cz>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com> <4A380494.6030506@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A380494.6030506@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>   	int ret = 0;
>> -	int wait_for_proc_work;
>> +	int wait_for_proc_work = 0;
>>
>>   	if (*consumed == 0) {
>>   		if (put_user(BR_NOOP, (uint32_t __user *)ptr))
>> @@ -2155,8 +2155,8 @@ static int binder_thread_read(struct binder_proc *proc,
>>   	}
>>
>>   retry:
>> -	wait_for_proc_work = thread->transaction_stack == NULL&&
>> -				list_empty(&thread->todo);
>> +	if (list_empty(&thread->todo)&&  thread->transaction_stack == NULL)
>> +		wait_for_proc_work = 1;
>>    
>
> I think the original looks cleaner (in both cases).  Assigning a  
> variable with the result of a boolean expression is perfectly  
> reasonable.  Perhaps change the type of the variable to "bool" to make  
> it a bit clearer what's going on.
>
> (It would be a different matter if any of the expression had side-effects.)

Plus you have broken whitespace in there, changed performance
characteristics (list_empty now done first) and with gotos used around
that code I'm not at all sure transformation is equivalent.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
