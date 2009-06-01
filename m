Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbZFAJ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbZFAJ2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbZFAJ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:28:29 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:46904 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZFAJ22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vnb/YRG9XQygQNCbhoSKKpQLs8csQFVYhfyPo05gzQEPsXkDmVKqDfyiVMTSPJmA9v
         RavNCv9AAcgmHPNEFv7LAGoGfR7dw7l+0HZt4STEViFmH5wBMfuY92RZRN63C0hLM8C0
         5KuG4Puyy9MXMlcYj6leWsyMr0QUKeUIQ+eZg=
MIME-Version: 1.0
In-Reply-To: <7b6bb4a50906010206k412d6178lbf56856b2b8cce9c@mail.gmail.com>
References: <d364733c0905312349m6b5c8664h6cc7701a576c6b7d@mail.gmail.com>
	 <7b6bb4a50906010206k412d6178lbf56856b2b8cce9c@mail.gmail.com>
Date: Mon, 1 Jun 2009 17:28:29 +0800
Message-ID: <d364733c0906010228x2b977ccfl1c8b2862784e1bc0@mail.gmail.com>
Subject: Re: new implementation of mutex
From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 1, 2009 at 5:06 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
>
>
> On Mon, Jun 1, 2009 at 2:49 PM, Ð»¸Ù <xiegang112@gmail.com> wrote:
>>
>> There is new implementaion in newer kernel (my kernel version is
>> 2.6.27). Compared to the old implementaion which uses binary
>> semaphore, there are some new features:
>>  - 'struct mutex' semantics are well-defined and are enforced if
>>   CONFIG_DEBUG_MUTEXES is turned on. Semaphores on the other hand have
>>   virtually no debugging code or instrumentation. The mutex subsystem
>>   checks and enforces the following rules:
>>
>>   * - only one task can hold the mutex at a time
>>   * - only the owner can unlock the mutex
>>   * - multiple unlocks are not permitted
>>   * - recursive locking is not permitted
>>   * - a mutex object must be initialized via the API
>>   * - a mutex object must not be initialized via memset or copying
>>   * - task may not exit with mutex held
>>   * - memory areas where held locks reside must not be freed
>>   * - held mutexes must not be reinitialized
>>   * - mutexes may not be used in hardware or software interrupt
>>   *   contexts such as tasklets and timers
>>
>> But in my test, I try to lock mutex in one thread, and unlock it in
>> the other thread. There is nothing wrong happens. It works just like
>> semaphore. I have had CONFIG_DEBUG_MUTEXES turned on.
>> The two threads are mostly like this:
>> struct mutex mutex;
>>
>> static int mysthread1(void * data){
>>  int i;
>>  i= 5;
>>  while(i -- > 0){
>>                mutex_lock(&mutex);
>>    printk("this is thread1\n");
>>    msleep(5000);
>>  }
>>        return 0;
>> }
>>
>> static int mysthread2(void * data){
>>  int i;
>>  i= 5;
>>  while(i -- > 0){
>>    printk("this is thread2\n");
>>    msleep(5000);
>>                mutex_lock(&mutex);
I typied wrong funcion. Actually, I unlock mutex with mutex_unlock here.
>
> unlock here?
yes.
>>
>>  }
>>        return 0;
>> }
>>
>> I debug it and find the debug_locks = 0.  Is this why there is no
>> warning message and how turn it on? (I also had CONFIG_LOCKDEP_SUPPORT
>> on.)
>>
>>
>> --
>> Xie Gang
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>



-- 
Xie Gang
