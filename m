Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYG2Th4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYG2Th4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYG2Ths
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:37:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:26740 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYG2Thr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:37:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DgCBBA3LZqAZkBdGPexS534qdlQDfaTyqPWHwEG4Weu+JeFjcpI2pv92u3T2see+0W
         Q5Ir/fYN2J8qMGcjIji/gi6UAahTD5AEkGjNzoJyCW+gly9NIsOJkTuWA0jbEVXjip/K
         i8WCDNcNrInFytu3bMNc6ZG6qZnjQFrNZcU/8=
Message-ID: <b647ffbd0807291237x40df3f66w62021f298ae8afe0@mail.gmail.com>
Date: Tue, 29 Jul 2008 21:37:46 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Cc: "Peter Oruba" <peter.oruba@amd.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <488F581B.7060009@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729154103.007575982@amd.com>
	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>
	 <488F581B.7060009@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/29 Max Krasnyansky <maxk@qualcomm.com>:
> Dmitry Adamushko wrote:
>>
>> 2008/7/29 Peter Oruba <peter.oruba@amd.com>:
>>>
>>> Fixed coding style issues.
>>
>> I have a comment on the abstraction layer (microcode_ops).
>>
>> [ Not that I've looked very carefully at it so far, nor I pretend to
>> be at-ease with this 'microcode' topic to make any design judgements
>> :-) ]
>>
>> but would it be somehow possible to not have set_cpus_allowed_ptr()
>> code in arch-dependent parts? Let's say the mechanism of how to run
>> certain arch-specific code (and synchronization) on a given cpu should
>> be a prerogative of (and placed in) the generic part...
>>
>> Note, this code will likely happily give you an oops if you run
>> cpu_down/up() ;-)
>>
>> I also wondered, is there a requirement that when a new cpu is brought
>> up, microcode updates {should,must} be done as early as possible, say
>> before any tasks have a chance to run on it? Or can the update be a
>> bit delayed? e.g. we don't do it from cpu-hotplug handlers.
>
> Dmitry looks like you missed my email. I already asked that question and
> proposed a couple of options (workqueue and ipi).
> Tigran said that he does not know. Maybe Peter does.
>
> My guess is that it does not have to be done synchronously and can be
> delayed. There is no guaranty that microcode CPU hotplug handler will run
> before all the other handlers. Which by definition means that some things
> will start running on the cpu before the microcode is updated.

yes.

> Hence we
> might as well do the update outside of the cpu hotplug path.

but it doesn't necessarily mean that it was correct before (I mean,
maybe some assumptions were made about cpu-hotplug handlers :-)



>
> Max
>

-- 
Best regards,
Dmitry Adamushko
