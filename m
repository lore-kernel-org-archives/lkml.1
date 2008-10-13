Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbYJMUcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbYJMUcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYJMUcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:32:11 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:65132 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbYJMUcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:32:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wAqbtOp934QgWvxTmmXb3Cm7kjYOtRNOvNdENE7ApixcU27WIk15HPeEXrN5JrMeSE
         GfEP3b54r6eXgTiu3x49I9JBbs3VqBzLUplpnLg7b6Zilns2x00UmkRj20jHRHrZswjU
         A36msV+Fx2AOr2PIhsZdFtA+ZOXpVfvooOxAo=
Message-ID: <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>
Date: Mon, 13 Oct 2008 13:32:08 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 - fix v7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com, jbarnes@virtuousgeek.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080904190457.GB24990@elte.hu>
	 <20080904121627.bc182da7.akpm@linux-foundation.org>
	 <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com>
X-Google-Sender-Auth: 5148047fa4254c25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 12:22 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Sep 4, 2008 at 12:16 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Thu, 4 Sep 2008 21:04:57 +0200
>> Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> +             printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
>>> +                      conflict->name, conflict->start, conflict->end,
>>> +                      name, start, end);
>>
>> start and end have type resource_size_t.  Such types CANNOT be printed
>> unless cast to a known type.
>>
>> Because there is a %s following an incorrect %lld, the above code will
>> crash the machine.
>
> should just remove those lines.

This didn't happen.  These lines are still in the version that went into
Linus' tree over the weekend for 2.6.28.  On the ia64 build they spit
out a bunch of warnings:

kernel/resource.c:554: warning: format '%llx' expects type 'long long
unsigned int', but argument 3 has type 'resource_size_t'

Ditto for args 4, 6 and 7 on the same line.

-Tony
