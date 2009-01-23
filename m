Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbZAWDYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbZAWDYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 22:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZAWDYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 22:24:17 -0500
Received: from smtp-out.google.com ([216.239.33.17]:41303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZAWDYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 22:24:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=KTWsnFnF9q5y+k/4xSp/Qisq1CxWq4f/qsRWXXHeTa/QRKnXhoaVhyJ0dlvKwDVfP
	dJfCW6jhQ5/6CLZs9S+tw==
MIME-Version: 1.0
In-Reply-To: <20090122195513.GA22146@google.com>
References: <20090122083457.GC7438@elte.hu> <20090122195513.GA22146@google.com>
Date: Thu, 22 Jan 2009 19:21:09 -0800
Message-ID: <1fe6c7900901221921m586b129dwf8c3446f897b57f0@mail.gmail.com>
Subject: Re: [PATCH v3] softlockup: remove hung_task_check_count
From: Mandeep Baines <msb@google.com>
To: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.146
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 11:55 AM, Mandeep Singh Baines <msb@google.com> wrote:
>
> The unlock and lock could be removed and only compiled in if PREEMPT.
> If the number of tasks isn't bound, the lock might be held too long.
>

This is incorrect. The adding the lock and unlock will not make the
system more pre-emptive. To be more pre-emptive you'd want to check
need_resched() as often as possible.

> It would be kinda funny if hung_task caused a softlockup.
>

Again. This is incorrect. Rescheduling if need_resched() will prevent
softlockup.

Not sure what I was thinking this morning;)

However, I am happy with the patch. To give writers a chance, the lock
should held for bounded time. Holding the lock in khungtask (which is
running at low scheduler priority) could potentially be delaying
important work. The longer the lock is held, the bigger the priority
inversion problem.
