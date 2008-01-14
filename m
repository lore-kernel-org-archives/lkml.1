Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYANJYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYANJYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYANJYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:24:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55705 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbYANJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:24:08 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 10:24:04 +0100
Message-Id: <1200302644.7415.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 17:04 +0800, Dave Young wrote:
> Hi,
> 
> When I "halt -p", lockdep warnings triggered as following (hand copy):
> 
> WARNING : at kernel/lockdep.c: 700 lookup_lock_class()
> 
> <snip>
> lock_acquire
> cleanup_workqueue_thread
> workqueue_cpu_callback
> notifier_call_chain
> __raw_notifier_call_chain
> raw_notifier_call_chain
> __cpu_down
> disable_nonboot_cpus
> kernel_power_off
> sys_reboot
> <snip>

My first guess would be a __create_workqueue_key() where a key is
re-used with a different workqueue name.

