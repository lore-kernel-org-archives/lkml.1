Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbZBJIcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbZBJIcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 03:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbZBJIcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 03:32:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:58997 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZBJIco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 03:32:44 -0500
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <4990EF3F.3010501@cn.fujitsu.com>
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com>
	 <20090209112321.GW28946@ZenIV.linux.org.uk>
	 <1234180131.5951.85.camel@laptop>  <4990EF3F.3010501@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 09:32:35 +0100
Message-Id: <1234254755.4893.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 11:06 +0800, Li Zefan wrote:
> > It seems to me we can simply put the new s_umount instance in a
> > different subclass. Its a bit unusual to use _nested for the outer lock,
> > but lockdep doesn't particularly cares about subclass order.
> > 
> > If there's any issue with the callers of sget() assuming the s_umount
> > lock being of sublcass 0, then there is another annotation we can use to
> > fix that, but lets not bother with that if this is sufficient.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Tested-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks!
> 
> a minor comment
> 
> > +		 * lock of the old one. Since these are clearly distrinct
> 
> s/distrinct/distinct

Yes, someone else was kind enough to point that out as well :-)

Al, do you want a resend or will you fix that up when you add the patch
to your queue?

> BTW, I found another bug in current code:

Yep, looks good, freeing held locks makes lockdep unhappy.

> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Tue, 10 Feb 2009 10:55:53 +0800
> Subject: [PATCH] vfs: add missing unlock in sget()
> 
> We should release s->s_umount before calling destroy_super(s).
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---

