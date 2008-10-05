Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYJEXHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYJEXHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 19:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYJEXHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 19:07:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:34632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbYJEXHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 19:07:38 -0400
Date: Sun, 5 Oct 2008 16:07:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
Message-ID: <20081005160724.54dd1a27@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0810051901190.31780@hs20-bc2-1.build.redhat.com>
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

On Sun, 5 Oct 2008 19:02:57 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > are you sure?
> > isn't the right fix to just walk the file pages only once?
> 
> It walks the pages only once --- and waits on each on them. But
> because new pages are contantly appearing under it, that "walk only
> once" becomes infinite loop (well, finite, until the whole disk is
> written).

well. fsync() promises that everything that's dirty at the time of the
call will hit the disk. That is not something you can compromise.
The only way out would be is to not allow new dirty during an fsync()...
which is imo even worse.

Submit them all in one go, then wait, should not be TOO bad. Unless a
lot was dirty already, but then you go back to "but it has to go to
disk".


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
