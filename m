Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZJDMP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZJDMP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZJDMPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:15:25 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:56095 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZJDMPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:15:24 -0400
Message-ID: <4AC891B4.20407@msgid.tls.msk.ru>
Date: Sun, 04 Oct 2009 16:14:44 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14270] Cannot boot on a PIII Celeron
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>	 <COE24pZSBH.A.7sH.xMTxKB@chimera>	 <aa79d98a0910020130p4d3c5b5fh9597ea435db7f872@mail.gmail.com>	 <4AC5C42E.9070909@msgid.tls.msk.ru>	 <4AC5D810.3080307@msgid.tls.msk.ru> <aa79d98a0910020355r31b37ea0v1fef7286f7a71508@mail.gmail.com> <4AC5DCFD.4010107@msgid.tls.msk.ru>
In-Reply-To: <4AC5DCFD.4010107@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Cyrill Gorcunov wrote:
>> On 10/2/09, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>> Michael Tokarev wrote:
>>>> Cyrill Gorcunov wrote:
>>>>> On 10/1/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>>>> This message has been generated automatically as a part of a report
>>>>>> of regressions introduced between 2.6.30 and 2.6.31.
>>>>>>
>>>>>> The following bug entry is on the current list of known regressions
>>>>>> introduced between 2.6.30 and 2.6.31.  Please verify if it still 
>>>>>> should
>>>>>> be listed and let me know (either way).
>>>>> Michael has been asked to bisect it (if possible). I cant reproduce it
>>>>> in kvm unfortunately.
>>>> Yes, and that's what I'll be trying to do shortly.
>>>> I had other issues to sort out and wasn't able to
>>>> get to it in few last days.
>>>>
>>>> Also I've a few other suspects.  For example, in this .31
>>>> config I changed from bzip to lzma compression - and that's
>>>> where (or near) kernel is rebooting.
>>> And that was the problem.  After switching from LZMA
>>> to BZIP2 kernel boots again.
>>>
>>> Dunno if it can be treated as a regression, but it's
>>> definitely a bug.
>>
>> thanks for tracking it down Michael!
>> Rafael, who is responsible for LZMA now?
>> Cc him please.
> 
> Please hold on for a while.
> 
> I switched to BZIP2, it booted fine.  I switched back to LZMA -
> and that one now boots too.  Original bzImage, which were built
> by the same compiler from the same source using the same
> options reboots.
> 
> So um... I'm now trying to reproduce it ;)

I performed about 20 kernel recompiles, and finally have some "statistics".
The problem is almost reproduceable, in a sense that I was able to get 6
more cases behaving the same way (rebooting right at early boot on a cel).
And all 3 "non-working" cases were with ccache.  Ie, about half out of ~25
compiles done with ccache, and 7 of the resulting kernels are buggy.  No
single failure without ccache so far.

Maybe it's some stale .o file cached by ccache (and it indeed looks like
that) -- I didn't try to remove the cache yet (but my guess is that I
wont be able to reproduce the issue with clean cache anymore).

What puzzles me most is the "failure mode".  The difference between the
two processors is minimal.  Having a corrupt .o file and almost-working
kernel is almost impossible by its own.  And hitting this difference with
a corrupt .o file is.. unbelievable.

So I'm declaring it's a false alarm for now, and closing the bug.

/mjt
