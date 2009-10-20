Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbZJTDdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbZJTDdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 23:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZJTDdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 23:33:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60046 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274AbZJTDdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 23:33:16 -0400
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oren Laadan <orenl@librato.com>, Daniel Lezcano <daniel.lezcano@free.fr>,
       randy.dunlap@oracle.com, arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>
	<20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr>
	<4ADCDE7F.4090501@librato.com>
	<20091020005125.GG27627@count0.beaverton.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 19 Oct 2009 20:33:10 -0700
In-Reply-To: <20091020005125.GG27627@count0.beaverton.ibm.com> (Matt Helsley's message of "Mon\, 19 Oct 2009 17\:51\:25 -0700")
Message-ID: <m1vdiad9jd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matt Helsley <matthltc@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley <matthltc@us.ibm.com> writes:

> On Mon, Oct 19, 2009 at 05:47:43PM -0400, Oren Laadan wrote:
>> 
>> 
>> Daniel Lezcano wrote:
>> > Sukadev Bhattiprolu wrote:
>> >> Daniel Lezcano [daniel.lezcano@free.fr] wrote:
>> >>   
>> >>> Sukadev Bhattiprolu wrote:
>> >>>     
>> >>>> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
>> >>>>
>
> <snip>
>
>> > Another point. It's another way to extend the exhausted clone  flags as 
>> > the cloneat can be called as a compatibility way, with cloneat(getpid(), 
>> > 0, ... )
>> 
>> Which is what the proposed new clone_....() does.
>
> Just to be clear -- Suka's proposing to extend the clone flags. However I
> don't believe reusing the "pid" parameters as Daniel seemed to suggest
> was ever part of Suka's proposed changes.
>
> <snip>
>
>> > I don't really see a difference between sys_restart(pid_t pid , int fd, 
>> > long flags) where pid_t is the topmost in the hierarchy, fd is a file 
>> > descriptor to a structure "pid_t * + struct clone_args *" and flags is 
>> > "PROCTREE".
>
> I think the difference has to do with keeping the code maintainable.
>
> Clone creates the process so it's already involved in allocating and
> assigning pids to the new task. Switching pids at sys_restart() would 
> add another point in the code where pids are allocated and assigned.
> This suggests we may have to worry about introducing new obscure races
> for anyone who's working on the pid allocator to be careful of. At
> least when all the code is "localized" to the clone paths we can be
> reasonably certain of proper maintenance.
>
> <snip>
>
>> I really really really hope we can settle down on *a* name,
>> *any* name, and move forward. Amen.
>
> clone3() seemed to be the leading contender from what I've read so far.
> Does anyone still object to clone3() after reading the whole thread?

I object to what clone3() is.  The name is not particularly interesting.

The sanity checks for assigning pids are missing and there is a todo
about it.  I am not comfortable with assigning pids to a new process
in a pid namespace with other processes user space processes executing
in it.

How we handle a clone extension depends critically on if we want to
create a processes for restart in user space or kernel space.

Could some one give me or point me at a strong case for creating the
processes for restart in user space?

The pid assignment code is currently ugly.  I asked that we just pass
in the min max pid pids that already exist into the core pid
assignment function and a constrained min/max that only admits a
single pid when we are allocating a struct pid for restart.  That was
not done and now we have a weird abortion with unnecessary special cases.

Eric
