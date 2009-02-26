Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbZBZWOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbZBZWOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZBZWOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:14:15 -0500
Received: from www.tglx.de ([62.245.132.106]:48249 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZBZWOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:14:14 -0500
Date: Thu, 26 Feb 2009 23:13:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: mtk.manpages@gmail.com
cc: LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Linux API <linux-api@vger.kernel.org>
Subject: Re: [patch 0/3] add rt_tgsigqueueinfo syscall [RESEND]
In-Reply-To: <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902262311350.9135@localhost.localdomain>
References: <20090226133339.875832967@linutronix.de> <cfd18e0f0902261319v20ba7bd1pcc91ccc4b2c7d577@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

On Fri, 27 Feb 2009, Michael Kerrisk wrote:
> I haven't looked at this iteration of the patch, to check if it is
> different from the version you posted a few months ago.  I assume it
> isn't different, since you didn't mention any differences.  In that
> case, there are still the questions I raised back then, so I'll just
> repeat them now.

Right, no fundamental changes.
 
> Back in October, I did some testing of this interface.  Two potential
> issues that I saw, both of which relate to inconsistencies with
> rt_sigqueueinfo():
> 
> 1) With rt_siqueueinfo(), we can get the PID (TGID) of the sender,
> which enables the receiver of the signal to know who the sender was,
> and perhaps use that information to (for example) send a signal in the
> other direction.
> 
> With rt_tgsigqueueinfo(), we don't quite have that ability: all that
> the receiver gets is the TGID of the sender, not the TID.  This means
> that we can't (for example) send a signal back to the precise thread
> that signaled us. I'm not sure if this matters or not (but perhaps it
> might when sender and receiver are in the same process?).  I'm also
> not sure whether we want to do anything about this (i.e., extending
> siginfo_t to include a si_tid field), but I wanted to point out this
> assymetry w.r.t. to rt_sigqueueinfo(), in case you had not considered
> it.
> 
> 2) With rt_sigqueueinfo(), we can specify the si_pid and and si_uid
> fields that should be sent to the receiver.  This is not possible with
> rt_tgsigqueueinfo(), which always supplied the caller';s PID and UID
> in the si_pid and si_uid fields sent to the receiver.  See the
> following, created using my test programs below (the 111 & 222
> arguments to t_*sigqueueinfo set the si_pid and si_uid fields in the
> siginfo_t given to the *sigqueueinfo() syscall):

I can see your concern, but I have no strong opinion in either
direction. 

Roland ??

Thanks,

	tglx
