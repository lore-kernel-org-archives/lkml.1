Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbYJFAaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbYJFAaw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 20:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYJFAao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 20:30:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:49552 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYJFAan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 20:30:43 -0400
Date: Sun, 5 Oct 2008 17:30:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
Message-ID: <20081005173019.0a358b09@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0810051949290.5798@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0809231817390.11559@hs20-bc2-1.build.redhat.com>
	<20080923154905.50d4b0fa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809231902010.19496@hs20-bc2-1.build.redhat.com>
	<20080923164623.ce82c1c2.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com>
	<20081001225404.4e973465.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com>
	<20081005153306.7e644c9f@infradead.org>
	<Pine.LNX.4.64.0810051901190.31780@hs20-bc2-1.build.redhat.com>
	<20081005160724.54dd1a27@infradead.org>
	<Pine.LNX.4.64.0810051910580.663@hs20-bc2-1.build.redhat.com>
	<20081005162847.7bf0ead1@infradead.org>
	<Pine.LNX.4.64.0810051949290.5798@hs20-bc2-1.build.redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008 20:01:46 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> I assume that if very few people complained about the livelock till
> now, very few people will see degraded write performance. My patch
> blocks the writes only if the livelock happens, so if the livelock
> doesn't happen in unpatched kernel for most people, the patch won't
> make it worse.

I object to calling this a livelock. It's not. 
And yes, fsync is slow and lots of people are seeing that.
It's not helped by how ext3 is implemented (where fsync is effectively
equivalent of a sync for many cases).
But again, moving the latency to "innocent" parties is not acceptable.

> 
> > If the fsync() implementation isn't smart enough, sure, lets improve
> > it. But not by shifting latency around... lets make it more
> > efficient at submitting IO.
> > If we need to invent something like "chained IO" where if you wait
> > on the last of the chain, you wait on the entirely chain, so be it.
> 
> This looks madly complicated. And ineffective, because if some page
> was submitted before fsync() was invoked, and is under writeback
> while fsync() is called, fsync() still has to wait on it.

so?
just make a chain per inode always...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
