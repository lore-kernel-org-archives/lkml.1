Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbXIAKP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbXIAKP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 06:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXIAKOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 06:14:14 -0400
Received: from mail.suse.de ([195.135.220.2]:55553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbXIAKOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 06:14:10 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
Date: Sat, 1 Sep 2007 12:07:57 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       jakub@redhat.com, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <20070829161545.9fde1a5c.akpm@linux-foundation.org> <46D6F0C1.9080404@redhat.com>
In-Reply-To: <46D6F0C1.9080404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011207.58201.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>         write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
>         /* copy vsyscall data */
>         vsyscall_gtod_data.clock.vread = clock->vread;
>         vsyscall_gtod_data.clock.cycle_last = clock->cycle_last;
>         vsyscall_gtod_data.clock.mask = clock->mask;
>         vsyscall_gtod_data.clock.mult = clock->mult;
>         vsyscall_gtod_data.clock.shift = clock->shift;
>         vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
>         vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;  <===
>         vsyscall_gtod_data.sys_tz = sys_tz;
>         vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;  <===

Must have been a (harmless) merging mistake, but I bet gcc optimizes it out
anyways.

-Andi
