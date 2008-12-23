Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbYLWAh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbYLWAh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYLWAhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:37:14 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54722 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYLWAhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:37:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, roland@redhat.com, bastian@waldi.eu.org, daniel@hozac.com,
       xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 0/6][v3] Container-init signal semantics
References: <20081221005106.GA4912@us.ibm.com>
	<m1wsds5vij.fsf@frodo.ebiederm.org> <20081222194737.GC9085@us.ibm.com>
Date: Mon, 22 Dec 2008 16:27:32 -0800
In-Reply-To: <20081222194737.GC9085@us.ibm.com> (Sukadev Bhattiprolu's message
	of "Mon, 22 Dec 2008 11:47:37 -0800")
Message-ID: <m1aban68i3.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
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

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> Eric W. Biederman [ebiederm@xmission.com] wrote:
>
> | 
> | - container-init is responsible for setting the rest of the signals
> |   to SIG_IGN.
>
> Oleg pointed out that we could drop SIG_DFL signals to global init early
> to ensure wait_for_completion_killable/lock_page_killable don't incorrectly
> believe that a fatal signal is pending. (patch 2/6).
>
> If that patch is valid regardless of containers, it would be a minor
> extension to get container-inits to drop SIG_DFL signals too, right ?

Yes.

> So the bigger problem/unknown for me is the sig_from_user() in patch 4/6
> (i.e determining if it safe to deref the pid-ns of sender). We went from
> !in_interrupt() to the SIG_FROM_USER flag to this.
>
> If that is correct, I am hoping it would come down to opitmizing the code
> if possible (eg: can/should we avoid passing same_ns into sig_ignored()
>
> There is probably some ugliness :-) but do you see any other correctness 
> issues ?

I haven't dug in too deep but right now my concern are user space semantics,
I don't want to wind up with something ugly there because we can not change
it later.

So if we can write a description of what happens to signals to cinit
that is right 100% of the time.  Something we can write a test case
for that tests all of the corner cases and it always get the same
results. I am happy.

I don't mind dropping signals early as an optimization, but if it
is just an optimization we can't count on it in cinit.

So I would rather deliver less and make user space deal with it,
then deliver more cause problems for user space.

Eric
