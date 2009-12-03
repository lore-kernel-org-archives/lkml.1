Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZLCIYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZLCIYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZLCIYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:24:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZLCIYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:24:04 -0500
Message-ID: <4B177654.2090504@redhat.com>
Date: Thu, 03 Dec 2009 16:27:00 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Patch] ipc: remove unreachable code in sem.c
References: <20091201070008.4311.16191.sendpatchset@localhost.localdomain> <20091202144552.ea635692.akpm@linux-foundation.org>
In-Reply-To: <20091202144552.ea635692.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 1 Dec 2009 01:57:09 -0500
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> This line is unreachable, remove it.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>>
>> ---
>> diff --git a/ipc/sem.c b/ipc/sem.c
>> index 87c2b64..8439f2f 100644
>> --- a/ipc/sem.c
>> +++ b/ipc/sem.c
>> @@ -652,7 +652,6 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
>>  	default:
>>  		return -EINVAL;
>>  	}
>> -	return err;
>>  out_unlock:
>>  	sem_unlock(sma);
>>  	return err;
> 
> If we're going to do that then there's no point in initialising `err':
> 
> --- a/ipc/sem.c~ipc-remove-unreachable-code-in-semc-fix
> +++ a/ipc/sem.c
> @@ -624,7 +624,7 @@ static unsigned long copy_semid_to_user(
>  static int semctl_nolock(struct ipc_namespace *ns, int semid,
>  			 int cmd, int version, union semun arg)
>  {
> -	int err = -EINVAL;
> +	int err;
>  	struct sem_array *sma;
>  
>  	switch(cmd) {
> _
> 
> 
> you should have noticed this!

Oh, I didn't realize that. Thank you!

