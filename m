Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYLPCB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYLPCB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYLPCBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:01:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42922 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbYLPCBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:01:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 3/3] fsnotify: use the new open-exec hook for inotify and dnotify
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
In-Reply-To: <1229392365.23523.19.camel@localhost.localdomain>
References: <20081216100418.06CD.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1229392365.23523.19.camel@localhost.localdomain>
Message-Id: <20081216105624.06D3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 11:01:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > they are two different.
> > 
> > 1) Call dnotify_parent() or not
> > 2) Use IN_OPEN or IN_ACCESS
> > 
> > The patch description doesn't explain any reason.
> > 
> > 
> > IOW, IN_ACCESS is usually used by read(). but linux has demand paging
> > mechanism. then exec() only do open and mmap.
> > actual reading is processed by page fault.
> > 
> > I guess you have the reason of this design choice.
> > but it isn't described.
> 
> The original logic was all predicated on my thoughts on how my new
> fanotify would want these events and how I felt that open for exec was
> worth the separate hook.  None of that is useful at this time and in any
> case IN_OPEN makes a lot more sense than IN_ACCESS.  Since you've got me
> looking at these as freestanding patchs I do tend to think that the
> easiest thing for now would be to just drop patch 2 and make the call
> sites from patch 2 call fsnotify_open directly.

it seems make sense. thanks.


> I'll resend in the morning a single patch to call directly to
> fsnotify_open.  (and another single patch to immediately do the rename
> that I want done which I'll send as the full normal diff since it'll be
> freestanding)

you don't need full normal diff. last comment was my mistake. sorry.
I only hope patch separation.




