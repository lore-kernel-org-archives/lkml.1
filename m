Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZA1QxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZA1QxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZA1QxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:53:00 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46031 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZA1Qw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:52:59 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 28 Jan 2009 08:52:51 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
In-Reply-To: <19f34abd0901280308w18407fd5rd4d7d95e3799cf60@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901280849340.20724@alien.or.mcafeemobile.com>
References: <20090128033824.GA1662@brong.net>  <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>  <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>  <20090128053204.GB8720@brong.net>
 <19f34abd0901280308w18407fd5rd4d7d95e3799cf60@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Vegard Nossum wrote:

> On Wed, Jan 28, 2009 at 6:32 AM, Bron Gondwana <brong@fastmail.fm> wrote:
> > That's clearly not happening here - so it seems that maybe our "happy
> > medium" is actually in closer inspection of what's going on rather than
> > a blanket low N to keep N^2 down.
> 
> Mh, could another solution to this all be to limit the number times
> you can add a single epoll descriptor to another descriptor's set?

In the example that was posted, a single fd was added a single time inside 
the other 1000+ fds. Epoll already has detection for too long chains and 
closed loops, but you can't put those in the fast path. And epoll_ctl() is 
one of those.


- Davide


