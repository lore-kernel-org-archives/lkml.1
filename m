Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbXEINlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbXEINlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXEINlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:41:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38199 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbXEINlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:41:08 -0400
Date: Wed, 9 May 2007 15:38:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Chaining sg lists for big I/O commands: Question
Message-ID: <20070509133830.GV4163@kernel.dk>
References: <Pine.LNX.4.64.0705090918390.12857@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705090918390.12857@p34.internal.lan>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09 2007, Justin Piszcz wrote:
> http://kerneltrap.org/node/8176

Oh

> I am a mdadm/disk/hard drive fanatic, I was curious:
> 
> >On i386, we can at most fit 256 scatterlist elements into a page,
> >and on x86-64 we are stuck with 128. So that puts us somewhere
> >between 512kb and 1024kb for a single IO.
> 
> How come 32bit is 256 and 64 is only 128?
>
> I am sure it is something very fundamental/simple but I was curious, I 
> would think x86_64 would fit/support more scatterlists in a page.

Because of the size of the scatterlist structure. As pointers are bigger
on 64-bit archs, the scatterlist structure ends up being bigger. The
page size on x86-64 is 4kb, hence the number of structures you can fit
in a page is smaller.

> Also, when this patch is implemented for x86_64 and if merged into 
> mainline, what does this mean for performance?

The sglist branch of block repo has x86-64 support now. I'll post a new
patchset tomorrow.

Performance wise, it's meant to help higher end hardware that need 2-4mb
(or bigger) commands to get good performance. That also includes things
like tapes that have big block sizes, getting a command of the right
size there is the difference between good and abysmal performance.

> I have an mdadm raid5 of 10 raptors and get 434MB/s write and 622MB/s 
> read, would I see an increase in performance with this patch?

Perhaps, depends on a lot of factors.

-- 
Jens Axboe

