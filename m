Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYJXHgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYJXHgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYJXHgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:36:00 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56700 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbYJXHf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:35:59 -0400
Date: Fri, 24 Oct 2008 09:34:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, tj@kernel.org,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [Regression] 2.6.28-rc1 (2fca5c): libata: kernel cant boot (was: Re: 2.6.27-rc1 (2fca5c): libata: kernel cant boot)
Message-ID: <20081024073458.GQ22217@kernel.dk>
References: <a4423d670810240004t2d7c3bdah2bea77a6a49bb7c4@mail.gmail.com> <20081024070955.GN22217@kernel.dk> <200810240938.54167.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810240938.54167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24 2008, Rafael J. Wysocki wrote:
> On Friday, 24 of October 2008, Jens Axboe wrote:
> > On Fri, Oct 24 2008, Alexander Beregalov wrote:
> > > Hi
> > > 
> > > commit 2fca5ccf97d2c28bcfce44f5b07d85e74e3cd18e
> > > Author: Jens Axboe <jens.axboe@oracle.com>
> > > Date:   Wed Oct 22 09:34:49 2008 +0200
> > > 
> > >     libata: switch to using block layer tagging support
> > > 
> > > 
> > > This kernel can not read even 0 sector on disk with rootfs. It
> > > initialized disk, but cant read it at all.
> > >  CMD646 on Sparc
> > > 
> > > Rverting helped.
> 
> Confirmed on hp nx6325 w/ pata_atiixp (apparently, SCSI commands time out).

Basically it'll dererence ->qcmd[] with -1 index so it'll break in
various interesting ways, I'm sure.

> Reverting the commit also helps here.
> 
> [I guess it's going to break things left and right.]

Indeed.

> > Doh, how annoying! What driver does that controller use? PATA doesn't
> > even use NCQ, so it's a bit of an oddity that it makes a difference at
> > all.
> > 
> > Can you provide the boot messages?
> 
> If I'm able to reproduce the breakage of Asus L5D, I will.

I don't need that anymore, I realized the mistake right after sending
that.

-- 
Jens Axboe

