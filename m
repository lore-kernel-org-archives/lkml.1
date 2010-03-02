Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0CBPIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:08:23 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:57789 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0CBPIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:08:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g18MKKyr4K5gi0bEIHz8gchq/0H28ad494Typs2o4Z3t2pgLIfNtiQLOvufIu5p9+J
         zJWKpTgttfgD5GrrIn36q3S2poFPmBTn5hCOJgOxTXP7s74ryKg/4MiY6gLdNGEI5cbd
         i1DZ9rrVMTXy+So61xTvvG9W0sZ8TYKKAhoxM=
MIME-Version: 1.0
In-Reply-To: <20100302085046.GA27023@linux.vnet.ibm.com>
References: <f5a7b3811002250545x3d5288cfqd114d3bcd79581f2@mail.gmail.com>
	 <20100302085046.GA27023@linux.vnet.ibm.com>
Date: Tue, 2 Mar 2010 20:38:20 +0530
Message-ID: <f5a7b3811003020708wdd0710fv4c3e1dcf1992935c@mail.gmail.com>
Subject: Re: [LTP] [PATCH] Synchronization required before release the lock: 
	sem_post/8-1.c
From: naresh kamboju <naresh.kernel@gmail.com>
To: Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ltp-list <ltp-list@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 2:20 PM, Rishikesh K Rajak
<risrajak@linux.vnet.ibm.com> wrote:
> On Thu, Feb 25, 2010 at 07:15:42PM +0530, naresh kamboju wrote:
>> Hi,
>>
>> I have found abnormal behavior of sem_post/8-1.c test case under posix.
>> This test case passes in some times and failed in many times :-(
>> Patch includes
>> 1.    Reverting back changes made by mreed on Sep 25 2006. Making sure
>> child has been waiting for the lock (below Refs).
>> 2.    using sleep in while loop is not a good idea, so sleep is removed
>> from while loop
>> 3.    For the synchronization I have added sleep before releasing the lock.
>>
>> Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.com >
>
> Looks good to me though i needed few clarification below.
>
> Acked-By: Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
>
>> ---
>>  testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
>> |   15    8 +     7 -     0 !
>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> Index: b/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
>> ===================================================================
>> --- a/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
>> +++ b/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
>> @@ -161,7 +161,6 @@ int main()
>>         }
>>         fprintf(stderr, "P: child_1:%d forked\n", c_1);
>>
>> -       sleep(1);
>>         c_2 = fork();
>>         if (c_2 == 0)
>>         {
>> @@ -176,13 +175,13 @@ int main()
>>         }
>>         fprintf(stderr, "P: child_2: %d forked\n", c_2);
>>
>> +        /* Step 3 Implementation */
>>         /* Make sure the two children has been waiting */
>> -       /*do {
>> -               sleep(1);
> I feel before getting semaphore value, we need to sync first so here
> sleep is require,though your point is valid that there is no use of
> using sleep inside while loop.
I agree with you.
AFAIU, we should call sleep() before calling getting semaphore
value.when we don't have while loop here. Because while loop condition
is depends on val so when ever we call sem_getvalue() it will get
latest value of val.
In addition to this, we are ensuring val is decremented before we do
unlock the sem by while loop condition.

Having sleep() in while loop will not effect the final output. IIUC

Best regards,
Naresh Kamboju
>> Please review this patch and let me know if you have any issues.
>>
>> Best regards
>> Naresh Kamboju
> --
> Thanks & Regards
> Rishi
> LTP Maintainer
> IBM, LTC, Bangalore
> Please join IRC #ltp @ irc.freenode.net
