Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZHKQkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZHKQkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZHKQkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:40:17 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52833 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbZHKQkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:40:15 -0400
Subject: Re: [PATCH 12/14] scsi: use printk_once
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	 <1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 11:40:13 -0500
Message-Id: <1250008813.4301.55.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-09 at 21:54 +0200, Marcin Slusarz wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/53c700.c             |    6 +-----
>  drivers/scsi/cxgb3i/cxgb3i_init.c |    7 +------
>  2 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index f5a9add..c5f4fa7 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -291,7 +291,6 @@ NCR_700_detect(struct scsi_host_template *tpnt,
>  	__u8 *memory;
>  	__u32 *script;
>  	struct Scsi_Host *host;
> -	static int banner = 0;
>  	int j;
>  
>  	if(tpnt->sdev_attrs == NULL)
> @@ -385,10 +384,7 @@ NCR_700_detect(struct scsi_host_template *tpnt,
>  	else
>  		hostdata->rev = (NCR_700_readb(host, CTEST7_REG)>>4) & 0x0f;
>  	hostdata->fast = (NCR_700_readb(host, CTEST9_REG) == 0);
> -	if (banner == 0) {
> -		printk(KERN_NOTICE "53c700: Version " NCR_700_VERSION " By James.Bottomley@HansenPartnership.com\n");
> -		banner = 1;
> -	}
> +	printk_once(KERN_NOTICE "53c700: Version " NCR_700_VERSION " By James.Bottomley@HansenPartnership.com\n");
>  	printk(KERN_NOTICE "scsi%d: %s rev %d %s\n", host->host_no,
>  	       hostdata->chip710 ? "53c710" :
>  	       (hostdata->fast ? "53c700-66" : "53c700"),
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
> index 042d9bc..8c9285f 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_init.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
> @@ -43,12 +43,7 @@ static struct cxgb3_client t3c_client = {
>   */
>  static void open_s3_dev(struct t3cdev *t3dev)
>  {
> -	static int vers_printed;
> -
> -	if (!vers_printed) {
> -		printk(KERN_INFO "%s", version);
> -		vers_printed = 1;
> -	}
> +	printk_once(KERN_INFO "%s", version);

There's really no point to this beyond code churn.  Both patterns are
correct uses so conversion buys us nothing.

James


