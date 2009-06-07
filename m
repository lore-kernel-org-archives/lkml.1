Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZFGOw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZFGOw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZFGOwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:52:46 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63383 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbZFGOwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=FWBvX/wlIwNRyXkH84YEGjGEB4dxu3AiDzsXYYAgSP3tK1h7Q1dptbOPU8mXScpw89
         82Pqiv/8+4zYj+lm7+qVuuyREWxlYxvaTyur10CUJmoEF3Fa8qAlTYyE1vOF3pdQ+zVx
         jPG39RrywonqhXjz4Z5D/cb5qf10k8Rc2gaQA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 16:57:49 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <20090607152151.3cb01901@lxorguk.ukuu.org.uk> <1244385536.8262.5.camel@mulgrave.site>
In-Reply-To: <1244385536.8262.5.camel@mulgrave.site>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906071657.49513.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 16:38:56 James Bottomley wrote:
> On Sun, 2009-06-07 at 15:21 +0100, Alan Cox wrote:
> > > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > > index 99e33ef..4bc2c43 100644
> > > --- a/fs/partitions/check.c
> > > +++ b/fs/partitions/check.c
> > 
> > 
> > You seriously want to add code to the core partition handling logic
> > moments before release when we know we have all sorts of devices with
> > weird behaviours ?
> > 
> > This should be .31 stuff where we can take the time to see how it works
> > on all sorts of weird real world devices (eg those with 2K sector size)
> > and the like.
> 
> Absolutely seconded.
> 
> Plus this is only one of the proposals for dealing with IDE native sizes
> moving through the process.  The other one is in libata with the gendisk
> proposal for alt size instead of your set_capacity callback.   The last

->set_capacity callback is needed for drivers/ide regardless of alt_size
sysfs interface and it don't conflict with it in any way.

Those patches are a complimentary work to Tejun's alt_size patches. 

They don't export anything to user-space.

> thing we want is two separate mechanisms for this, so trying to push
> anything upstream before we have agreement on direction is premature ...
> trying to send a feature as a bug fix is doubly so.

James, please (re-)read commits, then bug #13365 at kernel.org and if you
still find some code parts controversial I'll be happy to discuss them.

Thanks.
Bart
