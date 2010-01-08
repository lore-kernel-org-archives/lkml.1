Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065Ab0AHTti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0AHTti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977Ab0AHTti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:49:38 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45449 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab0AHTth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:49:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cgsjWYNxuy7Oro5u3lFNcMsfnFhQVpyQE7ruNlYoet16csqJ6KNl5hevS79UgY7tcs
         g5lKwD6+kjpXdLobZ6VT0LgzHy9asx5hi1XZnWVyvbnGTOpo8oN4d41F4GDqhMFtcDmk
         vA4T2ViHRXUonIkS8xIguqWKRY5xTdZiBifZQ=
MIME-Version: 1.0
In-Reply-To: <m1bph4o1il.fsf@fess.ebiederm.org>
References: <1262951595-1729-1-git-send-email-yinghai@kernel.org>
	 <1262951595-1729-5-git-send-email-yinghai@kernel.org>
	 <m1bph4o1il.fsf@fess.ebiederm.org>
Date: Fri, 8 Jan 2010 11:49:36 -0800
X-Google-Sender-Auth: 467b9b5596618e09
Message-ID: <86802c441001081149k1be26027m62752604dca53aa@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86: update nr_irqs according cpu num
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 11:11 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> that is max number on run time.
>
> Ouch!  Unless I misread this code this will leave nr_irqs at
> NR_IRQS_LEGACY. aka 16.

nr_irqs is set to NR_IRQS before.

>
> Let's do something stupid and simple.
> nr_irqs = nr_cpus_ids * 256;  /* Semi-arbitrary number */
>
> Ideally we would set "nr_irqs = 0x7fffffff;" but we have just enough
> places using nr_irqs that I think those loops would get painful if we
> were to do that.

or you need have NR_IRQS = NR_CPUS * 256 at first,

and then make nr_irqs = nr_cpu_ids * 224 ?

YH
