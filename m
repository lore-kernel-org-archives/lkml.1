Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbZFBDm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbZFBDm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbZFBDmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:42:52 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57876 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbZFBDmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:42:51 -0400
Message-Id: <200906020342.n523gjWf029800@www262.sakura.ne.jp>
Subject: Re: [PATCH 2/5] TOMOYO: Clarify lock protected section.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serge@hallyn.com
Cc: lizf@cn.fujitsu.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 12:42:45 +0900
References: <200906020143.n521hGGP003698@www262.sakura.ne.jp> <4A248C90.9010904@cn.fujitsu.com> <200906020230.n522UjfJ013581@www262.sakura.ne.jp> <20090602024306.GB21564@hallyn.com>
In-Reply-To: <20090602024306.GB21564@hallyn.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 01062009 #2072025, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Again I feel (no offense) like I'm reading Ada code here...
I don't know much about the Linux kernel's way of coding.
I'm making a lot of out-of-conventional coding.
Please mention without hesitating.

> 1. the mutex lock belonging to this function really is just protecting
> writes to elements of tomoyo_profile_ptr.  It should be defined,
> with a descriptive name and comment, next to tomoyo_profile_ptr
> at common.c:46.

(1) Declare a variable and a lock for that variable together.

I've heard (1) in the past.

On the other hand, I think there is another rule

(2) Declare variables inside a function if they are used only within
    that function.

If I bring the declaration of the lock to outside the function, it widens
the scope of the lock.

But Linux kernel's way is to follow (1), isn't it?

> 2. I see no reason for this not to be a fast spinlock at this
> point.

I'm thinking that
(1) If I use mutex and rw_semaphore, the CPU which is waiting for the lock
    can spend it's power for doing other process's jobs.
(2) If I use spinlock, the CPU's power is merely wasted, even though
    the CPU can spend it's power for doing other process's jobs.
and therefore I'm using mutex and rw_semaphore if sleeping is permitted.

Should I use spinlock rather than mutex and rw_semaphore whenever possible?

> 3. Once it's a fast checkpoint, you can change the flow a bit
> (unless there is good reason not to) to do:
Indeed.

Thanks.
