Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZEKCal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZEKCal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZEKCad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:30:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56485 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbZEKCac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:30:32 -0400
Message-Id: <200905110230.n4B2UUXk082125@www262.sakura.ne.jp>
Subject: Q: semaphore and kmalloc(GFP_KERNEL)?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 11 May 2009 11:30:30 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 11052009 #1952692, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I got a question.

When we use kmalloc(GFP_KERNEL), we cannot use spinlock.
We use semaphore instead.

What happens if a writer process got into sleep state at kmalloc()
without releasing a rw_semaphore for writing,

    down_write(&sem);
    list_for_each()
        ...;
    ptr = kmalloc(size, GFP_KERNEL);
    list_add();
    up_write(&sem);

and then reader processes tried to hold that rw_semaphore?

    down_read(&sem);
    list_for_each()
        ...;
    up_read(&sem);

Can the kernel detect that we need to let kmalloc() fail and
wake up the writer process so that the writer process releases
the rw_semaphore and reader processes can continue?

(If the kernel can't detect, I worry that we experience
all processes sleeping for undefined duration.)

Regards.
