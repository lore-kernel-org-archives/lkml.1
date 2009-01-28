Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZA1EOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZA1EOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZA1EOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:14:38 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:54897 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZA1EOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:14:38 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 20:14:36 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ray Lee <ray-lk@madrabbit.org>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
In-Reply-To: <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901272010470.20262@alien.or.mcafeemobile.com>
References: <20090128033824.GA1662@brong.net>  <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>  <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com> <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, Ray Lee wrote:

> On Tue, Jan 27, 2009 at 8:00 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > On Wed, 28 Jan 2009, Bron Gondwana wrote:
> >
> >> Both Postfix and Apache use an epoll instance per child, which
> >> leads to significant scalability issues with max_user_instances
> >> set so low.  Bump the default to 1024 so medium sized sites are
> >> not impacted.
> >
> > NACK. Epoll allocates globally about 100 to 160 bytes (32/64 bit) for each
> > file added to the interface:
> >
> >        for i 1..1024
> >                for j 1..1024
> >                        if i!=j
> >                                add j -> i
> >
> > That's (N^2 * {100, 160}) = 100MB to 160MB of pinned kernel memory,
> > explotable by simple users with untouched NFILES.
> > This is the reason such limit was introduced in the first place. Again,
> > for the 10th time, if you have a loaded server with multiple processes
> > using epoll:
> >
> > $ echo NN > /proc/sys/fs/epoll/max_user_instances
> >
> > Note that NN does not consume any resource "per se", so if you feel
> > threatened by such limit, you can go wild with it.
> 
> It's really simple. A kernel upgrade in a -stable series point release
> broke a rational user-space setup. If you don't want to adjust the
> defaults, then the sane thing to do is to revert the commit that
> caused the grief. Postfix is everywhere. Apache is everywhere.
> 
> Userspace is not broken here, and the whole idea of a -stable series
> is that administrators can upgrade to them without having to worry
> about things getting broken or making specific configuration changes
> by point release.

The reason Greg took it, was that in a multiuser systems, that's a DoS 
EZ-PZ Lemon Squeezie.



- Davide


