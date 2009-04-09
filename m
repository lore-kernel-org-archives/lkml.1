Return-Path: <linux-kernel-owner+w=401wt.eu-S933393AbZDIK2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbZDIK2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZDIK1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:27:50 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33187 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZDIK1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:27:48 -0400
X-Sasl-enc: mQ6rbsPogUS2rp/gUw0iiPmPQdPj8VVIxqljcnF1trf7 1239272865
Message-ID: <49DDCD9E.1090801@fastmail.fm>
Date: Thu, 09 Apr 2009 11:27:42 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH 45/56] scsi: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080458u71ccbd15vd568bbf25c218a6a@mail.gmail.com> <49DCAD12.4070706@fastmail.fm>
In-Reply-To: <49DCAD12.4070706@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Fixed patch
>
> Thanks,
>
> Jack
>
> --
>
> scsi: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  drivers/scsi/aic7xxx/aic79xx_core.c         |    6 ++----
>  drivers/scsi/aic7xxx/aic7xxx_core.c         |    9 +++------
>  drivers/scsi/aic7xxx/aicasm/aicasm.c        |   10 +++++-----
>  drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c |    4 ++--
>  drivers/scsi/aic7xxx_old.c                  |    3 +--
>  drivers/scsi/ibmvscsi/ibmvscsi.c            |    3 +--
>  drivers/scsi/ibmvscsi/ibmvstgt.c            |    3 +--
>  drivers/scsi/lpfc/lpfc_hbadisc.c            |    3 +--
>  drivers/scsi/lpfc/lpfc_init.c               |    4 ++--
>  drivers/scsi/lpfc/lpfc_nportdisc.c          |    4 ++--
>  drivers/scsi/lpfc/lpfc_sli.c                |    8 ++++----
>  drivers/scsi/osst.c                         |    6 +++---
>  drivers/scsi/scsi_debug.c                   |    2 +-
>  13 files changed, 28 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c
> b/drivers/scsi/aic7xxx/aic79xx_core.c
> index 63b521d..b971974 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_core.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_core.c
> @@ -6932,13 +6932,11 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
>          int error;
>  #endif
>  
> -        next_scb = (struct scb *)malloc(sizeof(*next_scb),
> -                        M_DEVBUF, M_NOWAIT);
> +        next_scb = malloc(sizeof(*next_scb), M_DEVBUF, M_NOWAIT);
>          if (next_scb == NULL)
>              break;
>  
> -        pdata = (struct scb_platform_data *)malloc(sizeof(*pdata),
> -                               M_DEVBUF, M_NOWAIT);
> +        pdata = malloc(sizeof(*pdata), M_DEVBUF, M_NOWAIT);
>          if (pdata == NULL) {
>              free(next_scb, M_DEVBUF);
>              break;
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c
> b/drivers/scsi/aic7xxx/aic7xxx_core.c
> index e6f2bb7..e17825d 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
> @@ -2152,8 +2152,7 @@ ahc_alloc_tstate(struct ahc_softc *ahc, u_int
> scsi_id, char channel)
>       && ahc->enabled_targets[scsi_id] != master_tstate)
>          panic("%s: ahc_alloc_tstate - Target already allocated",
>                ahc_name(ahc));
> -    tstate = (struct ahc_tmode_tstate*)malloc(sizeof(*tstate),
> -                           M_DEVBUF, M_NOWAIT);
> +    tstate = malloc(sizeof(*tstate), M_DEVBUF, M_NOWAIT);
>      if (tstate == NULL)
>          return (NULL);
>  
> @@ -4783,8 +4782,7 @@ ahc_init_scbdata(struct ahc_softc *ahc)
>      SLIST_INIT(&scb_data->sg_maps);
>  
>      /* Allocate SCB resources */
> -    scb_data->scbarray =
> -        (struct scb *)malloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
> +    scb_data->scbarray = malloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
>                   M_DEVBUF, M_NOWAIT);
>      if (scb_data->scbarray == NULL)
>          return (ENOMEM);
> @@ -5014,8 +5012,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)
>  #ifndef __linux__
>          int error;
>  #endif
> -        pdata = (struct scb_platform_data *)malloc(sizeof(*pdata),
> -                               M_DEVBUF, M_NOWAIT);
> +        pdata = malloc(sizeof(*pdata), M_DEVBUF, M_NOWAIT);
>          if (pdata == NULL)
>              break;
>          next_scb->platform_data = pdata;
> diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.c
> b/drivers/scsi/aic7xxx/aicasm/aicasm.c
> index e4a7787..38e1690 100644
> --- a/drivers/scsi/aic7xxx/aicasm/aicasm.c
> +++ b/drivers/scsi/aic7xxx/aicasm/aicasm.c
> @@ -497,7 +497,7 @@ emit_patch(scope_t *scope, int patch)
>          /* No-Op patch */
>          return;
>  
> -    new_patch = (patch_t *)malloc(sizeof(*new_patch));
> +    new_patch = malloc(sizeof(*new_patch));
>  
>      if (new_patch == NULL)
>          stop("Could not malloc patch structure", EX_OSERR);
> @@ -550,7 +550,7 @@ output_listing(char *ifilename)
>  
>      func_values = NULL;
>      if (func_count != 0) {
> -        func_values = (int *)malloc(func_count * sizeof(int));
> +        func_values = malloc(func_count * sizeof(int));
>  
>          if (func_values == NULL)
>              stop("Could not malloc", EX_OSERR);
> @@ -734,7 +734,7 @@ seq_alloc()
>  {
>      struct instruction *new_instr;
>  
> -    new_instr = (struct instruction *)malloc(sizeof(struct instruction));
> +    new_instr = malloc(sizeof(struct instruction));
>      if (new_instr == NULL)
>          stop("Unable to malloc instruction object", EX_SOFTWARE);
>      memset(new_instr, 0, sizeof(*new_instr));
> @@ -748,7 +748,7 @@ cs_alloc()
>  {
>      critical_section_t *new_cs;
>  
> -    new_cs= (critical_section_t *)malloc(sizeof(critical_section_t));
> +    new_cs= malloc(sizeof(critical_section_t));
>      if (new_cs == NULL)
>          stop("Unable to malloc critical_section object", EX_SOFTWARE);
>      memset(new_cs, 0, sizeof(*new_cs));
> @@ -762,7 +762,7 @@ scope_alloc()
>  {
>      scope_t *new_scope;
>  
> -    new_scope = (scope_t *)malloc(sizeof(scope_t));
> +    new_scope = malloc(sizeof(scope_t));
>      if (new_scope == NULL)
>          stop("Unable to malloc scope object", EX_SOFTWARE);
>      memset(new_scope, 0, sizeof(*new_scope));
> diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> index 078ed60..c7c5812 100644
> --- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> +++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
> @@ -67,7 +67,7 @@ symbol_create(char *name)
>  {
>      symbol_t *new_symbol;
>  
> -    new_symbol = (symbol_t *)malloc(sizeof(symbol_t));
> +    new_symbol = malloc(sizeof(symbol_t));
>      if (new_symbol == NULL) {
>          perror("Unable to create new symbol");
>          exit(EX_SOFTWARE);
> @@ -227,7 +227,7 @@ symlist_add(symlist_t *symlist, symbol_t *symbol,
> int how)
>  {
>      symbol_node_t *newnode;
>  
> -    newnode = (symbol_node_t *)malloc(sizeof(symbol_node_t));
> +    newnode = malloc(sizeof(symbol_node_t));
>      if (newnode == NULL) {
>          stop("symlist_add: Unable to malloc symbol_node", EX_SOFTWARE);
>          /* NOTREACHED */
> diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
> index 93984c9..96c2f92 100644
> --- a/drivers/scsi/aic7xxx_old.c
> +++ b/drivers/scsi/aic7xxx_old.c
> @@ -2569,8 +2569,7 @@ aic7xxx_allocate_scb(struct aic7xxx_host *p)
>      if (scb_ap == NULL)
>        return(0);
>      scb_dma = (struct aic7xxx_scb_dma *)&scb_ap[scb_count];
> -    hsgp = (struct hw_scatterlist *)
> -      pci_alloc_consistent(p->pdev, scb_size * scb_count,
> +    hsgp = pci_alloc_consistent(p->pdev, scb_size * scb_count,
>                 &scb_dma->dma_address);
>      if (hsgp == NULL)
>      {
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c
> b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index c9aa761..7a90d4c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -423,8 +423,7 @@ static int map_sg_data(struct scsi_cmnd *cmd,
>  
>      /* get indirect table */
>      if (!evt_struct->ext_list) {
> -        evt_struct->ext_list = (struct srp_direct_buf *)
> -            dma_alloc_coherent(dev,
> +        evt_struct->ext_list = dma_alloc_coherent(dev,
>                         SG_ALL * sizeof(struct srp_direct_buf),
>                         &evt_struct->ext_list_token, 0);
>          if (!evt_struct->ext_list) {
> diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c
> b/drivers/scsi/ibmvscsi/ibmvstgt.c
> index e2dd6a4..ceb3737 100644
> --- a/drivers/scsi/ibmvscsi/ibmvstgt.c
> +++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
> @@ -852,8 +852,7 @@ static int ibmvstgt_probe(struct vio_dev *dev, const
> struct vio_device_id *id)
>      if (err)
>          goto put_host;
>  
> -    dma = (unsigned int *) vio_get_attribute(dev, "ibm,my-dma-window",
> -                         &dma_size);
> +    dma = vio_get_attribute(dev, "ibm,my-dma-window", &dma_size);
>      if (!dma || dma_size != 40) {
>          eprintk("Couldn't get window property %d\n", dma_size);
>          err = -EIO;
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c
> b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 311ed6d..dabe99d 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -2441,8 +2441,7 @@ lpfc_setup_disc_node(struct lpfc_vport *vport,
> uint32_t did)
>          if ((vport->fc_flag & FC_RSCN_MODE) != 0 &&
>              lpfc_rscn_payload_check(vport, did) == 0)
>              return NULL;
> -        ndlp = (struct lpfc_nodelist *)
> -             mempool_alloc(vport->phba->nlp_mem_pool, GFP_KERNEL);
> +        ndlp = mempool_alloc(vport->phba->nlp_mem_pool, GFP_KERNEL);
>          if (!ndlp)
>              return NULL;
>          lpfc_nlp_init(vport, ndlp, did);
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 06874e6..808a66b 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -992,7 +992,7 @@ lpfc_handle_latt(struct lpfc_hba *phba)
>      struct lpfc_dmabuf *mp;
>      int rc = 0;
>  
> -    pmb = (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +    pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
>      if (!pmb) {
>          rc = 1;
>          goto lpfc_handle_latt_err_exit;
> @@ -2322,7 +2322,7 @@ lpfc_enable_msix(struct lpfc_hba *phba)
>      /*
>       * Configure HBA MSI-X attention conditions to messages
>       */
> -    pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +    pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
>  
>      if (!pmb) {
>          rc = -ENOMEM;
> diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c
> b/drivers/scsi/lpfc/lpfc_nportdisc.c
> index 8f548ad..0ab2616 100644
> --- a/drivers/scsi/lpfc/lpfc_nportdisc.c
> +++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
> @@ -1082,7 +1082,7 @@ lpfc_cmpl_adisc_adisc_issue(struct lpfc_vport *vport,
>      cmdiocb = (struct lpfc_iocbq *) arg;
>      rspiocb = cmdiocb->context_un.rsp_iocb;
>  
> -    ap = (ADISC *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
> +    ap = lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
>      irsp = &rspiocb->iocb;
>  
>      if ((irsp->ulpStatus) ||
> @@ -1420,7 +1420,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport
> *vport, struct lpfc_nodelist *ndlp,
>  
>      cmdiocb = (struct lpfc_iocbq *) arg;
>      rspiocb = cmdiocb->context_un.rsp_iocb;
> -    npr = (PRLI *)lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
> +    npr = lpfc_check_elscmpl_iocb(phba, cmdiocb, rspiocb);
>  
>      irsp = &rspiocb->iocb;
>      if (irsp->ulpStatus) {
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index a36a120..966fcc5 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -313,7 +313,7 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
>      MAILBOX_t *pmbox;
>      int i, rc, ret = 0;
>  
> -    pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +    pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
>      if (!pmb)
>          return -ENOMEM;
>      pmbox = &pmb->mb;
> @@ -2591,7 +2591,7 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
>              "0329 Kill HBA Data: x%x x%x\n",
>              phba->pport->port_state, psli->sli_flag);
>  
> -    pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +    pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
>      if (!pmb)
>          return 1;
>  
> @@ -2939,7 +2939,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba)
>                  /* Get a Mailbox buffer to setup mailbox
>                   * commands for HBA initialization
>                   */
> -    pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +    pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
>  
>      if (!pmb)
>          return -ENOMEM;
> @@ -3006,7 +3006,7 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int
> sli_mode)
>      LPFC_MBOXQ_t *pmb;
>      uint32_t resetcount = 0, rc = 0, done = 0;
>  
> -    pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
> +    pmb = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
>      if (!pmb) {
>          phba->link_state = LPFC_HBA_ERROR;
>          return -ENOMEM;
> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
> index acb8358..bd6c3a3 100644
> --- a/drivers/scsi/osst.c
> +++ b/drivers/scsi/osst.c
> @@ -1482,7 +1482,7 @@ static int
> osst_read_back_buffer_and_rewrite(struct osst_tape * STp, struct osst
>      int            dbg              = debugging;
>  #endif
>  
> -    if ((buffer = (unsigned char *)vmalloc((nframes + 1) *
> OS_DATA_SIZE)) == NULL)
> +    if ((buffer = vmalloc((nframes + 1) * OS_DATA_SIZE)) == NULL)
>          return (-EIO);
>  
>      printk(KERN_INFO "%s:I: Reading back %d frames from drive buffer%s\n",
> @@ -2294,7 +2294,7 @@ static int osst_write_header(struct osst_tape *
> STp, struct osst_request ** aSRp
>      if (STp->raw) return 0;
>  
>      if (STp->header_cache == NULL) {
> -        if ((STp->header_cache = (os_header_t
> *)vmalloc(sizeof(os_header_t))) == NULL) {
> +        if ((STp->header_cache = vmalloc(sizeof(os_header_t))) == NULL) {
>              printk(KERN_ERR "%s:E: Failed to allocate header cache\n",
> name);
>              return (-ENOMEM);
>          }
> @@ -2482,7 +2482,7 @@ static int __osst_analyze_headers(struct osst_tape
> * STp, struct osst_request **
>                     name, ppos, update_frame_cntr);
>  #endif
>          if (STp->header_cache == NULL) {
> -            if ((STp->header_cache = (os_header_t
> *)vmalloc(sizeof(os_header_t))) == NULL) {
> +            if ((STp->header_cache = vmalloc(sizeof(os_header_t))) ==
> NULL) {
>                  printk(KERN_ERR "%s:E: Failed to allocate header
> cache\n", name);
>                  return 0;
>              }
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 213123b..379fa35 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1947,7 +1947,7 @@ static int resp_xdwriteread(struct scsi_cmnd *scp,
> unsigned long long lba,
>  
>      offset = 0;
>      for_each_sg(sdb->table.sgl, sg, sdb->table.nents, i) {
> -        kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
> +        kaddr = kmap_atomic(sg_page(sg), KM_USER0);
>          if (!kaddr)
>              goto out;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

