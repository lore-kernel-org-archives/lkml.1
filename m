Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYGaTxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYGaTxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbYGaTxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:53:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55431 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYGaTxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:53:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080731170022.GE9663@sgi.com>
	<m1prot297c.fsf@frodo.ebiederm.org> <20080731193204.GG9663@sgi.com>
Date: Thu, 31 Jul 2008 12:49:35 -0700
In-Reply-To: <20080731193204.GG9663@sgi.com> (Robin Holt's message of "Thu, 31
	Jul 2008 14:32:04 -0500")
Message-ID: <m1iqul25rk.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Robin Holt <holt@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0162]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on num_possible_cpus().
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

> On Thu, Jul 31, 2008 at 11:35:19AM -0700, Eric W. Biederman wrote:
>> Robin Holt <holt@sgi.com> writes:
>> 
>> > For large cpu configurations, we find the number of pids in a pidhash
>> > bucket cause things like 'ps' to perform slowly.  Raising pidhash_shift
>> > from 12 to 16 cut the time for 'ps' in half on a 2048 cpu machine.
>> >
>> > This patch makes the upper limit scale based upon num_possible_cpus().
>> > For machines 128 cpus or less, the current upper limit of 12 is
>> > maintained.
>> 
>> It looks like there is a magic limit we are dancing around.
>> 
>> Can we please make the maximum for the hash table size be based
>> on the maximum number of pids.  That is fls(PID_MAX_LIMIT) - 6?
>
> I am happy to base it upon whatever you think is correct.  So long as it
> goes up for machines with lots of cpus, that will satisfy me.  It is
> probably as much a problem on smaller machines, but if you have _THAT_
> many pids in use, you are probably oversubscribing many other resources
> and don't really care.  That limit will essentially become a constant
> (compiler may even do that for us but I have not checked any arch other
> that ia64).  Should I just replace the 12 with a 16 or 17 or some new
> magic number?

I like setting the limit as a maximum hash chain length.
Which is what fls(PID_MAX_LIMIT) - X is.  X is the maximum hash chain
length you can tolerate.

Eric

