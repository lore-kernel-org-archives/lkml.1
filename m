Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZEKC4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZEKC4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 22:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZEKC4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 22:56:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38433 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZEKC4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 22:56:05 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: Q: semaphore and kmalloc(GFP_KERNEL)?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <200905110230.n4B2UUXk082125@www262.sakura.ne.jp>
References: <200905110230.n4B2UUXk082125@www262.sakura.ne.jp>
Message-Id: <20090511115410.B0EA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 11 May 2009 11:56:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello.
> I got a question.
> 
> When we use kmalloc(GFP_KERNEL), we cannot use spinlock.
> We use semaphore instead.
> 
> What happens if a writer process got into sleep state at kmalloc()
> without releasing a rw_semaphore for writing,
> 
>     down_write(&sem);
>     list_for_each()
>         ...;
>     ptr = kmalloc(size, GFP_KERNEL);
>     list_add();
>     up_write(&sem);
> 
> and then reader processes tried to hold that rw_semaphore?
> 
>     down_read(&sem);
>     list_for_each()
>         ...;
>     up_read(&sem);
> 
> Can the kernel detect that we need to let kmalloc() fail and
> wake up the writer process so that the writer process releases
> the rw_semaphore and reader processes can continue?

it can't. Plus it shouldn't.
some caller don't want kmalloc() failure.


> (If the kernel can't detect, I worry that we experience
> all processes sleeping for undefined duration.)




