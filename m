Return-Path: <linux-kernel-owner+w=401wt.eu-S1161085AbXAZQ7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161085AbXAZQ7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161089AbXAZQ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:59:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59672 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161085AbXAZQ73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:59:29 -0500
Date: Fri, 26 Jan 2007 17:58:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Fwd: [PATCH 4/4] coredump: documentation for proc and sysctl]
Message-ID: <20070126165847.GB1269@elf.ucw.cz>
References: <45BA0E41.2080204@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA0E41.2080204@hitachi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> This patch adds the documentation for the following parameters:
>   /proc/<pid>/core_flags
>   /proc/sys/kernel/core_flags_enable

Sysctl seems really strange to me. Either the feature is safe to use,
or it is not. Users can already ulimit -c 0, and we do not have
"/proc/sys/kernel/allow_users_to_disable_their_core_dumps".

Plus, this is pretty analogical to ulimit -c, so I believe it should
be implemented like that one. You'll need less locking that way.

> +2.14 /proc/<pid>/core_flags - Core dump control flags
> +---------------------------------------------------------------------
> +When a process is dumped, all anonymous memory is written to a core file as
> +long as the size of the core file isn't limited. But sometimes we don't want
> +to dump some memory segments, for example, huge shared memory.
> +
> +The /proc/<pid>/core_flags file enables you to omit some anonymous memory from
> +a core file when it is generated. The content of the proc file is bitmask of
> +memory segment types you don't want to dump. When the <pid> process is dumped,
> +the core dump routine decides whether a given memory segment should be dumped
> +into a core file or not, based on the type of the memory segment and bitmask.
> +
> +Currently, only valid bit is bit 0. If bit 0 is set, anonymous `shared' memory
> +segments are not dumped. There are three types of anonymous shared memory:
> +
> +  - IPC shared memory
> +  - the memory segments created by mmap(2) with MAP_ANONYMOUS and MAP_SHARED
> +    flags
> +  - the memory segments created by mmap(2) with MAP_SHARED flag, and the
> +    mapped file has already been unlinked
> +
> +Because current core dump routine doesn't distinguish these segments, you can
> +only choose either dumping all anonymous shared memory segments or not.
> +
> +If you don't want to dump all shared memory segments attached to pid 1234, set
> +the bit 0 of the process's core_flags to 1:
> +
> +  $ echo 1 > /proc/1234/core_flags
> +
> +Additionally, you can check its hexadecimal value by reading the file:
> +
> +  $ cat /proc/1234/core_flags
> +  00000001
> +
> +When a new process is created, the process inherits the core_flags setting
> +from its parent. It is useful to set the core_flags before the program runs.
> +For example:
> +
> +  $ echo 1 > /proc/self/core_flags
> +  $ ./some_program
> +

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
