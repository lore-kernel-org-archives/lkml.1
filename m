Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbXIXJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbXIXJwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 05:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXIXJwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 05:52:03 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:32566 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbXIXJwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 05:52:01 -0400
Date: Mon, 24 Sep 2007 13:51:05 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, haveblue@us.ibm.com
Subject: 2.6.23-rc7-mm1: r/o mounts joke with lockdep
Message-ID: <20070924095105.GD6757@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

static void lock_and_coalesce_cpu_mnt_writer_counts(void)
{
	int cpu;
	struct mnt_writer *cpu_writer;

	for_each_possible_cpu(cpu) {
		cpu_writer = &per_cpu(mnt_writers, cpu);
		spin_lock_nested(&cpu_writer->lock, 42);
		                                   ^^^^

What the heck is going on? Given that MAX_LOCKDEP_SUBCLASSES is only 8,
this reliably turns off lockdep at boot.

