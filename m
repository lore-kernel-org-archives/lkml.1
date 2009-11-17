Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZKQJdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZKQJdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZKQJdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:33:31 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:58310 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZKQJda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:33:30 -0500
Date: Tue, 17 Nov 2009 10:33:30 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: myuboot@fastmail.fm
Cc: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>
Subject: Re: problem bring up initramfs and busybox
Message-ID: <20091117093330.GA24000@linux-mips.org>
References: <1255735395.30097.1340523469@webmail.messagingengine.com> <4AD906D8.3020404@caviumnetworks.com> <1257898975.30125.1344591929@webmail.messagingengine.com> <4AFA6B7F.10404@walsimou.com> <1258417281.1921.1345554581@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258417281.1921.1345554581@webmail.messagingengine.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 06:21:21PM -0600, myuboot@fastmail.fm wrote:

> I have been struggling to bring up a MIPS 32 board with busybox with or
> without initramfs.
> The kernel stucks there without the shell coming up.
> 
> [    1.153000] nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
> [    1.161000] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    1.167000] TCP cubic registered
> [    1.170000] NET: Registered protocol family 17
> [   25.971000] Freeing unused kernel memory: 1032k freed
> [   39.969000] Algorithmics/MIPS FPU Emulator v1.5
> 
> 
> What I tried here is to use initramfs with statically linked busybox.
> The initramfs seems to be up, and runs the commands in the /init one by
> one, and then it goes to a inifite loop in r4k_wait at
> arch/mips/kernel/genex.S.

r4k_wait is called by the idle loop.  Which means the kernel has no process
to run so runs the idle loop.  This might be because there is no other
process left running or because all processes are waiting for I/O for
example.  So it's not uncommon that even busy systems ocasionally briefly
run the idle loop.  In other words, seeing the processor executing
r4k_wait does not necessarily mean something went wrong.  In this case -
also along with the other information you've provieded it's not obvious
what has gone wrong.

  Ralf
