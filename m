Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658Ab0AZGyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0AZGyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908Ab0AZGyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:54:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38837 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab0AZGyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:54:39 -0500
Date: Tue, 26 Jan 2010 06:54:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tavis Ormandy <taviso@google.com>, Jeff Dike <jdike@addtoit.com>,
       Julien Tinnes <jln@google.com>, Matt Mackall <mpm@selenic.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
Message-ID: <20100126065426.GG19799@ZenIV.linux.org.uk>
References: <2375c9f91001252125w6f5bd3d3he183c61e9dcedd3e@mail.gmail.com> <20100126142644.5AB0.A69D9226@jp.fujitsu.com> <20100126144641.5AB3.A69D9226@jp.fujitsu.com> <2375c9f91001252201t552022ebvcd44b225eb7f9a95@mail.gmail.com> <20100126060705.GF19799@ZenIV.linux.org.uk> <2375c9f91001252224g6712cbady339dbe486a5112ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2375c9f91001252224g6712cbady339dbe486a5112ac@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 02:24:30PM +0800, Am??rico Wang wrote:
> On Tue, Jan 26, 2010 at 2:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Jan 26, 2010 at 02:01:12PM +0800, Am??rico Wang wrote:
> >
> >> I agree, it seems that patch is useless, since we already
> >> do lock_kernel() before calling __f_setown()...
> >
> > What's to prevent pid from being freed under us? ??BKL won't...
> >
> 
> Hmm, I don't fully understand the race here. If it is used to protect
> 'pid' which we get from 'tty->pgrp' or 'current', in the former case,
> it is protected by 'tty->ctrl_lock', in the later case, it doesn't need
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Without that patch it isn't.

> the lock. So it's not necessary to protect 'pid' by 'tty->crtl_lock'.
