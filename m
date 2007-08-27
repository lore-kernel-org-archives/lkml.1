Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXH0M1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXH0M1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbXH0M1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:27:43 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41716 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751634AbXH0M1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:27:42 -0400
Message-ID: <388217659.90061@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 27 Aug 2007 20:27:38 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>,
       David Chinner <dgc@sgi.com>, Michael Rubin <mrubin@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] [RFC][PATCH] clustered writeback
Message-ID: <20070827122738.GA6999@mail.ustc.edu.cn>
References: <388214369.05937@ustc.edu.cn> <20070827050336.6a7e8e16@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827050336.6a7e8e16@laptopd505.fenrus.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 05:03:36AM -0700, Arjan van de Ven wrote:
> On Mon, 27 Aug 2007 19:21:52 +0800
> > 
> > Because it does the work in small batches of 10 inodes, when the
> > system has <=10 dirty inodes, its behavior will reduce to:
> > - do a full sweep *at once* on every 25s
> > Which means the disk will flicker once every 25s, not bad :)
> 
> 25 seconds is quite not good already though.... it takes a disk a
> second or two of no activity to go into low power mode, every 25
> seconds means you now have at least a 10% constant power cost....
> 
> I don't know the right answer (well other than "make sure inodes aren't
> dirty", which involves fixing apps to not do as much file operations,
> as well as relatime) but just "every 25s is no big deal" isn't really
> the case ;-(

Yeah, 25s may be too frequent... What I meant is that the old behavior
could be "write 1-3 inodes on every 5s" if the inodes are dirtied at
random times. Now it becomes "write 10 inodes on every 25s". So it is
actually better ;-)

It's interesting that we want writeback to be smooth on heavy loads
and to be 'bursty' on light loads. Increasing dirty_expire_centisecs
and decreasing dirty_writeback_centisecs could help it somehow.

