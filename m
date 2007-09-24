Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbXIXQkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbXIXQkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761016AbXIXQ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761010AbXIXQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:27:59 -0400
Date: Mon, 24 Sep 2007 09:26:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org, haveblue@us.ibm.com
Subject: Re: 2.6.23-rc7-mm1: r/o mounts joke with lockdep
Message-Id: <20070924092658.91c17511.akpm@linux-foundation.org>
In-Reply-To: <20070924095105.GD6757@localhost.sw.ru>
References: <20070924095105.GD6757@localhost.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 13:51:05 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:

> static void lock_and_coalesce_cpu_mnt_writer_counts(void)
> {
> 	int cpu;
> 	struct mnt_writer *cpu_writer;
> 
> 	for_each_possible_cpu(cpu) {
> 		cpu_writer = &per_cpu(mnt_writers, cpu);
> 		spin_lock_nested(&cpu_writer->lock, 42);
> 		                                   ^^^^
> 
> What the heck is going on?

that was some random 2:00AM hack by me to make the warnings go away.

> Given that MAX_LOCKDEP_SUBCLASSES is only 8,
> this reliably turns off lockdep at boot.

that explains why it worked so well.
