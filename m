Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0BGIMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 03:12:19 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:56578 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab0BGIMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 03:12:18 -0500
To: gregkh@suse.de, torvalds@linux-foundation.org
Cc: taviso@google.com, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, jdike@addtoit.com,
       jln@google.com, mpm@selenic.com
Subject: Re: [2.6.33-rc5] tty: possible irq lock inversion dependency intty_fasync
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp>
	<alpine.LFD.2.00.1002062226000.3829@localhost.localdomain>
	<alpine.LFD.2.00.1002062244310.3829@localhost.localdomain>
	<20100207072702.GA9768@suse.de>
In-Reply-To: <20100207072702.GA9768@suse.de>
Message-Id: <201002071712.CBC51501.SFFtLOMOQVJHFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 7 Feb 2010 17:12:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Feb 06, 2010 at 10:46:01PM -0800, Linus Torvalds wrote:
> > 
> > 
> > On Sat, 6 Feb 2010, Linus Torvalds wrote:
> > > 
> > > Yeah. I think we need to just revert that commit.
> > > 
> > > Or maybe we could just do the following, rather than revert it outright: 
> > > just get a ref to the 'struct pid' while holding the spinlock, and then 
> > > releasing it after doing the __f_setown() call.
> > 
> > Btw, if we do this, then we should probably revert commit 
> > b04da8bfdfbbd79544cab2fadfdc12e87eb01600 at the same time.
> > 
> > Resulting patch would then look like the appended.
> 
> The patch looks correct to me, thanks for fixing this.
> 
>   Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Can you commit it to your tree, or do you need/want me to submit it?
> 
> thanks,
> 
> greg k-h
> 
That patch solved the lockdep warning.

Thank you.
