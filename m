Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbXJVK4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbXJVK4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbXJVKz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:55:58 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52656 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751625AbXJVKz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:55:57 -0400
Message-ID: <393050530.03287@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 22 Oct 2007 18:55:25 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 100% iowait on one of cpus in current -git
Message-ID: <20071022105525.GA6732@mail.ustc.edu.cn>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221159.19364.maximlevitsky@gmail.com> <1193048530.27435.169.camel@twins> <200710221240.24386.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710221240.24386.maximlevitsky@gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 12:40:24PM +0200, Maxim Levitsky wrote:
> On Monday 22 October 2007 12:22:10 Peter Zijlstra wrote:
> > > [  673.365631] pdflush       D c21bdecc     0   221      2
> > > [  673.365635]        c21bdee0 00000046 00000002 c21bdecc c21bdec4 00000000 c21b3000 00000002
> > > [  673.365643]        c0134892 c21b3164 c1e00200 00000001 c7109280 c21bdec0 c03ff849 c21bdef0
> > > [  673.365650]        00052974 00000000 000000ff 00000000 00000000 00000000 c21bdef0 000529dc
> > > [  673.365657] Call Trace:
> > > [  673.365659]  [<c03fd728>] schedule_timeout+0x48/0xc0
> > > [  673.365663]  [<c03fd50e>] io_schedule_timeout+0x5e/0xb0
> > > [  673.365667]  [<c0170d11>] congestion_wait+0x71/0x90
> > > [  673.365671]  [<c016b92e>] wb_kupdate+0x9e/0xf0
> > > [  673.365675]  [<c016beb2>] pdflush+0x102/0x1d0
> > > [  673.365679]  [<c013fa82>] kthread+0x42/0x70
> > > [  673.365683]  [<c01050df>] kernel_thread_helper+0x7/0x18
> > > 
> > 
> > That looks more like the inode writeback patches from Wu than the per
> > bdi dirty stuff. The later typically hangs in balance_dirty_pages().
> > 
> > 
> > 
> 
> Yes, you are right,
> 
> both revisions 1f7d6668c29b1dfa307a44844f9bb38356fc989b and 3e26c149c358529b1605f8959341d34bc4b880a3 work fine
> But I didn't pay attention that those are before f4a1c2bce002f683801bcdbbc9fd89804614fb6b.
> So, back to the drawing board.... :-)
> 
> Will test revision 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b, just after writeback patches.

Thank you. I'll try if I can reproduce it locally...

Fengguang

