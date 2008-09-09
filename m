Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYIISpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYIISpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYIISpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:45:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:17751 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYIISpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=sDMqGEGlr2q8yj9aNzpPF+kmesIzQHcaOtJYx5uVrwMfS9aqyKxtnTXYVf/eUMINUv
         4ozw8/lvLwuteATxNfAGlhWB/NPMEVn7Y+VRu00QdReUbHSPneL/WiPXkXH8L7gQBm+4
         fT4B1KYcC76zH60RksW1Pb5YZcICJW3IU65bE=
Message-ID: <cfd18e0f0809091145v2e078a26lce61f299e166de6e@mail.gmail.com>
Date: Tue, 9 Sep 2008 20:45:31 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce PRIO_THREAD extension
Cc: "Denys Vlasenko" <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <48C6A78A.8090401@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220278355.3866.21.camel@localhost.localdomain>
	 <517f3f820809090845o5dc772f8r2308a6c010f69561@mail.gmail.com>
	 <48C6A78A.8090401@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Sep 9, 2008 at 6:42 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> Michael Kerrisk wrote:
>
>> On 9/1/08, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>>>
>>> Since there may be programs which use the fact that
>>>
>>> setpriority(PRIO_PROCESS, tid, value)
>>>
>>> prior to this patch was setting priority for selected thread,
>>> this behavior is retained in case when tid != pid.
>>>
>>> IOW: with PRIO_PROCESS, if pid specifies a thread group leader,
>>> all threads' prios are set. Otherwise, only selected thread's priority
>>> is set. (Alternative can be to just fail with ESRCH).
>
>
>> I would expect
>> setpriority(PRIO_PROCESS, getpid())
>> and
>> setpriority(PRIO_PROCESS, 0)
>> to have the same affect (because: which == PRIO_PRCESS, who == 0
>> conventionally means "the calling process").
>>
>> But they do not: the latter call only changes the priority of the
>> calling thread.  Is this intended?
>
> The patch interprets 0 as the current pid rather than the current tgid.
> It's up for discussion whether we should preserve old behaviour when
> specifying 0, or use a new and arguably more logical behaviour but possibly
> break old apps.

AFAICS, interpreting 0 as the TGID would be more consistent with those
parts of the interface that are specified by POSIX.1.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
