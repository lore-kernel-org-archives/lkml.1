Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab0BGH0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 02:26:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0BGH0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 02:26:50 -0500
Date: Sat, 6 Feb 2010 23:27:02 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, taviso@google.com,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, alan@lxorguk.ukuu.org.uk, jdike@addtoit.com,
       jln@google.com, mpm@selenic.com
Subject: Re: [2.6.33-rc5] tty: possible irq lock inversion dependency in
	tty_fasync
Message-ID: <20100207072702.GA9768@suse.de>
References: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp> <alpine.LFD.2.00.1002062226000.3829@localhost.localdomain> <alpine.LFD.2.00.1002062244310.3829@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002062244310.3829@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 10:46:01PM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 6 Feb 2010, Linus Torvalds wrote:
> > 
> > Yeah. I think we need to just revert that commit.
> > 
> > Or maybe we could just do the following, rather than revert it outright: 
> > just get a ref to the 'struct pid' while holding the spinlock, and then 
> > releasing it after doing the __f_setown() call.
> 
> Btw, if we do this, then we should probably revert commit 
> b04da8bfdfbbd79544cab2fadfdc12e87eb01600 at the same time.
> 
> Resulting patch would then look like the appended.

The patch looks correct to me, thanks for fixing this.

  Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Can you commit it to your tree, or do you need/want me to submit it?

thanks,

greg k-h
