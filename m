Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbXKHRu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbXKHRu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760985AbXKHRut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:50:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760963AbXKHRus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:50:48 -0500
Date: Thu, 8 Nov 2007 09:49:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roberto Oppedisano <roppedisano@infracomspa.it>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: libata: cdrw/dvdrom disabed after s2ram (2.6.24-rc2)
Message-Id: <20071108094958.5c9b1b22.akpm@linux-foundation.org>
In-Reply-To: <47333CCF.1050403@infracomspa.it>
References: <4731C86B.1040704@infracomspa.it>
	<20071107121355.5eaf4496.akpm@linux-foundation.org>
	<47333CCF.1050403@infracomspa.it>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 08 Nov 2007 17:43:59 +0100 Roberto Oppedisano <roppedisano@infracomspa.it> wrote:
> Andrew Morton wrote, On 11/07/2007 09:13 PM:
> >> On Wed, 07 Nov 2007 15:15:07 +0100 Roberto Oppedisano <roppedisano@infracomspa.it> wrote:
> >> Hello.
> >> I noticed that after suspending to ram the DVD-ROM/CDRW
> >> drive in no more recognized on my laptop. Looking at dmesg
> >> after suspend i found:
> >>
> >> [    5.313446] ata2.00: _GTF unexpected object type 0x1
> >> [    5.313453] ata2.00: ACPI on devcfg failed the second time, disabling 
> >> (errno=-22)
> >> [    5.313457] ata2.00: revalidation failed (errno=1)
> >> [    5.313459] ata2.00: disabled
> >>
> >>
> >> Not sure when the bug was introduced or if it has been always been there
> >> (but I can investigate if needed).
> >>
> >> More details on request.
> >>
> >> Following dmesg pre and after suspend.
> > Yes, it would be useful if you could work ot whether this worked OK in an
> > earlier kernel, thanks.
> Hello Andrew.
> The bug has been recently added.
> 
> I did a git-bisect, but the result is probably not completely useful,
> because many kernel did non build with my config, and I marked them as bad.

Those build errors are bad.  Please report them.  They directly prevented
you from finding the commit which caused this regression.

The only way in which we'll stop people doing crap like this is to rub
their noses (and the person who committed its nose) in it.

> Anyway here's the output of git-bisect:
> 
> rao@infra-bb:/usr/src/linux-2.6$ git bisect bad
> 99874d50481c093adfe74e796436024d88b6a48c is first bad commit
> commit 99874d50481c093adfe74e796436024d88b6a48c
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Oct 12 12:50:41 2007 +0200
> 
>     [BLOCK] Only include the compat ioctl code if CONFIG_BLOCK is set
> 
>     Add an extra CONFIG_BLOCK_COMPAT that we can use in the Makefile
> 
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> :040000 040000 f88b7b0e496edb8fbdd4bc74abd1a742a6a1d6d9
> 32ead3bd57b52a664cc8ccb662195041868d7632 M      block
> 
> ...
> 
> If needed I can do further investigation, changing the assumption of
> efefc6eb38d43b8e5daef482f575d767b002004e to good and see if the bisect
> points to a different commit.

Yes, it'll be some other commit.  Sorry.

It would help you (and me) if an ata developer could pay some attention.

Rafael, please track this as an ata regression.

