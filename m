Return-Path: <linux-kernel-owner+w=401wt.eu-S935081AbXFFTKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbXFFTKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbXFFTKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:10:46 -0400
Received: from brick.kernel.dk ([80.160.20.94]:29693 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765003AbXFFTKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:10:45 -0400
Date: Wed, 6 Jun 2007 21:17:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmap_atomic in 2.6.20.x
Message-ID: <20070606191729.GE4735@kernel.dk>
References: <5d96567b0706061003r462c324i733ad3698ac3d90c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0706061003r462c324i733ad3698ac3d90c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06 2007, Raz Ben-Jehuda(caro) wrote:
> Hello
> 
> I am running into some problems with kmap_atomic in my driver.
> My driver copies some pages coming from
> user space to "kernel space kmalloc'ed memory".
> I had this code running from 2.6.5 to 2.6.17 without any problems.
> I have upgraded to 2.6.20.xx and this code fails to kmap_atomic.
> I am running a uni processor 2 GRAM machine, 32bit.
> 
> Basically this is code does:
> 
> get_user_pages(page,...)
> 
> kmap_atomic(page,KM_USER0);
> .. copy and stuff
> kunmap_atomic(page,KM_USER0)

dst = kmap_atomic(page, KM_USER0);
...
kunmap_atomic(dst, KM_USER0);

Note the subtle difference.

-- 
Jens Axboe

