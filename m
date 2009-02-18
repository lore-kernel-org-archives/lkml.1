Return-Path: <linux-kernel-owner+w=401wt.eu-S1752947AbZBRJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbZBRJfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZBRJf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:35:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:51609 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZBRJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:35:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J6vKNLz5T7YHiRr1mMk1exgu1hUmzoQlysLYYoccKKdKcIdgZlHR/F5poVqv0CBuhv
         j3kTPZ1A2Nmtd48xJTYWVp3LQNv0J77vi5zmSgSy6HEjRjLiwiLZ3gYBJjWuqJhXhnPn
         Sbq2zMFtvqG2rvUlHrn0BjmCMvhmlGx7DjhLM=
Message-ID: <499BD65B.2080307@gmail.com>
Date: Wed, 18 Feb 2009 10:35:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090208 SUSE/3.0b1-7.1 Thunderbird/3.0b2pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       tglx@linutronix.de, x86@kernel.org, oleg@redhat.com
Subject: Re: mmotm 2009-02-17-12-33 uploaded
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org> <499B465D.9080502@gmail.com> <499BD2AE.2020205@gmail.com>
In-Reply-To: <499BD2AE.2020205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.2.2009 10:19, Jiri Slaby wrote:
> On 18.2.2009 00:21, Jiri Slaby wrote:
>> On 17.2.2009 21:33, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2009-02-17-12-33 has been uploaded to
>
> This one:
> kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch

This hunk fixes the problem for me. I have no idea if it is correct though.

diff --git a/kernel/kthread.c b/kernel/kthread.c
index c1c3763..caed471 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -73,6 +73,7 @@ static int kthread(void *_create)

         /* OK, tell user we're spawned, wait for stop or wakeup */
         __set_current_state(TASK_UNINTERRUPTIBLE);
+       create->result = current;
         complete(&create->done);
         schedule();
