Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYKKICk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYKKICk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYKKIC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:02:26 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:32912 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYKKICZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:02:25 -0500
Message-ID: <49193C06.2060008@garzik.org>
Date: Tue, 11 Nov 2008 03:02:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: "Phillip O'Donnell" <phillip.odonnell@gmail.com>,
       Oskar Liljeblad <oskar@osk.mine.nu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Avoid overflow in ata_tf_read_block() when tf->hba_lbal
 > 127
References: <20081028170105.GA21933@osk.mine.nu>	<7a9b5c320810281625kbf8904x9ba432ff0ca8c2f8@mail.gmail.com>	<ada4p2wmg5n.fsf_-_@cisco.com>	<7a9b5c320810281904x6b8b3226uaba502146be854a7@mail.gmail.com> <adatzantk53.fsf_-_@cisco.com>
In-Reply-To: <adatzantk53.fsf_-_@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Phillip O'Donnell <phillip.odonnell@gmail.com> pointed out that the same
> sign extension bug that was fixed in commit ba14a9c2 ("libata: Avoid
> overflow in ata_tf_to_lba48() when tf->hba_lbal > 127") also appears to
> exist in ata_tf_read_block().  Fix this by adding a cast to u64.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> I don't have any way to test this -- I guess you would have to get an
> error on a block above 2G (ie data above 1TB)?  But it looks "obviously
> correct" enough to add to -next I guess.
> 
>  drivers/ata/libata-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 622350d..a6ad862 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -612,7 +612,7 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
>  		if (tf->flags & ATA_TFLAG_LBA48) {
>  			block |= (u64)tf->hob_lbah << 40;
>  			block |= (u64)tf->hob_lbam << 32;
> -			block |= tf->hob_lbal << 24;
> +			block |= (u64)tf->hob_lbal << 24;
>  		} else
>  			block |= (tf->device & 0xf) << 24;

applied


