Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbZAHUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbZAHUSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZAHUSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:18:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:62475 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZAHUSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=eNshWhQBmtbJ6Gd5mHKlwWy5yE+5O51BOqjSKPelpY6gYW0N8g7QeKIgaUAdXAYEbf
         P4TwHcYdoUeNkpf96OV4JxAb6J5ymD1xP759edW9pzfkNnBesisxPLSDCjHkECMlDxj+
         nbiKFwDa47ICSbEh00BLik8UtP03KhD9av8n8=
Date: Thu, 8 Jan 2009 22:17:53 +0200
From: Pekka Paalanen <pq@iki.fi>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: arjan@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, pq@iki.fi
Subject: Re: Too async libata breakage
Message-ID: <20090108221753.78648cd6@daedalus.pq.iki.fi>
In-Reply-To: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 23:02:33 +0300
"Alexey Dobriyan" <adobriyan@gmail.com> wrote:

> > On Thu, 8 Jan 2009 22:15:56 +0300
> > "Alexey Dobriyan" <adobriyan@gmail.com> wrote:
> >
> > > commit f29d3b23238e1955a8094e038c72546e99308e61 aka
> > > "fastboot: Make libata initialization even more async"
> > > results in no findable /dev/sda2 to mount / here.
> > >
> > > Kernel correctly sees sda as 750GB drive and the rest too.
> > >
> > > CONFIG_ATA_PIIX is in use, everything built-in, plain partitions,
> > > no initrd, DM, MD etc.
> >
> > hmm.
> > no initrd;
> >
> > can you try an experiment?
> > if you edit init/do_mounts.c and find the "async_synchronize_full" call.
> > that is just after a while() loop.
> > Can you put another call to synchronize_full to also just before that
> > while loop and see if that fixes it ?
> 
> Additional async_synchronize_full() helps and box boot to the end.

I just hit this bug, too. I don't have the kernel logs to attach here,
but it looks like sd has just found sda, when mounting root fs is
attempted, and sda partitions have not been read yet. This leads to
panic as root cannot be mounted. I have only tried
linus/master and Ingo's tip/master today, no bisecting.

My setup is Thinkpad T61, Core 2 Duo, a SATA disk, no initrd.

Adding rootdelay=5 allows me to boot properly, and so does the
experiment suggested above.

I'm not subscribed, so please cc me. Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
