Return-Path: <linux-kernel-owner+w=401wt.eu-S1161325AbXBUQNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161325AbXBUQNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161327AbXBUQNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:13:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:25978 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161325AbXBUQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:13:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=U4zXe8VKorq8bN1ZgfwUtNBQNq9a/7mEWwTkd1ijbXCWM0KvRHW6/Zh3wyXFe5IGpJG8Z/Erc09F002nRtbPHHTAeTOP2zDAbeGO5TKIOUGdnKf11gy56T6uJ1hI19U0Qh/UKFMzXVP6ycaCdPlkIRyE3By3tPcsEFU3HmCk9lo=
Message-ID: <a2ebde260702210813h14bc98b6s8c4c8c560c3647ff@mail.gmail.com>
Date: Thu, 22 Feb 2007 00:13:43 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: The purpose and implementation of cond_resched()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about cond_resched().

What is the condition under which I should invoke cond_resched() irreplaceably?

For example, I see the following code in ksoftirqd(),

preempt_enable_no_resched();
cond_resched();
preempt_disable();

But I do not understand why I should not write the following code,

preempt_enable();
preempt_disable();

Are the above two pieces of code equal in functionality?

On the other hand, I see cond_resched() check and set PREEMPT_ACTIVE.
I currently do not understand why it should do this, since I think
PREEMPT_ACTIVE is only used to be set in the return-from-interrupt
code in order to prevent schedule() from removing task from run queue
unpredictably. But for cond_resched(), which is a planned voluntary
switch, why does it also deal with this flag?
