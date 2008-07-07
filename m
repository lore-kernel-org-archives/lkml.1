Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYGGLIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYGGLIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYGGLIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:08:04 -0400
Received: from saeurebad.de ([85.214.36.134]:38521 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYGGLID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:08:03 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
       davej@codemonkey.org.uk
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com>
	<87y74w41fp.fsf@skyscraper.fehenstaub.lan>
	<4860BB8E.2070505@linux.vnet.ibm.com>
	<87tzfh2t5l.fsf@skyscraper.fehenstaub.lan>
	<48638906.4090308@linux.vnet.ibm.com>
	<87y74l4scd.fsf@skyscraper.fehenstaub.lan>
	<87fxqp7nye.fsf@skyscraper.fehenstaub.lan>
	<4871E657.3040403@linux.vnet.ibm.com>
Date: Mon, 07 Jul 2008 13:07:55 +0200
In-Reply-To: <4871E657.3040403@linux.vnet.ibm.com> (Nageswara R. Sastry's
	message of "Mon, 07 Jul 2008 15:18:07 +0530")
Message-ID: <87d4lqq7ec.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Nageswara R Sastry <rnsastry@linux.vnet.ibm.com> writes:

> Hi Johannes,
>>>> =======================================================
>>>> [ INFO: possible circular locking dependency detected ]
>>>> 2.6.25.7.cpufreq_patch #2
>>>> -------------------------------------------------------
> [...]
>>> Okay, the problem is in cpufreq_conservative.c.  We
>>> cancel_delayed_work_sync() while holding the mutex, but the work itself
>>> tries to grab it and there it deadlocks; lockdep caught that right.
>>>
>>> The hunk for _ondemand is correct, but the one for _conservative is
>>> obviously wrong, sorry :/
>>>
>>> I will whip something up and get back to you.  Thanks a lot for
>>> testing!
>>
>> Could you try the attached patch instead of the one above?
>>
>> Dave, I dropped the mutex-grabbing from the conservative worker function
>> as well as I don't see a reason for it, please correct me if I'm wrong.
>>
>> 	Hannes
>>
>
> The script is running now for more than 6 hours successfully, I will
> continue this and let you know if there are any failures.
>
> * I am seeing the circular locking dependency with the above patch
> too.

Uhm.  Failure or no failure?  A possible dead-lock report _is_ a
failure.  So, do you get one or not?  And if so, could you send me the
dmesg parts?

Thanks a lot,

	Hannes
