Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbZJNXDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbZJNXDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762019AbZJNXDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:03:07 -0400
Received: from ozlabs.org ([203.10.76.45]:46432 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761409AbZJNXDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:03:06 -0400
Date: Thu, 15 Oct 2009 09:57:26 +1100
From: Anton Blanchard <anton@samba.org>
To: fweisbec@gmail.com, mingo@elte.hu, paulus@samba.org,
       a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: perf report fractal output issue
Message-ID: <20091014225726.GF4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I noticed a problem where I wasn't always getting callchains:

# perf report
    98.47%  lock1_processes  [kernel]                [k] .lock_kernel

     0.91%  lock1_processes  [kernel]                [k] .fput


But a flat output confirmed the data is there:

# perf report -g flat
    98.47%  lock1_processes  [kernel]                             [k] .lock_kernel
            98.47%
                .lock_kernel
                .__posix_lock_file
                (nil)
                .fcntl_setlk
                .sys_fcntl
                syscall_exit
                0xfffb7d04844
                .testcase
                .testcase
                .affinitize
                .new_task
                .main
                0xfffb7c4933c
                0xfffb7c4955c
                (nil)

It looks like callchain__fprintf_graph() only prints the callchain if we
have at least one rb entry at the top. In my case all the associated
backtraces are identical so I assume we dont have to do any splitting.

Anton
