Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYBYVdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYBYVdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbYBYVdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:33:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:20344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbYBYVdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:33:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=xiwWXRaepVt02MUzeWlub/Of94l/5XAvL8MbVz37cZN8gFCzGWWQpzK6G9vuAfFJJnM/4SKE5mr3nFsNFI+pV19ULF7Z3mM65du23mbpgeikPJeURxe1dBXMZcIdJ4XKUfCwBfM18PGmkfkU4q3ZvUPrqxej/jICPaC3jf76gMg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: new regression in 2.6.25-rc3: can't resume from suspend to ram, ata1 errors
Date: Mon, 25 Feb 2008 22:28:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@suse.cz>,
       "Jeff Garzik" <jeff@garzik.org>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org
References: <8f53421d0802251257o75d2975dldcfb99a2dc5e3539@mail.gmail.com> <200802252200.23495.rjw@sisk.pl>
In-Reply-To: <200802252200.23495.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252229.00027.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008, Rafael J. Wysocki wrote:
> On Monday, 25 of February 2008, Michael S. Tsirkin wrote:
> > On my T61p, 2.6.25-rc2 seems to wake up fine from suspend to ram.
> > Not so 2.6.25-rc3: it hangs on suspend to ram, with a blank screen.
> 
> Thanks for the report.
> 
> > At one point I got lucky and got this on console (wrote down by hand,
> > there could be typos):
> > ata1: COMRESET failed (errno=-16)
> > ata1: COMRESET failed (errno=-16)
> > end_request: I/O error, dev sda sector 200554
> > Buffer I/O error on device dm-0, logical block 256
> > Buffer I/O error on device dm-0, logical block 15695875
> > Buffer I/O error on device dm-0, logical block 15695878
> > Buffer I/O error on device dm-0, logical block 15695887
> > Buffer I/O error on device dm-0, logical block 15695896
> > Buffer I/O error on device dm-0, logical block 15695914
> > Buffer I/O error on device dm-0, logical block 15958028
> > Buffer I/O error on device dm-0, logical block 22118530
> > Buffer I/O error on device dm-0, logical block 22315068
> > Buffer I/O error on device dm-0, logical block 22347824
> > 
> > git bisect points at this commit:
> > commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.
> > power_state: get rid of write-only variable in SATA
> 
> Jeff, could you revert it, please?

Jeff, this was applied between -rc2 and -rc3.

100% cleanup patches which change behavior are potentialy
risky and shouldn't be considered as a -rc material.

Thanks,
Bart
