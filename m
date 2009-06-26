Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZFZIta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZFZIta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 04:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZFZItX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 04:49:23 -0400
Received: from mail.open.by ([193.232.92.17]:64656 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZFZItW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 04:49:22 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8838 [Jun 25 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Fri, 26 Jun 2009 11:50:56 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak suggestion (long message)
Message-ID: <20090626085056.GC3451@localdomain.by>
References: <20090625221816.GA3480@localdomain.by>
 <20090626065923.GA14078@elte.hu>
 <84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
 <20090626081452.GB3451@localdomain.by>
 <1246004270.27533.16.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246004270.27533.16.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/26/09 11:17), Pekka Enberg wrote:
> Well, the thing is, I am not sure it's needed if we implement Ingo's
> suggestion. After all, syslog is no longer spammed very hard and you can
> do all the filtering in userspace when you read /debug/mm/kmemleak file,
> no?
> 
> 			Pekka
> 

Well, we just move 'spam' out of syslog. Not dealing with 'spam' itself.
I'm not sure about 'filtering in userspace when you read'. Suppose I use
'tail -f /debug/mm/kmemleak'. How can I easy suppress printing of (for example):

[   64.494396] kmemleak: unreferenced object 0xf63fee18 (size 32):
[   64.494400] kmemleak:   comm "init", pid 1, jiffies 4294879195
[   64.494402] kmemleak:   backtrace:
[   64.494408] kmemleak:     [<c10e92fb>] kmemleak_alloc+0x11b/0x2b0
[   64.494412] kmemleak:     [<c10e4b91>] kmem_cache_alloc+0x111/0x1c0
[   64.494418] kmemleak:     [<c12cf49b>] tty_ldisc_try_get+0x2b/0x130
[   64.494422] kmemleak:     [<c12cf7d7>] tty_ldisc_get+0x37/0x70
[   64.494426] kmemleak:     [<c12cfa54>] tty_ldisc_reinit+0x34/0x70
[   64.494431] kmemleak:     [<c12cfac5>] tty_ldisc_release+0x35/0x60
[   64.494435] kmemleak:     [<c12ca1fe>] tty_release_dev+0x33e/0x500
[   64.494439] kmemleak:     [<c12ca3e0>] tty_release+0x20/0x40
[   64.494443] kmemleak:     [<c10ed5fd>] __fput+0xed/0x200
[   64.494446] kmemleak:     [<c10ed732>] fput+0x22/0x40
[   64.494450] kmemleak:     [<c10e96a9>] filp_close+0x49/0x90
[   64.494454] kmemleak:     [<c10e9758>] sys_close+0x68/0xc0
[   64.494459] kmemleak:     [<c100324b>] sysenter_do_call+0x12/0x22
[   64.494467] kmemleak:     [<ffffffff>] 0xffffffff

Or any report with tty_ldisc_try_get (ppp generates tons of them).
echo "block=c12cf49b" > /sys/.../kmemleak looks good to me.

	Sergey
