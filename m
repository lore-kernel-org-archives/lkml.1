Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbYJYSqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbYJYSqf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYJYSq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:46:26 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34678 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbYJYSqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:46:25 -0400
Date: Sat, 25 Oct 2008 20:45:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Elias Oltmanns <eo@nebensachen.de>, Paul Mundt <lethal@linux-sh.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, tj@kernel.org,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.27-rc1 (2fca5c): libata: kernel cant boot
Message-ID: <20081025184506.GM22217@kernel.dk>
References: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com> <20081024070955.GN22217@kernel.dk> <20081024071329.GO22217@kernel.dk> <20081024071608.GA3879@linux-sh.org> <20081024072428.GP22217@kernel.dk> <873aimv0v8.fsf@denkblock.local> <20081024084818.GB22217@kernel.dk> <4903004D.2050904@vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4903004D.2050904@vc.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25 2008, Petr Vandrovec wrote:
> Jens Axboe wrote:
> >On Fri, Oct 24 2008, Elias Oltmanns wrote:
> >>Jens Axboe <jens.axboe@oracle.com> wrote:
> >>>From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
> >>>From: Jens Axboe <jens.axboe@oracle.com>
> >>>Date: Fri, 24 Oct 2008 09:22:42 +0200
> >>>Subject: [PATCH] libata: fix bug with non-ncq devices
> >>>
> >>>The recent commit 201f1b98822078c808b5e2d379a6ddbfc0a06ee1 to enable
> >>Wouldn't that be commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e?
> >
> >Yes that is correct, the other commit is actually a private one in my
> >tree for other libata changes. Updated patch below, thanks for checking!
> >
> >From e598055dde1951c47c8b3522616f6ebff0ed9847 Mon Sep 17 00:00:00 2001
> >From: Jens Axboe <jens.axboe@oracle.com>
> >Date: Fri, 24 Oct 2008 09:22:42 +0200
> >Subject: [PATCH] libata: fix bug with non-ncq devices
> 
> Hello,
>   this fixes my DVD, but unfortunately NCQ devices connected to PMP are 
> still dead - apparently as soon as mount() tries to do serious I/O on 
> the drive.  Backing out both post-2.6.28-rc1 fix as well as your 
> original change brings storage back.  I suspect that problem is that 
> with PMP same tag cannot be (should not be?  must not be?) used on 
> multiple devices behind PMP - and before your change tags were allocated 
> per-port, while now they are allocated per-device.

That would indeed break, this requires allocating the tag map in the

-- 
Jens Axboe

