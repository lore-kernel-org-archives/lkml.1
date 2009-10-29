Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZJ2GXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZJ2GXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 02:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZJ2GXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 02:23:50 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:53940
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbZJ2GXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 02:23:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuAAAOrR6Ep8qNN0/2dsb2JhbAAI22KCNIILBA
X-IronPort-AV: E=Sophos;i="4.44,644,1249228800"; 
   d="scan'208";a="575195260"
Subject: Re: kernel panic about kernel unaligned access
From: Ben Nizette <bn@niasdigital.com>
To: loody <miloody@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3a665c760910270723l6989539er7e820d630cce51ac@mail.gmail.com>
References: <3a665c760910270627u784d43b8t2978731110c920a4@mail.gmail.com>
	 <3a665c760910270723l6989539er7e820d630cce51ac@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 29 Oct 2009 17:24:13 +1100
Message-Id: <1256797453.4362.61.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 22:23 +0800, loody wrote:
> Dear all:
> I use kernel 2.6.18 and I get the kernel panic as below:

Very old kernel, you're unlikely to get good responses.

> 1. what does "Not tainted" mean?

You haven't loaded a closed-source module, the system hasn't crashed
before and a few other things.  Pretty much that your system was in good
shape before the bug

> 2. I grep the kernel and I find the above message comes from do_ade in
> unaligned.c, If I guess correctly.
>    but from the call trace I cannot find out who call it.
>    who and how kernel pass the information to do_ade?

No-one calls it, it's an exception handler invoked when an unaligned
access is attempted.  Your question should be "on which assembler
instruction is the unaligned access attempted" and you can find that out
as below

> 3. as far as i know, inode is the data structure we used to record file.

Well, its a structure which holds metadata about files, yes

> From what information in the inode I can find out the file name the
> writeback_inodes try to write?

Not with just this information; you'd need additional debug output, but
even then I very much doubt that information would help you

> 4. take  [<87189564>] preempt_schedule+0x68/0xac for example, what
> does "0xac" mean?

That's the symbol size. 0x68 is the offset in to preempt_schedule and
probably more useful for you.  With that info, your vmlinux and gdb you
can get the offending asm instruction.

All that said, it's such an old kernel you're unlikely to get much help
actually fixing the bug, you're much better off to upgrade if there's
any chance of it.

	--Ben.

