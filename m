Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351AbZGTLoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbZGTLoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 07:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbZGTLob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 07:44:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48369 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbZGTLoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 07:44:30 -0400
Message-ID: <4A645974.3020801@redhat.com>
Date: Mon, 20 Jul 2009 14:48:04 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 10/10] ksm: change ksm nice level to be 5
References: <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com> <1247851850-4298-5-git-send-email-ieidus@redhat.com> <1247851850-4298-6-git-send-email-ieidus@redhat.com> <1247851850-4298-7-git-send-email-ieidus@redhat.com> <1247851850-4298-8-git-send-email-ieidus@redhat.com> <1247851850-4298-9-git-send-email-ieidus@redhat.com> <1247851850-4298-10-git-send-email-ieidus@redhat.com> <1247851850-4298-11-git-send-email-ieidus@redhat.com> <20090720045037.GA24157@balbir.in.ibm.com>
In-Reply-To: <20090720045037.GA24157@balbir.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * Izik Eidus <ieidus@redhat.com> [2009-07-17 20:30:50]:
>
>   
>> From: Izik Eidus <ieidus@redhat.com>
>>
>> ksm should try not to disturb other tasks as much as possible.
>>
>> Signed-off-by: Izik Eidus <ieidus@redhat.com>
>> ---
>>  mm/ksm.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 75d7802..4afe345 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -1270,7 +1270,7 @@ static void ksm_do_scan(unsigned int scan_npages)
>>
>>  static int ksm_scan_thread(void *nothing)
>>  {
>> -	set_user_nice(current, 0);
>> +	set_user_nice(current, 5);
>>     
>
> Is the 5 arbitrary? Why not +19? What is the intention of this change
> - to run when no other task is ready to run?
>   

Hey Balbir,

I thought about giving it the lowest priority of nice before I did this 
patch, but then I came into understanding that it isn't right,
Although ksm should not distrub other tasks while they are running, it 
does need to run while they are running,
most of the use cases for ksm is to find identical pages in real time 
while they are changing in the application, so giving it the lowest 
priority doesn't seems right to me,

But my understanding of how the nice prioritys are working is just my 
intuition, so if you know better and think that for the use case i 
described above other nice priority is better fit, tell me and I wont 
have any problem to change.

Thanks.
 
 
>   
>>  	while (!kthread_should_stop()) {
>>  		if (ksm_run & KSM_RUN_MERGE) {
>>     
>
>   

