Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbYJFEU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbYJFEU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 00:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYJFEUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 00:20:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:39591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYJFEUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 00:20:48 -0400
Date: Sun, 5 Oct 2008 21:20:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
Message-ID: <20081005212031.63ad246a@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0810052320480.3074@hs20-bc2-1.build.redhat.com>
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
	<20081005173019.0a358b09@infradead.org>
	<Pine.LNX.4.64.0810052320480.3074@hs20-bc2-1.build.redhat.com>
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

On Sun, 5 Oct 2008 23:30:51 -0400 (EDT
> The point is that many fsync()s may run in parallel and you have just
> one inode and just one chain. And if you add two-word list_head to a
> page, to link it on this list, many developers will hate it for
> increasing its size.

why to a page?
a list head in the inode and chain up the bios....
or not make an actual list but just a "is the previous one done" thing
it's not all that hard to get something that works on a per inode basis,
that gives "wait for all io upto this one".



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
