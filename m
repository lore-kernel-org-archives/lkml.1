Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbZAIOGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbZAIOGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 09:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZAIOGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 09:06:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZAIOGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 09:06:15 -0500
Date: Fri, 9 Jan 2009 15:03:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       bfields@fieldses.org
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20090109140354.GA6018@redhat.com>
References: <20081229041352.6bbdf57c@tpl> <20081229124151.GA29634@redhat.com> <20090108162806.48caaa29@bike.lwn.net> <20090109100821.GA27829@redhat.com> <20090109061846.5beee8df@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109061846.5beee8df@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Jonathan Corbet wrote:
>
> On Fri, 9 Jan 2009 11:08:21 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > and then we change f_flags again, including F_ASYNC bit.
> >
> > This is racy?
>
> No, I took FASYNC out of SETFL_MASK, so it isn't changed here.

Ah yes, I missed the change in SETFL_MASK. Thanks.

> > Now we have the global mutex for ->fasync... Well, not very
> > good but fasync_helper() takes fasync_lock anyway.
>
> Not very good, but does anybody know of a workload which would result in
> that mutex being contended ever?

I don't.

Actually, I personally dislike the global file_flags_lock more.
But don't get me wrong, I do not think O_LOCK_FLAGS is better
or cleaner.

Oleg.

