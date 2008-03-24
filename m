Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYCXUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYCXUid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYCXUiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:38:25 -0400
Received: from yergi.telenet-ops.be ([195.130.132.36]:53786 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYCXUiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:38:25 -0400
Date: Mon, 24 Mar 2008 21:37:45 +0100
From: Wouter Verhelst <w@uter.be>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paul Clements <paul.clements@steeleye.com>,
       nbd-general@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Nbd] [PATCH 1/1] NBD: allow nbd to be used locally
Message-ID: <20080324203744.GA13603@goa.grep.be>
References: <47D468F0.8000506@steeleye.com> <20080310102917.GA27751@elf.ucw.cz> <47D56F4A.5070208@steeleye.com> <20080311100904.GA807@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311100904.GA807@elf.ucw.cz>
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: none
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 11:09:04AM +0100, Pavel Machek wrote:
> On Mon 2008-03-10 13:26:34, Paul Clements wrote:
> > Pavel Machek wrote:
> >
> >>> This patch allows a Network Block Device to be mounted locally 
> >>> (nbd-client to nbd-server over 127.0.0.1).
> >>>
> >>> It creates a kthread to avoid the deadlock described in NBD tools 
> >>> documentation. So, if nbd-client hangs waiting for pages, the kblockd 
> >>> thread can continue its work and free pages.
> >>
> >> What happens if your new kthread blocks on memory allocation?
> >
> > Well, we expect that. The reason for the new thread is so that it hangs, 
> > rather than kblockd hanging (which on a UP system brings all I/O to a 
> > halt). As long as kblockd can continue making progress, we eventually free 
> > up memory and then NBD can finish its requests, too.
> 
> ....unless all the memory is in dirty buffers for nbd, and nbd server
> is swapped out or something?

Note that I'm not a kernel hacker, so might be terribly mistaken here...

but I feel I should point out that this patch solves the issue that no
two block devices can flush their dirty buffers at the same time.
Without this patch, you can't write to a _filesystem_ on an NBD device
if that's connected to a server on the localhost. You are correct that
this does not solve the deadlock in swapping to NBD devices, but that's
not the only existing deadlock issue in NBD to localhost...

-- 
<Lo-lan-do> Home is where you have to wash the dishes.
  -- #debian-devel, Freenode, 2004-09-22
