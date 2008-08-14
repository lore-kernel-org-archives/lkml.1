Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYHNPGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYHNPGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYHNPGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:06:12 -0400
Received: from saeurebad.de ([85.214.36.134]:43506 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYHNPGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:06:11 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: jmerkey@wolfmountaingroup.com
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2.6.27-rc3 26/29] mdb: export task_curr
References: <200808140614.m7E6EcDS006264@wolfmountaingroup.com>
	<84144f020808140139v691e6590idd79995168af4e9e@mail.gmail.com>
	<44303.166.70.238.45.1218724556.squirrel@webmail.wolfmountaingroup.com>
Date: Thu, 14 Aug 2008 17:05:47 +0200
In-Reply-To: <44303.166.70.238.45.1218724556.squirrel@webmail.wolfmountaingroup.com>
	(jmerkey@wolfmountaingroup.com's message of "Thu, 14 Aug 2008 08:35:56
	-0600 (MDT)")
Message-ID: <87y72z63hw.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com writes:

>> On Thu, Aug 14, 2008 at 9:14 AM,  <jmerkey@wolfmountaingroup.com> wrote:
>>> export the task_curr function to the module based kernel debugger to
>>> enable
>>> process back tracing and state display.
>>>
>>> Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)
>>>
>>> --- a/kernel/sched.c    2008-08-13 14:22:32.000000000 -0600
>>> +++ b/kernel/sched.c    2008-08-13 11:56:03.000000000 -0600
>>> @@ -1736,6 +1736,9 @@
>>>  {
>>>        return cpu_curr(task_cpu(p)) == p;
>>>  }
>>> +#if defined(CONFIG_MDB_MODULE)
>>> +EXPORT_SYMBOL_GPL(task_curr);
>>> +#endif
>>
>> We usually don't export symbols conditionally, especially in core kernel
>> code.
>>
>
> Well,then please suggest how a kernel debugger can be module based and still
> be able to get this information some other way that's generic and minimal
> impact.

EXPORT_SYMBOL_GPL(task_curr);

Without the #if's.  Just export it.

	Hannes
