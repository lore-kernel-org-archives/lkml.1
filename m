Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbZA0TiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbZA0TiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZA0Th7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:37:59 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34567 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZA0Th6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:37:58 -0500
To: Mike Snitzer <snitzer@gmail.com>
Cc: Dave Anderson <anderson@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Bernhard Walle <bwalle@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       crash-utility@redhat.com
Subject: Re: BISECTED: Re: source line numbers with x86_64 modules?
References: <170fa0d20901270909v45bec3bao38944a9aca6347d9@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Jan 2009 11:38:00 -0800
In-Reply-To: <170fa0d20901270909v45bec3bao38944a9aca6347d9@mail.gmail.com> (Mike Snitzer's message of "Tue\, 27 Jan 2009 12\:09\:19 -0500")
Message-ID: <m18wowczfr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer <snitzer@gmail.com> writes:

> [I've trimmed the wide cc distribution that was inherited when I
> forked a different thread]
>
> On Mon, Jan 12, 2009 at 10:19 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> "Mike Snitzer" <snitzer@gmail.com> writes:
>>>
>>> Now if only I could fix line numbers when debugging crashes in x86_64
>>> modules with the crash utility! :)
>>
>> It's a userspace problem...
>>
>> All of the little usability things are userspace problems.
>>
>> I won't claim that it is trivial because it is a userspace problem, at the
> same
>> time there is no reason to wait for any kernel features to merge etc.  Someone
>> just has to scratch an itch and go fix it.
>
> Yes, the crash utility (userspace) is clearly having problems getting
> line number for symbols in x86_64 modules.  But I finally took some
> time to bisect the point in the kernel where the crash utility first
> started to fail, it appears to be:
>
> commit 7460ed2844ffad7141e30271c0c3da8336e66014
> Author: john stultz <johnstul@us.ibm.com>
> Date:   Fri Feb 16 01:28:21 2007 -0800
>
> I used version 4.0-7.6 of the crash utility to test if each commit was
> good or bad.  I simply checked if ext3's module had correct line
> number info for the ext3_get_blocks_handle symbol with: sym
> ext3_get_blocks_handle

Weird.  That patch doesn't appear to affect anything in that area.
So my stab in the dark is that there is something in vmlinux that
crash doesn't know how to cope with.

> I tried to revert 7460ed2844ffad7141e30271c0c3da8336e66014 from
> v2.6.21 but it had conflicts that I've not yet been able to put
> adequate time to resolving.
>
> That aside, I'd be very interested to know how/where this commit is
> impacting the crash utility.  Has alignment of some module metadata
> structure been altered and that is the problem?  This isn't my area of
> expertise but I have to believe others may have useful insight.

Eric
