Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYLBLsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYLBLsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 06:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYLBLsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 06:48:37 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:37193 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbYLBLsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 06:48:36 -0500
Date: Tue, 2 Dec 2008 12:48:33 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 3/5] Determine if sender is from ancestor ns
Message-ID: <20081202114833.GA1132@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
	ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
	linux-kernel@vger.kernel.org, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034611.GC23238@us.ibm.com> <20081127010101.GA13545@wavehammer.waldi.eu.org> <20081201201506.GB12493@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081201201506.GB12493@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 12:15:06PM -0800, Sukadev Bhattiprolu wrote:
> Bastian Blank [bastian@waldi.eu.org] wrote:
> | If I see this correctly this information is already covered in si_code
> | with SI_USER and SI_TKILL. SI_KERNEL is used for explicit kernel
> | generated signals.
> 
> Yes, but si_code from sys_rt_sigqueueinfo() cannot be trusted.

sys_rt_sigqueueinfo disallows setting si_code to any value which
describes kernel signals from userspace. So using SI_FROMUSER should be
sufficient.

> IOW, we need to find the namespace of the sender only if the sender is
> a user process. If signal is originating from kernel, safely checking
> namespace becomes more complex.

Where does this imply checking sender for kernel generated signals?

> Yes, current approach is somewhat hacky. We tried other approaches
> before and they were either intrusive or required non-trivial changes
> to semantics of signals to global init or both.

Message-IDs?

> | > +static inline int siginfo_from_ancestor_ns(struct task_struct *t,
> | > +			siginfo_t *info)
> | > +{
> | > +	if (!is_si_special(info) && (info->si_signo & SIG_FROM_USER)) {
> | > +		/* if t can't see us we are from parent ns */
> | What?
> I assume your question is about the comment :-)

Yes.

> Yes, a process can see all its descendants and processes in descendant
> namespaces. But it can only see its ancestors upto the most recent
> CLONE_NEWPID. (kind of like chroot in filesystems). So if receiver
> can't see sender, sender must be an ancestor.

Please add a complete comment to the function which describes the
function. And don't us "it" for not defined entities.

Bastian

-- 
I have never understood the female capacity to avoid a direct answer to
any question.
		-- Spock, "This Side of Paradise", stardate 3417.3
