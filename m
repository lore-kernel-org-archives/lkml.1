Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYGKIWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYGKIWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYGKIWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:22:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:63711 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYGKIWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o2eVZ8HiPtjBgWPLWjpQXtPJseeiy7S947798TvE4HheUX+07wBX6S6MU3wQWgXjKL
         0MYzK9/0Q1oijFcNYe1OWberijSMuxSjm7G4EniT9jS9aLk1Y/0ItstSZJ27ULCFKwaL
         5tKL9lCHIU79OffOjVtupd1kdtAKellbd9kyc=
Message-ID: <6d291e080807110121t203c7cd0v9c84fb087cd75aa0@mail.gmail.com>
Date: Fri, 11 Jul 2008 03:21:59 -0500
From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH] ioctl conversion
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <200807111008.21497.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d291e080807101728j62be7c93qba11aa214a8dfe1@mail.gmail.com>
	 <200807111008.21497.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 3:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 11 July 2008, Stoyan Gaydarov wrote:
>> -       if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC)
>> +       lock_kernel();
>> +
>> +       if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC) {
>> +               unlock_kernel();
>>                 return -ENOTTY;
>> -       if (_IOC_NR(cmd) > SNAPSHOT_IOC_MAXNR)
>> +       }
>> +       if (_IOC_NR(cmd) > SNAPSHOT_IOC_MAXNR) {
>> +               unlock_kernel();
>>                 return -ENOTTY;
>> -       if (!capable(CAP_SYS_ADMIN))
>> +       }
>> +       if (!capable(CAP_SYS_ADMIN)) {
>> +               unlock_kernel();
>>                 return -EPERM;
>> +       }
>>
>>         data = filp->private_data;
>
> The more common way to express this is to end the function with
>
> out:
>        unlock_kernel();
>        return ret;
> }

This would work normally but there are three early returns and the
rest are just switch statements that set the return code.

>
> and then jump to that label in the error case. This makes it
> much easier to verify that you haven't missed a cased.
>
>        Arnd <><
>
