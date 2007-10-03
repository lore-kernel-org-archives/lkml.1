Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbXJCLMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbXJCLMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbXJCLMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:12:16 -0400
Received: from [122.1.235.145] ([122.1.235.145]:64096 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbXJCLMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:12:15 -0400
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 03/15](repost) Memory and pathname management functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4701F285.5000206@nttdata.co.jp>
	<4701F3AB.5000807@nttdata.co.jp>
	<Xine.LNX.4.64.0710030033350.1422@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0710030033350.1422@us.intercode.com.au>
Message-Id: <200710032012.IAG12950.LOSHJtVFOFFMOQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 3 Oct 2007 20:12:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

James Morris wrote:
> Would you please explain why you need another level of memory allocation?
> 
> What does it do apart from let you check for memory leaks?

Difference between tmy_alloc() and kmalloc() are

  tmy_alloc() allows administrator know "how much memory is used by TOMOYO Linux modules"
  via /sys/kernel/security/tomoyo/meminfo interface.
  This feature was requested by TOMOYO Linux users.
  /proc/slabinfo can show how much memory is used by all modules,
  but it cannot show how much memory is used by TOMOYO Linux modules.

  tmy_alloc() can indicate memory-leaking bug and can avoid double-kfree() bug
  by keeping the pointer returned by kmalloc() in a local "cache_list" list.

  tmy_alloc() also keeps the size of memory allocated by kmalloc() in "cache_list" list
  so that administrator can know "how much memory is used by TOMOYO Linux modules".
  Calling ksize() after kmalloc() in tmy_alloc() and
  calling ksize() before kfree() in tmy_free() might be better
  if double-kfree-checks and memory-leaking-checks (i.e. "tmy_cachep") are unneeded.

Regards.

