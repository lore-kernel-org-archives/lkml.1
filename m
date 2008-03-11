Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYCKNKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYCKNKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYCKNKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:10:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34181 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYCKNKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:10:38 -0400
Date: Tue, 11 Mar 2008 11:09:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Clements <paul.clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       nbd-general@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH 1/1] NBD: allow nbd to be used locally
Message-ID: <20080311100904.GA807@elf.ucw.cz>
References: <47D468F0.8000506@steeleye.com> <20080310102917.GA27751@elf.ucw.cz> <47D56F4A.5070208@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D56F4A.5070208@steeleye.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-10 13:26:34, Paul Clements wrote:
> Pavel Machek wrote:
>
>>> This patch allows a Network Block Device to be mounted locally 
>>> (nbd-client to nbd-server over 127.0.0.1).
>>>
>>> It creates a kthread to avoid the deadlock described in NBD tools 
>>> documentation. So, if nbd-client hangs waiting for pages, the kblockd 
>>> thread can continue its work and free pages.
>>
>> What happens if your new kthread blocks on memory allocation?
>
> Well, we expect that. The reason for the new thread is so that it hangs, 
> rather than kblockd hanging (which on a UP system brings all I/O to a 
> halt). As long as kblockd can continue making progress, we eventually free 
> up memory and then NBD can finish its requests, too.

...unless all the memory is in dirty buffers for nbd, and nbd server
is swapped out or something?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
