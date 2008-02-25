Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbYBYVCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbYBYVCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbYBYVBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:01:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60382 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291AbYBYVBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:01:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: new regression in 2.6.25-rc3: can't resume from suspend to ram, ata1 errors
Date: Mon, 25 Feb 2008 22:00:22 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@suse.cz>,
       "Jeff Garzik" <jeff@garzik.org>, jgarzik@pobox.com,
       linux-ide@vger.kernel.org
References: <8f53421d0802251257o75d2975dldcfb99a2dc5e3539@mail.gmail.com>
In-Reply-To: <8f53421d0802251257o75d2975dldcfb99a2dc5e3539@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252200.23495.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 25 of February 2008, Michael S. Tsirkin wrote:
> On my T61p, 2.6.25-rc2 seems to wake up fine from suspend to ram.
> Not so 2.6.25-rc3: it hangs on suspend to ram, with a blank screen.

Thanks for the report.

> At one point I got lucky and got this on console (wrote down by hand,
> there could be typos):
> ata1: COMRESET failed (errno=-16)
> ata1: COMRESET failed (errno=-16)
> end_request: I/O error, dev sda sector 200554
> Buffer I/O error on device dm-0, logical block 256
> Buffer I/O error on device dm-0, logical block 15695875
> Buffer I/O error on device dm-0, logical block 15695878
> Buffer I/O error on device dm-0, logical block 15695887
> Buffer I/O error on device dm-0, logical block 15695896
> Buffer I/O error on device dm-0, logical block 15695914
> Buffer I/O error on device dm-0, logical block 15958028
> Buffer I/O error on device dm-0, logical block 22118530
> Buffer I/O error on device dm-0, logical block 22315068
> Buffer I/O error on device dm-0, logical block 22347824
> 
> git bisect points at this commit:
> commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2.
> power_state: get rid of write-only variable in SATA

Jeff, could you revert it, please?

Thanks,
Rafael
