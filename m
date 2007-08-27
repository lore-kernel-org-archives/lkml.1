Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbXH0Iu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbXH0Iu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 04:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXH0Iut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 04:50:49 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19546 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbXH0Iut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 04:50:49 -0400
Date: Mon, 27 Aug 2007 10:50:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] dynamic pipe resizing
Message-ID: <20070827085045.GP23758@kernel.dk>
References: <20070824085221.GA23758@kernel.dk> <Pine.LNX.4.64.0708241500370.28540@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708241500370.28540@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24 2007, Jan Engelhardt wrote:
> 
> On Aug 24 2007 10:52, Jens Axboe wrote:
> >Hi,
> >
> >Dabbling around with splice a bit, I added some code to change the size
> >of a pipe. Currently it's hardcoded as 16 pages, with this patch you can
> >shrink (if you wanted) or grow (the likely scenario) if you want to
> >increase the size of your in-kernel buffer for splice operations.
> 
> Wonderful, I just did the same {-.-}
> (but then dropped the patch because it did not help my application at all,
> so never mind).
> 
> >Like with my original splice patches from 2005, I used fcntl()
> >F_GETPIPE_SZ and F_SETPIPE_SZ to change the size of the pipe. I'm not
> >particularly fond of that interface, so suggestions on how to improve it
> >would be appreciated. Even if fcntl() should be the preferred approach,
> >I think it would be better to pass in a byte based value instead of a
> >number of pages.
> 
> And using  % pipe->buffers then?

I'd probably prefer sticking to power-of-2 array sizes, so just round it
up appropriately. But it's likely not a big deal.

-- 
Jens Axboe

