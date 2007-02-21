Return-Path: <linux-kernel-owner+w=401wt.eu-S1422709AbXBURI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422709AbXBURI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422708AbXBURI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:08:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:26431 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422709AbXBURI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:08:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=plm7r9ig6T3K4QP81ILKKlHdZEWlBUdpM1G/dpLOXKIz8auLCDbd3XFnCXlJe8bID2HZGLjsFkxc9Q+HEEkEsPSw5eZm0gCWBQb4EIfqeE2yEL8BBlFpx5J2r5PY5/fk3hDMjvqJqpAOcfsMadO2eU/dUNNTofPI4FSgm0rOuHs=
Message-ID: <a2ebde260702210908o52b93002u19e8200b6b56ae5a@mail.gmail.com>
Date: Thu, 22 Feb 2007 01:08:25 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: The purpose and implementation of cond_resched()
In-Reply-To: <a2ebde260702210813h14bc98b6s8c4c8c560c3647ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a2ebde260702210813h14bc98b6s8c4c8c560c3647ff@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I re-checked the code. And this time, I think cond_resched() is useful
while a kernel is compiled with no full preemption function but only
voluntary kernel preemption is enabled (i.e. CONFIG_PREEMPT_VOLUNTARY
is set but CONFIG_PREEMPT is not set). In this case, kernel performs
scheduling at explicit voluntary preemption points only, and those
points are determined by invoking cond_resched().

But I still have questions, why cond_resched() does not yield no-op
while CONFIG_PREEMPT is set? And why does it deal with the
PREEMPT_ACTIVE flag anyway?



2007/2/22, Dong Feng <middle.fengdong@gmail.com>:
> I have a question about cond_resched().
>
> What is the condition under which I should invoke cond_resched() irreplaceably?
>
> For example, I see the following code in ksoftirqd(),
>
> preempt_enable_no_resched();
> cond_resched();
> preempt_disable();
>
> But I do not understand why I should not write the following code,
>
> preempt_enable();
> preempt_disable();
>
> Are the above two pieces of code equal in functionality?
>
> On the other hand, I see cond_resched() check and set PREEMPT_ACTIVE.
> I currently do not understand why it should do this, since I think
> PREEMPT_ACTIVE is only used to be set in the return-from-interrupt
> code in order to prevent schedule() from removing task from run queue
> unpredictably. But for cond_resched(), which is a planned voluntary
> switch, why does it also deal with this flag?
>
