Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbZDIKK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbZDIKK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932829AbZDIKKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:10:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47561 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765924AbZDIKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:10:36 -0400
X-Sasl-enc: 6KcW9skB4AZGuY6X92x7Wl1FWBmVRcLXAKhXLl0R2ztx 1239271821
Message-ID: <49DDC98A.4090509@fastmail.fm>
Date: Thu, 09 Apr 2009 11:10:18 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 30/56] net: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080530w58a8e47fw351b900cb11cf17e@mail.gmail.com> <49DCAF42.1060709@fastmail.fm>
In-Reply-To: <49DCAF42.1060709@fastmail.fm>
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
> net: Remove void casts
>
> From: Jack Stone <jwjstone@fastmail.fm>
>
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>
>  drivers/net/arm/at91_ether.c           |    2 +-
>  drivers/net/cassini.c                  |    3 +--
>  drivers/net/gianfar.c                  |    2 +-
>  drivers/net/ibmveth.c                  |    7 +++----
>  drivers/net/irda/au1k_ir.c             |    3 +--
>  drivers/net/netxen/netxen_nic_init.c   |    6 ++----
>  drivers/net/skfp/ess.c                 |   20 ++++++++++----------
>  drivers/net/skfp/hwmtm.c               |    7 +++----
>  drivers/net/skfp/pmf.c                 |    4 ++--
>  drivers/net/skfp/smt.c                 |    3 +--
>  drivers/net/sungem.c                   |    3 +--
>  drivers/net/sunhme.c                   |    3 +--
>  drivers/net/via-velocity.c             |    2 +-
>  drivers/net/wireless/ipw2x00/ipw2100.c |    4 +---
>  14 files changed, 29 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
> index 442938d..c389b66 100644
> --- a/drivers/net/arm/at91_ether.c
> +++ b/drivers/net/arm/at91_ether.c
> @@ -992,7 +992,7 @@ static int __init at91ether_setup(unsigned long
> phy_type, unsigned short phy_add
>  
>      /* Allocate memory for DMA Receive descriptors */
>      lp = netdev_priv(dev);
> -    lp->dlist = (struct recv_desc_bufs *) dma_alloc_coherent(NULL,
> sizeof(struct recv_desc_bufs), (dma_addr_t *) &lp->dlist_phys, GFP_KERNEL);
> +    lp->dlist = dma_alloc_coherent(NULL, sizeof(struct recv_desc_bufs),
> (dma_addr_t *) &lp->dlist_phys, GFP_KERNEL);
>      if (lp->dlist == NULL) {
>          free_irq(dev->irq, dev);
>          free_netdev(dev);
> diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
> index f522276..620b783 100644
> --- a/drivers/net/cassini.c
> +++ b/drivers/net/cassini.c
> @@ -5162,8 +5162,7 @@ static int __devinit cas_init_one(struct pci_dev
> *pdev,
>          if (cas_saturn_firmware_init(cp))
>              goto err_out_iounmap;
>  
> -    cp->init_block = (struct cas_init_block *)
> -        pci_alloc_consistent(pdev, sizeof(struct cas_init_block),
> +    cp->init_block = pci_alloc_consistent(pdev, sizeof(struct
> cas_init_block),
>                       &cp->block_dvma);
>      if (!cp->init_block) {
>          dev_err(&pdev->dev, "Cannot allocate init block, aborting.\n");
> diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
> index 65f5587..7a8885e 100644
> --- a/drivers/net/gianfar.c
> +++ b/drivers/net/gianfar.c
> @@ -268,7 +268,7 @@ static int gfar_of_init(struct net_device *dev)
>      if (ph == NULL) {
>          u32 *fixed_link;
>  
> -        fixed_link = (u32 *)of_get_property(np, "fixed-link", NULL);
> +        fixed_link = of_get_property(np, "fixed-link", NULL);
>          if (!fixed_link) {
>              err = -ENODEV;
>              goto err_out;
> diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
> index 5c6315d..6ce7190 100644
> --- a/drivers/net/ibmveth.c
> +++ b/drivers/net/ibmveth.c
> @@ -1218,16 +1218,15 @@ static int __devinit ibmveth_probe(struct
> vio_dev *dev, const struct vio_device_
>      ibmveth_debug_printk_no_adapter("entering ibmveth_probe for UA 0x%x\n",
>                      dev->unit_address);
>  
> -    mac_addr_p = (unsigned char *) vio_get_attribute(dev,
> -                        VETH_MAC_ADDR, NULL);
> +    mac_addr_p = vio_get_attribute(dev, VETH_MAC_ADDR, NULL);
>      if(!mac_addr_p) {
>          printk(KERN_ERR "(%s:%3.3d) ERROR: Can't find VETH_MAC_ADDR "
>                  "attribute\n", __FILE__, __LINE__);
>          return 0;
>      }
>  
> -    mcastFilterSize_p = (unsigned int *) vio_get_attribute(dev,
> -                        VETH_MCAST_FILTER_SIZE, NULL);
> +    mcastFilterSize_p = vio_get_attribute(dev, VETH_MCAST_FILTER_SIZE,
> +               NULL);
>      if(!mcastFilterSize_p) {
>          printk(KERN_ERR "(%s:%3.3d) ERROR: Can't find "
>                  "VETH_MCAST_FILTER_SIZE attribute\n",
> diff --git a/drivers/net/irda/au1k_ir.c b/drivers/net/irda/au1k_ir.c
> index 9411640..b4a6ad8 100644
> --- a/drivers/net/irda/au1k_ir.c
> +++ b/drivers/net/irda/au1k_ir.c
> @@ -234,8 +234,7 @@ static int au1k_irda_net_init(struct net_device *dev)
>          goto out2;
>  
>      /* allocate the data buffers */
> -    aup->db[0].vaddr =
> -        (void *)dma_alloc(MAX_BUF_SIZE * 2*NUM_IR_DESC, &temp);
> +    aup->db[0].vaddr = dma_alloc(MAX_BUF_SIZE * 2*NUM_IR_DESC, &temp);
>      if (!aup->db[0].vaddr)
>          goto out3;
>  
> diff --git a/drivers/net/netxen/netxen_nic_init.c
> b/drivers/net/netxen/netxen_nic_init.c
> index 0759c35..9b56b37 100644
> --- a/drivers/net/netxen/netxen_nic_init.c
> +++ b/drivers/net/netxen/netxen_nic_init.c
> @@ -230,8 +230,7 @@ int netxen_alloc_sw_resources(struct netxen_adapter
> *adapter)
>      struct netxen_cmd_buffer *cmd_buf_arr;
>      struct net_device *netdev = adapter->netdev;
>  
> -    cmd_buf_arr =
> -        (struct netxen_cmd_buffer *)vmalloc(TX_BUFF_RINGSIZE(adapter));
> +    cmd_buf_arr = vmalloc(TX_BUFF_RINGSIZE(adapter));
>      if (cmd_buf_arr == NULL) {
>          printk(KERN_ERR "%s: Failed to allocate cmd buffer ring\n",
>                 netdev->name);
> @@ -277,8 +276,7 @@ int netxen_alloc_sw_resources(struct netxen_adapter
> *adapter)
>              break;
>  
>          }
> -        rds_ring->rx_buf_arr = (struct netxen_rx_buffer *)
> -            vmalloc(RCV_BUFF_RINGSIZE(rds_ring));
> +        rds_ring->rx_buf_arr = vmalloc(RCV_BUFF_RINGSIZE(rds_ring));
>          if (rds_ring->rx_buf_arr == NULL) {
>              printk(KERN_ERR "%s: Failed to allocate "
>                  "rx buffer ring %d\n",
> diff --git a/drivers/net/skfp/ess.c b/drivers/net/skfp/ess.c
> index a85efcf..5ec0413 100644
> --- a/drivers/net/skfp/ess.c
> +++ b/drivers/net/skfp/ess.c
> @@ -133,7 +133,7 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf
> *mb, struct smt_header *sm,
>      /*
>       * get the resource type
>       */
> -    if (!(p = (void *) sm_to_para(smc,sm,SMT_P0015))) {
> +    if (!(p = sm_to_para(smc,sm,SMT_P0015))) {
>          DB_ESS("ESS: RAF frame error, parameter type not found\n",0,0) ;
>          return(fs) ;
>      }
> @@ -142,7 +142,7 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf
> *mb, struct smt_header *sm,
>      /*
>       * get the pointer to the ESS command
>       */
> -    if (!(cmd = (struct smt_p_0016 *) sm_to_para(smc,sm,SMT_P0016))) {
> +    if (!(cmd = sm_to_para(smc,sm,SMT_P0016))) {
>          /*
>           * error in frame: para ESS command was not found
>           */
> @@ -177,7 +177,7 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf
> *mb, struct smt_header *sm,
>              if (!local || smc->mib.fddiESSPayload)
>                  return(fs) ;
>             
> -            p = (void *) sm_to_para(smc,sm,SMT_P0019)  ;
> +            p = sm_to_para(smc,sm,SMT_P0019)  ;
>              for (i = 0; i < 5; i++) {
>                  if (((struct smt_p_0019 *)p)->alloc_addr.a[i]) {
>                      return(fs) ;
> @@ -190,10 +190,10 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf
> *mb, struct smt_header *sm,
>               */
>              smc->ess.alloc_trans_id = sm->smt_tid ;
>              DB_ESS("ESS: save Alloc Req Trans ID %lx\n",sm->smt_tid,0);
> -            p = (void *) sm_to_para(smc,sm,SMT_P320F) ;
> +            p = sm_to_para(smc,sm,SMT_P320F) ;
>              ((struct smt_p_320f *)p)->mib_payload =
>                  smc->mib.a[PATH0].fddiPATHSbaPayload ;
> -            p = (void *) sm_to_para(smc,sm,SMT_P3210) ;
> +            p = sm_to_para(smc,sm,SMT_P3210) ;
>              ((struct smt_p_3210 *)p)->mib_overhead =
>                  smc->mib.a[PATH0].fddiPATHSbaOverhead ;
>              sm->smt_dest = smt_sba_da ;
> @@ -248,13 +248,13 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf
> *mb, struct smt_header *sm,
>          /*
>           * Extract message parameters
>           */
> -        p = (void *) sm_to_para(smc,sm,SMT_P320F) ;
> +        p = sm_to_para(smc,sm,SMT_P320F) ;
>                  if (!p) {
>                          printk(KERN_ERR "ESS: sm_to_para failed");
>                          return fs;
>                  }      
>          payload = ((struct smt_p_320f *)p)->mib_payload ;
> -        p = (void *) sm_to_para(smc,sm,SMT_P3210) ;
> +        p = sm_to_para(smc,sm,SMT_P3210) ;
>                  if (!p) {
>                          printk(KERN_ERR "ESS: sm_to_para failed");
>                          return fs;
> @@ -306,9 +306,9 @@ int ess_raf_received_pack(struct s_smc *smc, SMbuf
> *mb, struct smt_header *sm,
>          /*
>           * Extract message queue parameters
>           */
> -        p = (void *) sm_to_para(smc,sm,SMT_P320F) ;
> +        p = sm_to_para(smc,sm,SMT_P320F) ;
>          payload = ((struct smt_p_320f *)p)->mib_payload ;
> -        p = (void *) sm_to_para(smc,sm,SMT_P3210) ;
> +        p = sm_to_para(smc,sm,SMT_P3210) ;
>          overhead = ((struct smt_p_3210 *)p)->mib_overhead ;
>  
>          DB_ESSN(2,"ESS: Change Request from %s\n",
> @@ -529,7 +529,7 @@ static void ess_send_response(struct s_smc *smc,
> struct smt_header *sm,
>          /* set P1A */
>          chg->cat.para.p_type = SMT_P001A ;
>          chg->cat.para.p_len = sizeof(struct smt_p_001a) - PARA_LEN ;
> -        p = (void *) sm_to_para(smc,sm,SMT_P001A) ;
> +        p = sm_to_para(smc,sm,SMT_P001A) ;
>          chg->cat.category = ((struct smt_p_001a *)p)->category ;
>      }
>      dump_smt(smc,(struct smt_header *)chg,"RAF") ;
> diff --git a/drivers/net/skfp/hwmtm.c b/drivers/net/skfp/hwmtm.c
> index d322f1b..1b8d418 100644
> --- a/drivers/net/skfp/hwmtm.c
> +++ b/drivers/net/skfp/hwmtm.c
> @@ -268,8 +268,7 @@ int mac_drv_init(struct s_smc *smc)
>      /*
>       * get the required memory for the RxDs and TxDs
>       */
> -    if (!(smc->os.hwm.descr_p = (union s_fp_descr volatile *)
> -        mac_drv_get_desc_mem(smc,(u_int)
> +    if (!(smc->os.hwm.descr_p = mac_drv_get_desc_mem(smc,(u_int)
>          (RXD_TXD_COUNT+1)*sizeof(struct s_smt_fp_txd)))) {
>          return(1) ;    /* no space the hwm modul can't work */
>      }
> @@ -281,13 +280,13 @@ int mac_drv_init(struct s_smc *smc)
>      smc->os.hwm.mbuf_pool.mb_start=(SMbuf
> *)(&smc->os.hwm.mbuf_pool.mb[0]) ;
>  #else
>  #ifndef    COMMON_MB_POOL
> -    if (!(smc->os.hwm.mbuf_pool.mb_start = (SMbuf *) mac_drv_get_space(smc,
> +    if (!(smc->os.hwm.mbuf_pool.mb_start = mac_drv_get_space(smc,
>          MAX_MBUF*sizeof(SMbuf)))) {
>          return(1) ;    /* no space the hwm modul can't work */
>      }
>  #else
>      if (!mb_start) {
> -        if (!(mb_start = (SMbuf *) mac_drv_get_space(smc,
> +        if (!(mb_start = mac_drv_get_space(smc,
>              MAX_MBUF*sizeof(SMbuf)))) {
>              return(1) ;    /* no space the hwm modul can't work */
>          }
> diff --git a/drivers/net/skfp/pmf.c b/drivers/net/skfp/pmf.c
> index 79e665e..87613b7 100644
> --- a/drivers/net/skfp/pmf.c
> +++ b/drivers/net/skfp/pmf.c
> @@ -520,7 +520,7 @@ static int smt_authorize(struct s_smc *smc, struct
> smt_header *sm)
>      for (i = 0 ; i < 8 && !p[i] ; i++)
>          ;
>      if (i != 8) {
> -        pa = (struct smt_para *) sm_to_para(smc,sm,SMT_P_AUTHOR) ;
> +        pa = sm_to_para(smc,sm,SMT_P_AUTHOR) ;
>          if (!pa)
>              return(1) ;
>          if (pa->p_len != 8)
> @@ -536,7 +536,7 @@ static int smt_check_set_count(struct s_smc *smc,
> struct smt_header *sm)
>      struct smt_para    *pa ;
>      struct smt_p_setcount    *sc ;
>  
> -    pa = (struct smt_para *) sm_to_para(smc,sm,SMT_P1035) ;
> +    pa = sm_to_para(smc,sm,SMT_P1035) ;
>      if (pa) {
>          sc = (struct smt_p_setcount *) pa ;
>          if ((smc->mib.fddiSMTSetCount.count != sc->count) ||
> diff --git a/drivers/net/skfp/smt.c b/drivers/net/skfp/smt.c
> index 83d16fe..a4acc6c 100644
> --- a/drivers/net/skfp/smt.c
> +++ b/drivers/net/skfp/smt.c
> @@ -603,8 +603,7 @@ void smt_received_pack(struct s_smc *smc, SMbuf *mb,
> int fs)
>                      smt_echo_test(smc,0) ;
>                  }
>                  smc->sm.smt_tvu = smt_get_time() ;
> -                st = (struct smt_p_state *)
> -                    sm_to_para(smc,sm,SMT_P_STATE) ;
> +                st = sm_to_para(smc,sm,SMT_P_STATE) ;
>                  if (st) {
>                      smc->mib.m[MAC0].fddiMACUNDA_Flag =
>                      (st->st_dupl_addr & SMT_ST_MY_DUPA) ?
> diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
> index d2dfe0a..4de10ce 100644
> --- a/drivers/net/sungem.c
> +++ b/drivers/net/sungem.c
> @@ -3145,8 +3145,7 @@ static int __devinit gem_init_one(struct pci_dev
> *pdev,
>      /* It is guaranteed that the returned buffer will be at least
>       * PAGE_SIZE aligned.
>       */
> -    gp->init_block = (struct gem_init_block *)
> -        pci_alloc_consistent(pdev, sizeof(struct gem_init_block),
> +    gp->init_block = pci_alloc_consistent(pdev, sizeof(struct
> gem_init_block),
>                       &gp->gblock_dvma);
>      if (!gp->init_block) {
>          printk(KERN_ERR PFX "Cannot allocate init block, "
> diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
> index 4e9bd38..814ea78 100644
> --- a/drivers/net/sunhme.c
> +++ b/drivers/net/sunhme.c
> @@ -3091,8 +3091,7 @@ static int __devinit happy_meal_pci_probe(struct
> pci_dev *pdev,
>      hp->happy_bursts = DMA_BURSTBITS;
>  #endif
>  
> -    hp->happy_block = (struct hmeal_init_block *)
> -        dma_alloc_coherent(&pdev->dev, PAGE_SIZE, &hp->hblock_dvma,
> GFP_KERNEL);
> +    hp->happy_block = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
> &hp->hblock_dvma, GFP_KERNEL);
>  
>      err = -ENODEV;
>      if (!hp->happy_block) {
> diff --git a/drivers/net/via-velocity.c b/drivers/net/via-velocity.c
> index fb53ef8..a0b6386 100644
> --- a/drivers/net/via-velocity.c
> +++ b/drivers/net/via-velocity.c
> @@ -2136,7 +2136,7 @@ static int velocity_xmit(struct sk_buff *skb,
> struct net_device *dev)
>  
>              for (i = 0; i < nfrags; i++) {
>                  skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
> -                void *addr = (void *)page_address(frag->page) +
> frag->page_offset;
> +                void *addr = (void *) page_address(frag->page) +
> frag->page_offset;
>  
>                  tdinfo->skb_dma[i + 1] = pci_map_single(vptr->pdev,
> addr, frag->size, PCI_DMA_TODEVICE);
>  
> diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c
> b/drivers/net/wireless/ipw2x00/ipw2100.c
> index 97e5647..2e3d7c1 100644
> --- a/drivers/net/wireless/ipw2x00/ipw2100.c
> +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
> @@ -4301,9 +4301,7 @@ static int status_queue_allocate(struct
> ipw2100_priv *priv, int entries)
>      IPW_DEBUG_INFO("enter\n");
>  
>      q->size = entries * sizeof(struct ipw2100_status);
> -    q->drv =
> -        (struct ipw2100_status *)pci_alloc_consistent(priv->pci_dev,
> -                              q->size, &q->nic);
> +    q->drv = pci_alloc_consistent(priv->pci_dev, q->size, &q->nic);
>      if (!q->drv) {
>          IPW_DEBUG_WARNING("Can not allocate status queue.\n");
>          return -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

