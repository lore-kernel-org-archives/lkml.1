Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbZFPVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbZFPVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZFPVQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:16:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37740 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbZFPVQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:16:21 -0400
Message-ID: <4A380BA1.4020106@redhat.com>
Date: Tue, 16 Jun 2009 17:16:17 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random> <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <20090616200852.GA16265@cmpxchg.org>
In-Reply-To: <20090616200852.GA16265@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> On Tue, Jun 16, 2009 at 07:38:39PM +0100, Hugh Dickins wrote:

>> --- 2.6.30-mm1/mm/thrash.c	2007-07-09 00:32:17.000000000 +0100
>> +++ linux/mm/thrash.c	2009-06-15 19:44:53.000000000 +0100
>> @@ -30,6 +30,9 @@ void grab_swap_token(void)
>>  {
>>  	int current_interval;
>>  
>> +	if (!current->mm)	/* kthread doing get_user_pages on an mm */
>> +		return;
>> +
> 
> Did you have a particular reason not to pass in the faulting mm
> instead?

If the task itself is not swapping, should we really give
it the swap token?

I admit, this could be a pretty weak reason :)

-- 
All rights reversed.
