Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYLZHBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYLZHBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYLZHBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:01:08 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51864 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYLZHBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:01:07 -0500
Message-Id: <200812260700.mBQ70uH3009595@www262.sakura.ne.jp>
Subject: Re: [PATCH] Check return from argv_split() in do_coredump().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: xiyou.wangcong@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Dec 2008 16:00:56 +0900
References: <200812240616.mBO6GGEe078727@www262.sakura.ne.jp> <20081226144548.GB3156@hack.private>
In-Reply-To: <20081226144548.GB3156@hack.private>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 26122008 #1356437, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Américo Wang wrote:
> How about going to the line:
> 
>         current->fsuid = fsuid;
> 
> ? Because when argv_split() fails, helper_argv is NULL and doesn't need
> to be checked again.

I didn't understand what you say. I'm saying that
"do_coredump() may accesss helper_argv[0] when helper_argv == NULL",
which will result in "NULL pointer dereference" problem.
Yes, this problem unlikely happens. Thus,

if (!helper_argv)
	goto fail_unlock;

may be enough.

Regards.
