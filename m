Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbZAHUCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbZAHUCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZAHUCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:02:36 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:52760 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZAHUCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ezYDi+bcoawt8eKmAFE9l8e0U4/JKba0dNOko9C3y/oHSroFie+xckTBVBFO3t8gJd
         6pbXuhKpcr+vP2+iGVfdiFsYRMi7jGwGjKXewOwOaNRBLg7oCPzxJSwCIWGbdQZpDV2z
         y7x+KgKp+YsER9l3QdTzjLwdP/8Vn2qmscSF8=
Message-ID: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>
Date: Thu, 8 Jan 2009 23:02:33 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: arjan@infradead.org, torvalds@linux-foundation.org
Subject: Re: Too async libata breakage
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 8 Jan 2009 22:15:56 +0300
> "Alexey Dobriyan" <adobriyan@gmail.com> wrote:
>
> > commit f29d3b23238e1955a8094e038c72546e99308e61 aka
> > "fastboot: Make libata initialization even more async"
> > results in no findable /dev/sda2 to mount / here.
> >
> > Kernel correctly sees sda as 750GB drive and the rest too.
> >
> > CONFIG_ATA_PIIX is in use, everything built-in, plain partitions,
> > no initrd, DM, MD etc.
>
> hmm.
> no initrd;
>
> can you try an experiment?
> if you edit init/do_mounts.c and find the "async_synchronize_full" call.
> that is just after a while() loop.
> Can you put another call to synchronize_full to also just before that
> while loop and see if that fixes it ?

Additional async_synchronize_full() helps and box boot to the end.

Hopefully noone depends on /proc/partitions being in alphabetical order. :-)
