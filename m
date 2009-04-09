Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbZDIJoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbZDIJoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbZDIJn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:43:59 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40702 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbZDIJn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:43:58 -0400
X-Sasl-enc: NgwWIiQVQwMi5511XSb0kyERyCUqLqVANIct/cI0sM7r 1239270237
Message-ID: <49DDC35B.1010606@fastmail.fm>
Date: Thu, 09 Apr 2009 10:43:55 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 05/56] block: Remove void casts
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/block/amiflop.c    |    2 +-
>  drivers/block/cciss.c      |   11 ++++-------
>  drivers/block/cciss_scsi.c |    3 +--
>  drivers/block/cpqarray.c   |    2 +-
>  drivers/block/sx8.c        |    2 +-
>  drivers/block/viodasd.c    |    3 +--
>  6 files changed, 9 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
> index 8df436f..702667b 100644
> --- a/drivers/block/amiflop.c
> +++ b/drivers/block/amiflop.c
> @@ -1727,7 +1727,7 @@ static int __init amiga_floppy_init(void)
>  	}
>  
>  	ret = -ENOMEM;
> -	if ((raw_buf = (char *)amiga_chip_alloc (RAW_BUF_SIZE, "Floppy")) ==
> +	if ((raw_buf = amiga_chip_alloc (RAW_BUF_SIZE, "Floppy")) ==
>  	    NULL) {
>  		printk("fd: cannot get chip mem buffer\n");
>  		goto out_memregion;
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 0ef6f08..0c4747a 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -452,7 +452,7 @@ static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool)
>  	dma_addr_t cmd_dma_handle, err_dma_handle;
>  
>  	if (!get_from_pool) {
> -		c = (CommandList_struct *) pci_alloc_consistent(h->pdev,
> +		c = pci_alloc_consistent(h->pdev,
>  			sizeof(CommandList_struct), &cmd_dma_handle);
>  		if (c == NULL)
>  			return NULL;
> @@ -460,8 +460,7 @@ static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool)
>  
>  		c->cmdindex = -1;
>  
> -		c->err_info = (ErrorInfo_struct *)
> -		    pci_alloc_consistent(h->pdev, sizeof(ErrorInfo_struct),
> +		c->err_info = pci_alloc_consistent(h->pdev, sizeof(ErrorInfo_struct),
>  			    &err_dma_handle);
>  
>  		if (c->err_info == NULL) {
> @@ -3773,12 +3772,10 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	hba[i]->cmd_pool_bits =
>  	    kmalloc(DIV_ROUND_UP(hba[i]->nr_cmds, BITS_PER_LONG)
>  			* sizeof(unsigned long), GFP_KERNEL);
> -	hba[i]->cmd_pool = (CommandList_struct *)
> -	    pci_alloc_consistent(hba[i]->pdev,
> +	hba[i]->cmd_pool = pci_alloc_consistent(hba[i]->pdev,
>  		    hba[i]->nr_cmds * sizeof(CommandList_struct),
>  		    &(hba[i]->cmd_pool_dhandle));
> -	hba[i]->errinfo_pool = (ErrorInfo_struct *)
> -	    pci_alloc_consistent(hba[i]->pdev,
> +	hba[i]->errinfo_pool = pci_alloc_consistent(hba[i]->pdev,
>  		    hba[i]->nr_cmds * sizeof(ErrorInfo_struct),
>  		    &(hba[i]->errinfo_pool_dhandle));
>  	if ((hba[i]->cmd_pool_bits == NULL)
> diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index a3fd87b..1e997b2 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -212,8 +212,7 @@ scsi_cmd_stack_setup(int ctlr, struct cciss_scsi_adapter_data_t *sa)
>  	// pci_alloc_consistent guarantees 32-bit DMA address will
>  	// be used
>  
> -	stk->pool = (struct cciss_scsi_cmd_stack_elem_t *)
> -		pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
> +	stk->pool = pci_alloc_consistent(hba[ctlr]->pdev, size, &stk->cmd_pool_handle);
>  
>  	if (stk->pool == NULL) {
>  		printk("stk->pool is null\n");
> diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
> index ca268ca..207fbb6 100644
> --- a/drivers/block/cpqarray.c
> +++ b/drivers/block/cpqarray.c
> @@ -1353,7 +1353,7 @@ static cmdlist_t * cmd_alloc(ctlr_info_t *h, int get_from_pool)
>  	dma_addr_t cmd_dhandle;
>  
>  	if (!get_from_pool) {
> -		c = (cmdlist_t*)pci_alloc_consistent(h->pci_dev, 
> +		c = pci_alloc_consistent(h->pci_dev, 
>  			sizeof(cmdlist_t), &cmd_dhandle);
>  		if(c==NULL)
>  			return NULL;
> diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
> index ff0448e..48c8bb4 100644
> --- a/drivers/block/sx8.c
> +++ b/drivers/block/sx8.c
> @@ -890,7 +890,7 @@ queue_one_request:
>  	 */
>  
>  	VPRINTK("build msg\n");
> -	msg = (struct carm_msg_rw *) carm_ref_msg(host, crq->tag);
> +	msg = carm_ref_msg(host, crq->tag);
>  
>  	if (writing) {
>  		msg->type = CARM_MSG_WRITE;
> diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
> index ecccf65..6e1210e 100644
> --- a/drivers/block/viodasd.c
> +++ b/drivers/block/viodasd.c
> @@ -285,8 +285,7 @@ static int send_request(struct request *req)
>  				((u64)sg_dma_address(&sg[0])) << 32,
>  				sg_dma_len(&sg[0]));
>  	else {
> -		bevent = (struct vioblocklpevent *)
> -			vio_get_event_buffer(viomajorsubtype_blockio);
> +		bevent = vio_get_event_buffer(viomajorsubtype_blockio);
>  		if (bevent == NULL) {
>  			printk(VIOD_KERN_WARNING
>  			       "error allocating disk event buffer\n");
>   

