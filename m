Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbZD1PTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbZD1PTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760816AbZD1PTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:19:37 -0400
Received: from rtr.ca ([76.10.145.34]:37195 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723AbZD1PTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:19:36 -0400
Message-ID: <49F71E86.7040300@rtr.ca>
Date: Tue, 28 Apr 2009 11:19:34 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/3] mg_disk: fix CONFIG_LBD=y warning
References: <1240890740-3462-1-git-send-email-tj@kernel.org> <1240890740-3462-3-git-send-email-tj@kernel.org>
In-Reply-To: <1240890740-3462-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> drivers/block/mg_disk.c: In function ‘mg_dump_status’:
> drivers/block/mg_disk.c:265: warning: format ‘%ld’ expects type ‘long int’, but
> argument 2 has type ‘sector_t’
> 
> [ Impact: kill build warning ]
> 
> Cc: unsik Kim <donari75@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/block/mg_disk.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
> index d3e72ad..f389835 100644
> --- a/drivers/block/mg_disk.c
> +++ b/drivers/block/mg_disk.c
> @@ -79,7 +79,7 @@ static void mg_dump_status(const char *msg, unsigned int stat,
>  			if (host->breq) {
>  				req = elv_next_request(host->breq);
>  				if (req)
> -					printk(", sector=%ld", req->sector);
> +					printk(", sector=%u", (u32)req->sector);
..

Eh?  Shouldn't that be fixed the other way around, like this:

  +					printk(", sector=%llu", (u64)req->sector);

This way, it will still give correct data when sector_t is a u64.

???
