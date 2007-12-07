Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbXLGElB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbXLGElB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXLGEkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:40:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:27640 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbXLGEku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:40:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WJGsRB3L/nyV1spazA1pgvPfBxrOhkIHOWHYBO8JyWtoUNX2tvQVEfY4BTk2WtKaoCnhHJPR0Gdttw4RNeDmj2YfqbOk+tBP5KU0prmT1i7v8ocOeBA43NDVAQqHuN7dWHAEu4dJRoXmsvYFE9rbI3i+T+gDDJitl6OVvMkW88c=
Message-ID: <6934efce0712062040j22805c86t678a0d3c78be9305@mail.gmail.com>
Date: Thu, 6 Dec 2007 20:40:49 -0800
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [patch] ext2: xip check fix
Cc: carsteno@de.ibm.com, "Nick Piggin" <npiggin@suse.de>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jens Axboe" <axboe@kernel.dk>
In-Reply-To: <200712062217.40355.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204042628.GA26636@wotan.suse.de>
	 <200712061211.49443.rob@landley.net>
	 <6934efce0712061922j682cee55pc1d5d079465f4849@mail.gmail.com>
	 <200712062217.40355.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Um, trying to clarify:  S390.  Also known as zSeries, big iron machine, uses
> its own weird processor design rather than x86, x86-64, arm, or mips
> processors.

Right.  filemap_xip.c allows for an XIP filesystem.  The only
filesystem that is supported is ext2.  Even that requires a block
device driver thingy, which I don't understand, that's specific to the
s390.

> How does "struct page" enter into this?

Don't sweat it, it has to do with the way filemap_xip.c works.

> What I want to know is, are you saying execute in place doesn't work on things
> like arm and mips?  (I so, I was unaware of this.  I heard about somebody
> getting it to work on a Nintendo DS:
> http://forums.maxconsole.net/showthread.php?t=18668 )

XIP works fine on things like arm and mips.  However there is mixed
support in the mainline kernel for it.  For example, you can build an
XiP kernel image for arm since like 2.6.10 or 12.  Also MTD has an XiP
aware mode that protects XiP objects in flash from get screwed up
during programs and erases.  But there is no mainlined solution for
XiP of applications from the filesystem.  However there have been
patches for cramfs to do this for years.  They are kind of messy and
keep getting rejected.  I do have a solution in the works for this
part of it - http://axfs.sf.net.
