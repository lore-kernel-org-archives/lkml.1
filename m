Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbZEJA6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbZEJA6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 20:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZEJA6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 20:58:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:46286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbZEJA6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 20:58:22 -0400
Message-ID: <4A0626A2.4060202@kernel.org>
Date: Sun, 10 May 2009 09:58:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: 2.9.29.2: ide-tape: panic when probing device at boot
References: <200905080700.n48704BR031273@turbo.physics.adelaide.edu.au> <200905091757.49697.bzolnier@gmail.com>
In-Reply-To: <200905091757.49697.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 10 May 2009 00:58:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> [ cc:ing linux-ide and knowledgeable people ]
> 
> Borislav/Tejun:
> 
> Is the 2.6.29 problem the same thing that was fixed recently?
> 
> Should I just push commit 1e75540ec5202cae63cd238c86bd880e3d496546
> ("ide-tape: remove back-to-back REQUEST_SENSE detection") to Linus
> or there is more needed to bring ide-tape to the world of living?

The oops will probably fixed the above commit.  I don't have much idea
about the DMA problem on 2.6.24 tho.  But even with the above commit
fixed, I doubt it would work.  The buffer allocation code is broken
and reliably triggered OOM on my test machine.  While trying to locate
the bug, I realized the complex code didn't do much good to begin with
and just stripped it down, so I didn't actually tracked down the
actual bug && the patch to simplify buffer management is way too large
for 2.6.29, so unless someone is willing to hunt down the bug just for
2.6.29, we're kind of stuck.  :-(

Thanks.

-- 
tejun
