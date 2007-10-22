Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbXJVK67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbXJVK67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbXJVK6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:58:52 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:21249 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbXJVK6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ErUeMCaWf29ifN+6cva91g5LP+VLhcaxOPjxo5DbdTjzPf6rl2G734olvYwo2GhmfPa/v42BtbO7mQZHafPWHTa76bc4G1Kwjb4yW29hs6sW84yl1FpIoXis8L8htgdQfMBLSmitGaUyfcp1AxN37P6venEBkB/xsG4jYF6hL5Q=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: 100% iowait on one of cpus in current -git
Date: Mon, 22 Oct 2007 12:58:11 +0200
User-Agent: KMail/1.9.6
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221240.24386.maximlevitsky@gmail.com> <393050530.03287@ustc.edu.cn>
In-Reply-To: <393050530.03287@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221258.11384.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007 12:55:25 Fengguang Wu wrote:
> On Mon, Oct 22, 2007 at 12:40:24PM +0200, Maxim Levitsky wrote:
> > On Monday 22 October 2007 12:22:10 Peter Zijlstra wrote:
> > > > [  673.365631] pdflush       D c21bdecc     0   221      2
> > > > [  673.365635]        c21bdee0 00000046 00000002 c21bdecc c21bdec4 00000000 c21b3000 00000002
> > > > [  673.365643]        c0134892 c21b3164 c1e00200 00000001 c7109280 c21bdec0 c03ff849 c21bdef0
> > > > [  673.365650]        00052974 00000000 000000ff 00000000 00000000 00000000 c21bdef0 000529dc
> > > > [  673.365657] Call Trace:
> > > > [  673.365659]  [<c03fd728>] schedule_timeout+0x48/0xc0
> > > > [  673.365663]  [<c03fd50e>] io_schedule_timeout+0x5e/0xb0
> > > > [  673.365667]  [<c0170d11>] congestion_wait+0x71/0x90
> > > > [  673.365671]  [<c016b92e>] wb_kupdate+0x9e/0xf0
> > > > [  673.365675]  [<c016beb2>] pdflush+0x102/0x1d0
> > > > [  673.365679]  [<c013fa82>] kthread+0x42/0x70
> > > > [  673.365683]  [<c01050df>] kernel_thread_helper+0x7/0x18
> > > > 
> > > 
> > > That looks more like the inode writeback patches from Wu than the per
> > > bdi dirty stuff. The later typically hangs in balance_dirty_pages().
> > > 
> > > 
> > > 
> > 
> > Yes, you are right,
> > 
> > both revisions 1f7d6668c29b1dfa307a44844f9bb38356fc989b and 3e26c149c358529b1605f8959341d34bc4b880a3 work fine
> > But I didn't pay attention that those are before f4a1c2bce002f683801bcdbbc9fd89804614fb6b.
> > So, back to the drawing board.... :-)
> > 
> > Will test revision 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b, just after writeback patches.
> 
> Thank you. I'll try if I can reproduce it locally...
> 
> Fengguang
> 
> 

Bingo,

Revision 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b shows this bug.

I will now bisect to find exact patch that caused this bug,
Thanks,
	Maxim Levitsky
