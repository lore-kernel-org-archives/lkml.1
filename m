Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZA2OVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZA2OVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZA2OVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:21:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:46886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZA2OVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:21:08 -0500
Subject: Re: PFs on pages pinned with get_user_pages()
From: Peter Zijlstra <peterz@infradead.org>
To: Frank Mehnert <Frank.Mehnert@Sun.COM>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200901291502.48312.frank.mehnert@sun.com>
References: <200901290905.10966.frank.mehnert@sun.com>
	 <200901291408.02454.frank.mehnert@sun.com>
	 <1233236630.4495.80.camel@laptop>
	 <200901291502.48312.frank.mehnert@sun.com>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 15:20:54 +0100
Message-Id: <1233238854.4495.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 15:02 +0100, Frank Mehnert wrote:

> I'm one of the VirtualBox developers. We are trying to fix the annoying
> kerneloops warning 'BUG: sleeping function called from invalid context'
> reported by the Fedora folks. This warning occurs when do_swap_page()
> calls lock_page() and in_atomic() returns true.
> 
> This warning appears when we touch into memory which is pinned with
> get_user_pages(). In VT-x/AMD-V mode we are executing some code in the
> context of the Linux kernel. To prevent scheduling of the current CPU
> core we disable the interripts. preempt_disable() would be probably the
> better choice but this would oops as well if CONFIG_PREEMPT is enabled.

but to get there, you'd have to have called handle_mm_fault() which
requires the mmap_sem, which should also give that might_sleep()
warning.

That aside, is there any reason you have to avoid scheduling? Otherwise
I would just allow so and be done with it.

