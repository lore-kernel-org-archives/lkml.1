Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZAETsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZAETsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZAETsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:48:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59737 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZAETsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:48:45 -0500
Date: Mon, 5 Jan 2009 19:48:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       "David S. Miller" <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>
Subject: Re: ftrace breaks sparc64 build
Message-ID: <20090105194844.GR28946@ZenIV.linux.org.uk>
References: <20090105181922.GA25622@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105181922.GA25622@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 07:19:22PM +0100, Sam Ravnborg wrote:
> With an allmodconfig build on sparc and sparc64 I started
> to see warnings that become propagated to errors by -Werror.

While we are at it, sparc32 allmodconfig is broken by
commit 9bb482476c6c9d1ae033306440c51ceac93ea80c
Author: Jan Beulich <jbeulich@novell.com>
Date:   Tue Dec 16 11:30:08 2008 +0000

    allow stripping of generated symbols under CONFIG_KALLSYMS_ALL

Results in
sparc-linux-objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation
sparc-linux-objcopy: not stripping symbol `__crc_per_cpu__softirq_work_list' because it is named in a relocation
sparc-linux-objcopy: not stripping symbol `__initcall_end' because it is named in a relocation
sparc-linux-objcopy: not stripping symbol `__setup_end' because it is named in a relocation
sparc-linux-objcopy: not stripping symbol `__setup_start' because it is named in a relocation
sparc-linux-objcopy: not stripping symbol `__initcall_start' because it is named in a relocation
make: *** [.tmp_vmlinux1.stripped] Error 1
