Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbZEUOWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbZEUOWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZEUOWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:22:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54722 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZEUOWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:22:44 -0400
Message-ID: <4A156361.2040507@zytor.com>
Date: Thu, 21 May 2009 07:21:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on	several
 CPUs
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com> <20090519172449.GB18874@aftab> <4A1392A9.9010609@zytor.com> <20090520144905.GA27991@aftab> <4A147891.5000906@zytor.com> <20090521140800.GA3462@aftab>
In-Reply-To: <20090521140800.GA3462@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
>>>
>> smp_call_function_many() does allow concurrent execution.
> 
> Well, IMHO, not an absolutely concurrent execution since you can't
> control at what moment in time the IPIs will be executed on each core,
> IOW, the respective call function IPIs will generally not coincide on
> each core at a given moment in time. This is especially true if you're
> sending IPIs to cores across nodes.
> 
> And there's hypothetically a small window where you might get an
> inconsistent MSR content across cores. It's a whole another question
> whether this is going to be relevant.
> 

It *allows* concurrent execution.  It doesn't *guarantee* concurrent
execution.  Looping with smp_call_function_one() means we wait for
synchronization after ever one.

>> Looping over a list with smp_call_function_one() -- which you
>> currently have -- is serializing, at which point we might just push
>> the loop into the caller rather than worrying about a new interface.
> 
> So, the actual question is do we need that done in msr.c? If there are
> no potential users, I could easily do the whole thing in the driver and
> do not touch x86 code.

Only if we care about the additional performance of having it be
nonserializing.

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

