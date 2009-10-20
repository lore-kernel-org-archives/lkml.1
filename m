Return-Path: <linux-kernel-owner+w=401wt.eu-S1751752AbZJTKqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbZJTKqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 06:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZJTKqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 06:46:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40204 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZJTKqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 06:46:10 -0400
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>
	<20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr>
	<4ADCDE7F.4090501@librato.com>
	<20091020005125.GG27627@count0.beaverton.ibm.com>
	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 20 Oct 2009 03:46:06 -0700
In-Reply-To: <20091020040315.GA26632@us.ibm.com> (Sukadev Bhattiprolu's message of "Mon\, 19 Oct 2009 21\:03\:15 -0700")
Message-ID: <m1iqeauyvl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
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
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> Eric W. Biederman [ebiederm@xmission.com] wrote:
> | > clone3() seemed to be the leading contender from what I've read so far.
> | > Does anyone still object to clone3() after reading the whole thread?
> | 
> | I object to what clone3() is.  The name is not particularly interesting.
> | 
> | The sanity checks for assigning pids are missing and there is a todo
> | about it.  I am not comfortable with assigning pids to a new process
> | in a pid namespace with other processes user space processes executing
> | in it.
>
> Could you clarify ? How is the call to alloc_pidmap() from clone3() different
> from the call from clone() itself ?

I think it is totally inappropriate to assign pids in a pid namespace
where there are user space processes already running.

> | How we handle a clone extension depends critically on if we want to
> | create a processes for restart in user space or kernel space.
> | 
> | Could some one give me or point me at a strong case for creating the
> | processes for restart in user space?
>
> There has been a lot of discussion on this with reference to the
> Checkpoint/Restart patchset. See http://lkml.org/lkml/2009/4/13/401
> for instance.

Just read it.  Thank you.  Now I am certain clone_with_pids() is
not useful functionality to be exporting to userspace.

The only real argument in favor of doing this in user space is greater
flexibility.  I can see checkpointing/restoring a single thread process
without a pid namespace.  Anything more and you are just asking for
trouble.

A design that weakens security.  Increases maintenance costs.  All for
an unreliable result seems like a bad one to me.

> | The pid assignment code is currently ugly.  I asked that we just pass
> | in the min max pid pids that already exist into the core pid
> | assignment function and a constrained min/max that only admits a
> | single pid when we are allocating a struct pid for restart.  That was
> | not done and now we have a weird abortion with unnecessary special cases.
>
> I did post a version of the patch attemptint to implement that. As
> pointed out in:
>
> 	http://lkml.org/lkml/2009/8/17/445
>
> we would need more checks in alloc_pidmap() to cover cases like min or max
> being invalid or min being greater than max or max being greater than pid_max
> etc. Those checks also made the code ugly (imo).

If you need more checks you are doing it wrong.  The code already has min
and max values, and even a start value.  I was just strongly suggesting
we generalize where we get the values from, and then we have not special
cases. 

Eric

