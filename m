Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbYL3NAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbYL3NAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYL3NAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:00:10 -0500
Received: from vena.lwn.net ([206.168.112.25]:39855 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYL3NAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:00:08 -0500
Date: Tue, 30 Dec 2008 05:59:56 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@ZenIV.linux.org.uk>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20081230055956.1747bd86@tpl>
In-Reply-To: <20081229152732.GH496@one.firstfloor.org>
References: <20081229041352.6bbdf57c@tpl>
	<20081229124151.GA29634@redhat.com>
	<20081229152732.GH496@one.firstfloor.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008 16:27:32 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> I would prefer O_LOCK_FLAGS bit too. The global lock is not very nice
> and I don't doubt someone will come up with a workload which
> pounds on it.

Seems hard to imagine that it would be worse than the longstanding BKL
situation.  That said, the global lock is clearly an unsubtle approach,
and people don't like it.  I'd hoped to slip something quick through
the merge window, but that seems unlikely, especially, since I'm
allegedly on vacation.  I'll forget this patch for now and revisit it
next week.

(Unless, of course, somebody wants to just send in the O_LOCK_FLAGS
patch and be done with it.  I hate to invent a new and different
locking scheme for such a trivial purpose, but it's not *that* bad...)

Otherwise, maybe it's worth thinking for a bit on whether it might be
possible to do away with >fasync() altogether; that would make most of
the problem go away.  Will ponder later.

jon
