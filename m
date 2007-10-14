Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbXJNQQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbXJNQQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 12:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbXJNQQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 12:16:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:24830 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbXJNQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 12:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=RcZ+6dgjTtXBY3f/hJ7h5zlCh+H+qJ3cibE1RtMxhdQDAu6qQJz4VcMDnXuk6CLdstqxV+C7x4069+U8pTVEaopFyJnQgeG5jy0633FdKkdnYgobLZgBoUOJiMGDQJi7G2buyIe5O+exnn3GBhsHA7XjFsw6pnZWglWRc78NgFI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [git patches] IDE updates (part 1)
Date: Sun, 14 Oct 2007 17:38:39 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710120034.49730.bzolnier@gmail.com> <Pine.LNX.4.64N.0710121518030.21684@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0710121518030.21684@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710141738.39838.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007, Maciej W. Rozycki wrote:
> On Fri, 12 Oct 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> > * Kconfig facelift - as a result of this change users have three less
> >   config options to worry about (BLK_DEV_IDEPCI, BLK_DEV_IDEDMA_PCI
> >   and IDE_CHIPSETS) and can just select host drivers that they need
> 
>  Well, it depends on how you look at it.  If you have PCI, an on-board IDE 
> interface and do not want any PCI IDE controllers, then you now have a 
> zillion of options to disable instead of just one.  Have a look at 
> "arch/mips/configs/sb1250-swarm_defconfig" for an example (hmm..., 

I see, having suddenly zillion options to go through and disable may be
problem.  Fortunately not in this particular case because none of IDE PCI
host drivers is enabled by default in drivers/ide/Kconfig.

To be sure I've just checked it with:

ARCH=mips make sb1250-swarm_defconfig menuconfig

and it looks fine (all IDE PCI host drivers are disabled).

However big thanks for raising this point.  I was unaware of such side-effect
while working on the above change but from now on I'll keep this in mind. :)

> CONFIG_BLK_DEV_IDE_SWARM disabled by default -- that should probably be 
> changed; I'll cook a patch).  I guess it is not possible to make everyone 
> happy at once though, so please do not treat it as a hard objection. :-)

Hmm, it also seems that CONFIG_IDE_GENERIC=y may be removed now because
IDE SWARM host driver does the probing itself?

Thanks,
Bart
