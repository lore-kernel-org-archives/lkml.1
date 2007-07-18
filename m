Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbXGRUPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbXGRUPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbXGRUP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:15:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48449 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbXGRUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:15:28 -0400
Date: Wed, 18 Jul 2007 13:14:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
In-Reply-To: <20070718200835.GK11657@kernel.dk>
Message-ID: <alpine.LFD.0.999.0707181313100.27353@woody.linux-foundation.org>
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com>
 <alpine.LFD.0.999.0707181238500.27353@woody.linux-foundation.org>
 <20070718200835.GK11657@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Jens Axboe wrote:
> 
> I think your analysis is pretty good, however you'd probably want to
> incorporate that direct in ide_end_request().

Ok, that makes sense too.

And yes, the further cleanup would be:

> Better still would be to make __ide_end_request() take a byte count
> instead and use end_that_request_chunk(). Then you can get rid of the
> rounding as well.

and that sounds fine, but is an independent issue and not strictly 
necessary.

Bartlomiej?

		Linus
