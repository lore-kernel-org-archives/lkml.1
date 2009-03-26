Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZCZBcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZCZBcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 21:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZCZBcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 21:32:22 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:30036 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZCZBcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 21:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jMDGgPq6ibiixsdAEegvm10v7doOZUGmz4q1N41q7J2bNTgGGzD6m02v45mGVaU3Ze
         HXFZ2xyo4+QLa1c5NhYtegNNwM422h3Sb/kzyE/YCo3ZFuMWRr/NH6+zkv67P5YcR9ge
         /bf2z83H0AP3nSTncX6M5y06+IimeD+BXzLtc=
Message-ID: <49CADB45.3090501@gmail.com>
Date: Thu, 26 Mar 2009 10:32:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alex Chiang <achiang@hp.com>, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
References: <20090325035707.15921.42150.stgit@bob.kio>	<m13ad2xi46.fsf@fess.ebiederm.org>	<20090325225414.GA11447@ldl.fc.hp.com> <m17i2dunao.fsf@fess.ebiederm.org>
In-Reply-To: <m17i2dunao.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
>>> Fixing a read/writer deadlock by allowing the writers to nest
>>> inside the readers.
>>>
>>> My first impression is that it is too clever.
>> Clever points go to Tejun. All I did was refresh the series
>> slightly. :)

Thanks for the points.  I do agree that it could be a bit too clever,
but the thing is that protecting the code area from going underneath
something is a pretty special thing to begin with and I think it's
better to apply special solution rather than trying to work around it
using general mechanisms.  So, I actually think the global inhibit
thing is one of the better ways to deal with the nasty-in-nature
problem.

>>> My hypothesis is once we solve this for the general case of
>>> device hotplug and removal we won't need special support from
>>> sysfs.  At least not in the suicidal way.
>> I agree that we have problems in our infrastructure, especially,
>> as you point out, overlapping device trees, etc.

I don't really see how some grand general solution would solve
deadlock problem at sysfs layer, care to elaborate a bit?

>> I see your point about adding extra cruft into sysfs to work
>> around a special case while leaving the hard problem unsolved.
>>
>> Perhaps the status quo is better. I do think that getting
>> suicidal sysfs attributes off the global workqueue is a band-aid
>> that actually helps, vs. the proposed patches here which are
>> questionable in nature.
> 
> Sounds like it.    I'm not trying to shoot this down, rather
> I'm trying to figure out how to solve this cleanly, as I am slowly
> trying to sort out the pci hotplug and unplug issues.

The problem I see is that there aren't too many users and the solution
is a bit too narrow focused, but with increasing support for
hotplug/unplug, I think the problem is becoming more widespread and
the workqueue solution is quite fragile and cumbersome for each and
every user, so unless there are other directions we can pursue (the
general one above maybe?), I think it's better to add a bit of
complexity to sysfs rather than forcing everyone user of it to do it.

Thanks.

-- 
tejun
