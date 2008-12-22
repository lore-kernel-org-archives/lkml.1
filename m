Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYLVNXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYLVNXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 08:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbYLVNXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 08:23:05 -0500
Received: from quechua.inka.de ([193.197.184.2]:52722 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbYLVNXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 08:23:04 -0500
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2008 08:23:04 EST
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have errors are read
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <494F7A02.2030302@nokia.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1LEkaR-0007Mq-00@calista.eckenfels.net>
Date: Mon, 22 Dec 2008 14:12:43 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <494F7A02.2030302@nokia.com> you wrote:
> +               /*
> +                * After a read error, we redo the request one sector at a time
> +                * in order to accurately determine which sectors can be read
> +                * successfully.
> +                */
> +               if (disable_multi && brq.data.blocks > 1)
> +                       brq.data.blocks = 1;
> +
>                if (brq.data.blocks > 1) {
>                        /* SPI multiblock writes terminate using a special
>                         * token, not a STOP_TRANSMISSION request.

We would save an comparision here if we use it like this:

...
                if (brq.data.blocks > 1) {

                 /*
                  * After a read error, we redo the request one sector at a time
                  * in order to accurately determine which sectors can be read
                  * successfully.
                  */
                  if (disable_multi)
                    brq.data.blocks = 1;                        

                  /* SPI multiblock writes terminate using a special
...


> +               if (brq.cmd.error || brq.data.error || brq.stop.error) {
> +                       if (brq.data.blocks > 1 && rq_data_dir(req) == READ) {
> +                               /* Redo read one sector at a time */
> +                               printk(KERN_WARNING "%s: retrying using single "
> +                                      "block read\n", req->rq_disk->disk_name);
> +                               disable_multi = 1;
> +                               continue;
> +                       }

Will this flood the logs?

Gruss
Bernd
