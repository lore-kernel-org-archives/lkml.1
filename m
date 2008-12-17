Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752939AbYLQXcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYLQXcT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYLQXcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:32:07 -0500
Received: from genesysrack.ru ([195.178.208.66]:60755 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbYLQXcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:32:05 -0500
Date: Thu, 18 Dec 2008 02:32:03 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [4/7] dst: thread pool.
Message-ID: <20081217233203.GA30039@ioremap.net>
References: <1229521998-7870-1-git-send-email-zbr@ioremap.net> <1229521998-7870-4-git-send-email-zbr@ioremap.net> <1229521998-7870-5-git-send-email-zbr@ioremap.net> <200812171655.05020.arnd@arndb.de> <1229544192.16253.37.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229544192.16253.37.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 07:03:12AM +1100, Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> > Have you looked at the last discussion involving thread pools in Linux?
> > BenH brought up the topic earlier this year, it is archived on
> > https://lists.linux-foundation.org/pipermail/ksummit-2008-discuss/2008-July/000213.html
> > 
> > So while it seems that there is clearly a use for such infrastructure,
> > my feeling is that it should not be part of dst, but rather live
> > in a location where it can be used by every subsystem.
> > 
> > Of course getting it there means another flame war^W^W discussion about what
> > the right interface should look like.
> > 
> > My personal feeling is that the interface should look a lot like
> > the existing work queues, to the point where you can easily convert
> > drivers between them, or even move all work queues over to thread pools.
> 
> The idea after KS was to use David Howells slow_work, maybe massaging
> the interfaces a bit.
> 
> I haven't had time to dedicate to that yet myself. David, what are you
> up to with your initial implementation ?

I have no objections against any implementation which will be imported
into the tree and can change the code to use new API quickly, but since
there is no code right now, I created my own thread pool.

Particulary DST needs ability to sleep or queue the work to be processed
by the pool and API to flush/destroy the pool.

-- 
	Evgeniy Polyakov
