Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbZFPUqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbZFPUqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764840AbZFPUqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:46:22 -0400
Received: from claw.goop.org ([74.207.240.146]:44666 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764823AbZFPUqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:46:21 -0400
Message-ID: <4A380494.6030506@goop.org>
Date: Tue, 16 Jun 2009 13:46:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
In-Reply-To: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/09 11:51, Daniel Walker wrote:
> Signed-off-by: Daniel Walker<dwalker@fifo99.com>
> ---
>   drivers/staging/android/binder.c |   14 ++++++++------
>   1 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 17d89a8..c37336d 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2146,7 +2146,7 @@ static int binder_thread_read(struct binder_proc *proc,
>   	void __user *end = buffer + size;
>
>   	int ret = 0;
> -	int wait_for_proc_work;
> +	int wait_for_proc_work = 0;
>
>   	if (*consumed == 0) {
>   		if (put_user(BR_NOOP, (uint32_t __user *)ptr))
> @@ -2155,8 +2155,8 @@ static int binder_thread_read(struct binder_proc *proc,
>   	}
>
>   retry:
> -	wait_for_proc_work = thread->transaction_stack == NULL&&
> -				list_empty(&thread->todo);
> +	if (list_empty(&thread->todo)&&  thread->transaction_stack == NULL)
> +		wait_for_proc_work = 1;
>    

I think the original looks cleaner (in both cases).  Assigning a 
variable with the result of a boolean expression is perfectly 
reasonable.  Perhaps change the type of the variable to "bool" to make 
it a bit clearer what's going on.

(It would be a different matter if any of the expression had side-effects.)

     J
