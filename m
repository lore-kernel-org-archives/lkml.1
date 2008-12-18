Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753037AbYLRNSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYLRNSp (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYLRNSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:18:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33498 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbYLRNSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:18:35 -0500
Date: Thu, 18 Dec 2008 14:18:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, viro@ftp.linux.org.uk,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        alex.zeffertt@eu.citrix.com, Ian.Campbell@citrix.com
Subject: Re: [PATCH UPDATED] xen: add xenfs to allow usermode <-> Xen
	interaction
Message-ID: <20081218131812.GD32135@elte.hu>
References: <49480F39.2010102@goop.org> <20081216125425.30524946.akpm@linux-foundation.org> <49496E17.2010703@goop.org> <20081217133429.b64e6421.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217133429.b64e6421.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 17 Dec 2008 13:24:39 -0800
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > The xenfs filesystem exports various interfaces to usermode.  Initially
> > this exports a file to allow usermode to interact with xenbus/xenstore.
> > 
> > Traditionally this appeared in /proc/xen.  Rather than extending procfs,
> > this patch adds a backward-compat mountpoint on /proc/xen, and provides
> > a xenfs filesystem which can be mounted there.
> > 
> > [ 
> >   I did quite a lot of work to this code as a result of review, which is
> >   why this is a repost rather than a delta.  The changes are:
> > 
> >    - Moved the XENFS_SUPER_MAGIC to linux/magic.h
> >    - Added comments to answer the "what's this for?" questions (I hope)
> >    - Split things out into smaller functions
> >    - Cleaned up type of queue_reply(), removed casts
> >    - Added a mutex to protect struct xenbus_file_priv.  This protects
> >       the list heads, and the partial message buffer.  There were
> >       several ways in which usermode could overwrite the kernel's
> >       memory via races without this locking.
> >    - Fixed a bug in which usermode could start sending a message
> >       which can never be sent, leaving the file descriptor in a
> >       useless state.
> 
> I'm bored of your filesystem, so I think I'll just merge it, unless
> someone else wants to ;)

please do - there should be no big overlap with existing other Xen bits in 
tip/*.

	Ingo
