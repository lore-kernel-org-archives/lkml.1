Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZAIUWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZAIUWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZAIUWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:22:04 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:42326 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZAIUWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RScvK7anqTLYn2Sp8uSzYPTC1PDzmG6NvSrID0tykZyxO+MgzbfkxpQ8fHGvfZoy7g
         XHekF3rxTSJ3Qyrz+zDkDHSByVYVSQZSED0oxRY5U7ctZId+q28MDNDk6vIica72nwVM
         qbXkJ4EdcFxdkbAVtyBierUNnjmiBa54OweCI=
Message-ID: <48f7fe350901091221m921b63ejdd8627f04c23308c@mail.gmail.com>
Date: Fri, 9 Jan 2009 15:21:59 -0500
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 0/7] V3 of the async function call patches
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-Reply-To: <20090107151151.458333c1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090107151151.458333c1@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just wanted to say that because of these patches the kernel boots
faster than some hard drives can spin up/init... I have these patches
included in a patchset I maintain some users now need rootwait in the
kernel command line :D

-Ryan

On 1/7/09, Arjan van de Ven <arjan@infradead.org> wrote:
> version 3 of the async function call patches
>
> * Dropped the ACPI part; it broke i surprising ways; needs a rethink
>   (working with Len and co on that)
> * Included asynchronous delete()
>
>
> There is still no integration with the out of tree slow-work patch;
> the slow-work patch does really weird things with refcounts that make it
> really specific to cachefs and, frankly, I think it's a rather
> weird design.
>
> The overlap is maybe 200 lines of code at most, of which 100+ would
> need to be added just to deal with the various weirdnesses. I really
> don't think this is a good idea or a fair requirement on the async
> function call patch series.
>
> The following changes since commit 8903709b054a8dafe4e8c6d9a6444034d7aba36f:
>   Harvey Harrison (1):
>         xtensa: introduce swab.h
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async.git
> master
>
> Arjan van de Ven (7):
>       async: Asynchronous function calls to speed up kernel boot
>       fastboot: make scsi probes asynchronous
>       fastboot: make the libata port scan asynchronous
>       fastboot: Make libata initialization even more async
>       async: make the final inode deletion an asynchronous event
>       bootchart: improve output based on Dave Jones' feedback
>       async: don't do the initcall stuff post boot
>
>  drivers/ata/libata-core.c |   96 +++++++-------
>  drivers/scsi/scsi_scan.c  |    3 +
>  drivers/scsi/sd.c         |  109 ++++++++++------
>  fs/inode.c                |   20 ++-
>  fs/super.c                |   10 ++
>  include/linux/async.h     |   25 ++++
>  include/linux/fs.h        |    5 +
>  init/do_mounts.c          |    2 +
>  init/main.c               |    5 +-
>  kernel/Makefile           |    3 +-
>  kernel/async.c            |  321
> +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/irq/autoprobe.c    |    5 +
>  kernel/module.c           |    2 +
>  scripts/bootgraph.pl      |   16 ++-
>  14 files changed, 521 insertions(+), 101 deletions(-)
>  create mode 100644 include/linux/async.h
>  create mode 100644 kernel/async.c
>
>
> --
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
