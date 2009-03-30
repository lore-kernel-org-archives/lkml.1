Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbZC3TDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbZC3TDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbZC3TDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:03:32 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:50645 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbZC3TDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:03:30 -0400
Date: Mon, 30 Mar 2009 21:05:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, jens.axboe@oracle.com,
       nab@risingtidestorage.com, andi@firstfloor.org,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 13/13] DRBD: final
Message-ID: <20090330190530.GA4028@uranus.ravnborg.org>
References: <1238431643-19433-7-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-8-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-9-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-10-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-11-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-12-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-13-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-14-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-15-git-send-email-philipp.reisner@linbit.com> <1238431643-19433-16-git-send-email-philipp.reisner@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238431643-19433-16-git-send-email-philipp.reisner@linbit.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#
> +config BLK_DEV_DRBD
> +	tristate "DRBD Distributed Replicated Block Device support"
> +	select INET
> +	select PROC_FS
> +	select CONNECTOR
> +	select CRYPTO
> +	select CRYPTO_HMAC

Have you double checked that these symbols are supposed to be 'selected'?
If they:
- have dependencies
- have a prompt
then they most likely are not.


> @@ -0,0 +1,7 @@
> +#CFLAGS_drbd_sizeof_sanity_check.o = -Wpadded # -Werror
Commented out?


> +
> +drbd-objs  :=	drbd_buildtag.o drbd_bitmap.o drbd_proc.o \
> +		drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o \
> +		lru_cache.o drbd_main.o drbd_strings.o drbd_nl.o

Please use:
drdb-y := drbd_buildtag.o drbd_bitmap.o drbd_proc.o
...

And my personal taste favours:
drdb-y := ...
drdb-y += ...

over all the escaping.

	Sam
