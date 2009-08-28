Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbZH1WkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbZH1WkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZH1WkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:40:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZH1WkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:40:02 -0400
Date: Fri, 28 Aug 2009 18:39:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>, Ulrich Drepper <drepper@redhat.com>,
       Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828223953.GA11591@infradead.org>
References: <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com> <20090828164106.GA9951@infradead.org> <4A984337.7080009@redhat.com> <20090828210838.GA26799@infradead.org> <1251494174.5984.2.camel@heimdal.trondhjem.org> <20090828212921.GA13662@infradead.org> <1251495785.5984.13.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251495785.5984.13.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 05:43:05PM -0400, Trond Myklebust wrote:
> If you are going to automatically set O_DSYNC in open(), then
> fcntl(F_SETFL) might get a bit nasty.
> 
> Imagine using it after the open in order to clear the O_ISYNC flag;
> you'll still be left with the O_DSYNC (which you never set in the first
> place). That would be confusing...

Indeed, that's a killer argument for the first variant.  We just need
to make it extremly clear (manpage _and_ comments) that only O_SYNC is
an exposed user interface and that O_WHATEVER_SYNC is an implementation
detail.
