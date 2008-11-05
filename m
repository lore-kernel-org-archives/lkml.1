Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbYKEJVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbYKEJVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYKEJUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:20:47 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:58665 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYKEJUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:20:45 -0500
Date: Wed, 5 Nov 2008 10:19:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: petkovbb@gmail.com
Cc: Tejun Heo <tj@kernel.org>, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH] block: fix __blkdev_get() for removable devices
Message-ID: <20081105091921.GC21867@kernel.dk>
References: <20081029071319.GA9205@gollum.tnic> <20081101201419.GA29462@gollum.tnic> <490F1AC6.8000109@kernel.org> <9ea470500811030956k209b2f2ci10bcde1ea4ac7334@mail.gmail.com> <490FCC87.1070205@kernel.org> <20081105090449.GA9269@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105090449.GA9269@gollum.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05 2008, Borislav Petkov wrote:
> On Tue, Nov 04, 2008 at 01:16:07PM +0900, Tejun Heo wrote:
> > Commit 0762b8bde9729f10f8e6249809660ff2ec3ad735 moved disk_get_part()
> > in front of recursive get on the whole disk, which caused removable
> > devices to try disk_get_part() before rescanning after a new media is
> > inserted, which might fail legit open attempts or give the old
> > partition.
> > 
> > This patch fixes the problem by moving disk_get_part() after
> > __blkdev_get() on the whole disk.
> > 
> > This problem was spotted by Borislav Petkov.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: <Borislav Petkov> petkovbb@googlemail.com
> > ---
> > Borislav, can you please verify this patch?  Thanks.
> 
> Yep, it works. Thanks.
> 
> Tested-by: Borislav Petkov <petkovbb@gmail.com>

I merged it and added your tested-by.

-- 
Jens Axboe

