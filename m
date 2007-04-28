Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbXD1KCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbXD1KCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbXD1KCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:02:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbXD1KCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:02:30 -0400
Date: Sat, 28 Apr 2007 03:02:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Jones <davej@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070428030213.4787031f.akpm@linux-foundation.org>
In-Reply-To: <p73tzv022qw.fsf@bingen.suse.de>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
	<20070427221803.2a117c23.akpm@linux-foundation.org>
	<p73tzv022qw.fsf@bingen.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 Apr 2007 12:48:55 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > box:/usr/src/25> ~/checkpatch.pl patches/slub-core.patch
> > Checking patches/slub-core.patch:  signoffs = 30        
> > Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
> 
> The warning is bogus imho. How do you write recovery code for internal
> broken code logic? 

Yes, it is marginal.  But people do very often reach for BUG_ON() where
they could have at least partly recovered in some fashion - enough for the
info to hit the logs so we have a better chance of fixing it.

BUG_ON() is of course sometimes the right thing to do, but the idea here is
to suggest to the developers that they put a bit of thought into whether it
was really justified.

This little checking tool should have both "error" and "warning" levels -
AKA "fix this" and "think about this" levels.  BUG_ON would be a warning
thing.

