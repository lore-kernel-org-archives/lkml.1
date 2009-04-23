Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZDWFaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZDWFaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 01:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZDWF36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 01:29:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:52935 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZDWF35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 01:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yd8nzFaBo1RHUnhDrLPRBYm6jDZn5FRl3qQU1okmQum+fb8deDxvn15zgJFYSRloLd
         eSrGnxTVQ2FMkH/vKsyADh7LgY2rMl00kMOUuk7hfxPmHyXktDse89/WgtHiUSo9CRMV
         JDOlI12E/g5LvtS4qBA4dmrWE/nMSY9NLF3Y4=
MIME-Version: 1.0
In-Reply-To: <1239908780.10567.8.camel@ht.satnam>
References: <a85e78f50904161052s71dabbe9p17ac68b35331eae@mail.gmail.com>
	 <1239908780.10567.8.camel@ht.satnam>
Date: Thu, 23 Apr 2009 10:59:56 +0530
Message-ID: <a85e78f50904222229j3208105dy5d6f45833b83abd4@mail.gmail.com>
Subject: Re: [PATCH] removes unused variable from kernel/sysctl.h
From: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 17, 2009 at 12:36 AM, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
> Hello Sukanto,
>
> On Thu, 2009-04-16 at 23:22 +0530, Sukanto Ghosh wrote:
>> This patch removes the unused variable 'val' from the
>> __do_proc_dointvec() function
>> in kernel/sysctl.h. The integer has been declared and used as 'val =
>> -val' and there is
>> no reference to it anywhere.
>> Although I am this doesn't affects the kernel binary because gcc
>> removes it, still it
>> might be confusing for people reading the code.
>>
>
> This patch is already submitted by Tomohiro Kusumi on Thu Dec 27 2007:
>
> http://lkml.indiana.edu/hypermail/linux/kernel/0712.3/0557.html

I asked Tomohiro regarding this and got the following reply:

----
I think they just missed that patch since I found my name on
the following page regarding this patch.
http://lkml.org/lkml/2008/5/30/335

I think it's obvious that the val is unnecessary and someone
probably just forgot to remove it when they cleaned up that code.
-----

>
>>
>> Signed-off-by: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
>>
>> ----
>>
>> --- linux-2.6.29.1/kernel/sysctl.c.orig 2009-04-16 19:57:21.000000000 +0530
>> +++ linux-2.6.29.1/kernel/sysctl.c      2009-04-16 19:58:26.000000000 +0530
>> @@ -2198,7 +2198,7 @@ static int __do_proc_dointvec(void *tbl_
>>                   void *data)
>
> This is a very old function and have almost no git history, its old name
> was do_proc_dointvec on 2005-04-16 15:20:36 when git tree was made and
> then only(almost) function name is changed.
>
>>  {
>>  #define TMPBUFLEN 21
>> -       int *i, vleft, first=1, neg, val;
>> +       int *i, vleft, first=1, neg;
>>         unsigned long lval;
>>         size_t left, len;
>>
>> @@ -2251,8 +2251,6 @@ static int __do_proc_dointvec(void *tbl_
>>                         len = p-buf;
>>                         if ((len < left) && *p && !isspace(*p))
>>                                 break;
>> -                       if (neg)
>> -                               val = -val;
>
> So you need to do further investigation. Is this a typo or some other
> mistake.

Considering that this function is currently working properly and the
variable 'val' is not used anywhere, it is obvious that removing the
variable will not affect the functionality of the function in any
manner.

It seems that either people haven't noticed this unused variable
before Tomohiro did, or they did not see merit in submitting the
trivial patch. But I believe such code cleanups are required.

If you (maintainers) feel that it is worth it, should I re-submit the patch ?


-- 
Regards,
Sukanto Ghosh
