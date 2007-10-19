Return-Path: <linux-kernel-owner+w=401wt.eu-S933710AbXJSNAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710AbXJSNAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 09:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbXJSNAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 09:00:30 -0400
Received: from mail-gw3.adaptec.com ([162.62.93.58]:47759 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXJSNA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 09:00:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 7/9] irq-remove: scsi driver trivial
Date: Fri, 19 Oct 2007 09:00:23 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>
In-Reply-To: <20071019075808.GH6407@havoc.gtf.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 7/9] irq-remove: scsi driver trivial
Thread-Index: AcgSJ8HCo0ayKeibSrGrKCn9hg6+sgAJ2GDQ
References: <20071019075443.GA6407@havoc.gtf.org> <20071019075808.GH6407@havoc.gtf.org>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Jeff Garzik" <jeff@garzik.org>, "LKML" <linux-kernel@vger.kernel.org>
Cc: "Eric Biederman" <ebiederm@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK with comment ...

This API changed in 2.4.23 switching to irqreturn_t, and 2.6.19 dropping
the struct_pt_regs argument, this is yet another API change in the same
function. The last one came with no clues to differentiate except kernel
version (for those of us that are required to produce updated
back-ported driver modules once this patch becomes a legacy). I am
*praying* that this API change is clean across 2.6.24 and add my voice
to all to ACK this clearly!

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Friday, October 19, 2007 3:58 AM
> To: LKML
> Cc: Eric Biederman
> Subject: [PATCH 7/9] irq-remove: scsi driver trivial
> 
> 
> commit fb66571c6fde956fb8bddacf11d64101f8df8bf8
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Oct 19 00:48:35 2007 -0400
> 
>     [IRQ ARG REMOVAL] trivial scsi driver updates
> 
>  drivers/scsi/3w-9xxx.c                |    2 +-
>  drivers/scsi/3w-xxxx.c                |    2 +-
>  drivers/scsi/53c700.c                 |    2 +-
>  drivers/scsi/53c700.h                 |    2 +-
>  drivers/scsi/BusLogic.c               |    2 +-
>  drivers/scsi/BusLogic.h               |    2 +-
>  drivers/scsi/NCR5380.h                |    2 +-
>  drivers/scsi/NCR53C9x.h               |    2 +-
>  drivers/scsi/NCR53c406a.c             |    4 ++--
>  drivers/scsi/NCR_D700.c               |    8 ++++----
>  drivers/scsi/NCR_Q720.c               |    5 ++---
>  drivers/scsi/a100u2w.c                |    2 +-
>  drivers/scsi/a2091.c                  |    2 +-
>  drivers/scsi/a3000.c                  |    2 +-
>  drivers/scsi/aacraid/rx.c             |    4 ++--
>  drivers/scsi/aacraid/sa.c             |    2 +-
>  drivers/scsi/advansys.c               |    2 +-
>  drivers/scsi/aha1740.c                |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_osm.c    |    2 +-
>  drivers/scsi/aic7xxx/aic79xx_osm.h    |    2 +-
>  drivers/scsi/aic7xxx/aic7xxx_osm.c    |    2 +-
>  drivers/scsi/aic7xxx/aic7xxx_osm.h    |    2 +-
>  drivers/scsi/aic7xxx_old.c            |    4 ++--
>  drivers/scsi/aic94xx/aic94xx_hwi.c    |    2 +-
>  drivers/scsi/aic94xx/aic94xx_hwi.h    |    2 +-
>  drivers/scsi/arcmsr/arcmsr_hba.c      |    2 +-
>  drivers/scsi/arm/acornscsi.c          |    7 +++----
>  drivers/scsi/arm/cumana_2.c           |    5 ++---
>  drivers/scsi/arm/eesox.c              |    5 ++---
>  drivers/scsi/arm/powertec.c           |    5 ++---
>  drivers/scsi/atari_NCR5380.c          |    4 ++--
>  drivers/scsi/atari_dma_emul.c         |    4 ++--
>  drivers/scsi/atari_scsi.c             |   10 +++++-----
>  drivers/scsi/atp870u.c                |    2 +-
>  drivers/scsi/dc395x.c                 |    2 +-
>  drivers/scsi/dec_esp.c                |   12 ++++++------
>  drivers/scsi/dpt_i2o.c                |    2 +-
>  drivers/scsi/dpti.h                   |    2 +-
>  drivers/scsi/eata_pio.c               |    6 +++---
>  drivers/scsi/fd_mcs.c                 |    4 ++--
>  drivers/scsi/fdomain.c                |    4 ++--
>  drivers/scsi/gvp11.c                  |    2 +-
>  drivers/scsi/hptiop.c                 |    2 +-
>  drivers/scsi/ibmmca.c                 |    2 +-
>  drivers/scsi/ibmvscsi/rpa_vscsi.c     |    3 +--
>  drivers/scsi/in2000.c                 |    2 +-
>  drivers/scsi/initio.c                 |    2 +-
>  drivers/scsi/ipr.c                    |    2 +-
>  drivers/scsi/ips.c                    |    4 ++--
>  drivers/scsi/lpfc/lpfc_crtn.h         |    2 +-
>  drivers/scsi/lpfc/lpfc_sli.c          |    2 +-
>  drivers/scsi/mac53c94.c               |    8 ++++----
>  drivers/scsi/mac_esp.c                |   10 +++++-----
>  drivers/scsi/megaraid.c               |    5 ++---
>  drivers/scsi/megaraid.h               |    4 ++--
>  drivers/scsi/megaraid/megaraid_mbox.c |    4 ++--
>  drivers/scsi/megaraid/megaraid_sas.c  |    2 +-
>  drivers/scsi/mesh.c                   |    2 +-
>  drivers/scsi/mvme147.c                |    2 +-
>  drivers/scsi/ncr53c8xx.c              |    2 +-
>  drivers/scsi/ncr53c8xx.h              |    2 +-
>  drivers/scsi/nsp32.c                  |    4 ++--
>  drivers/scsi/pcmcia/nsp_cs.c          |    2 +-
>  drivers/scsi/pcmcia/nsp_cs.h          |    2 +-
>  drivers/scsi/pcmcia/sym53c500_cs.c    |    2 +-
>  drivers/scsi/qla1280.c                |    2 +-
>  drivers/scsi/qla2xxx/qla_gbl.h        |    6 +++---
>  drivers/scsi/qla2xxx/qla_inline.h     |    2 +-
>  drivers/scsi/qla2xxx/qla_isr.c        |   11 +++++------
>  drivers/scsi/qla4xxx/ql4_glbl.h       |    2 +-
>  drivers/scsi/qla4xxx/ql4_isr.c        |    3 +--
>  drivers/scsi/qlogicfas408.c           |    2 +-
>  drivers/scsi/qlogicfas408.h           |    2 +-
>  drivers/scsi/qlogicpti.c              |    4 ++--
>  drivers/scsi/seagate.c                |   10 +++++-----
>  drivers/scsi/sgiwd93.c                |    2 +-
>  drivers/scsi/stex.c                   |    2 +-
>  drivers/scsi/sun3_NCR5380.c           |    2 +-
>  drivers/scsi/sun3_scsi.c              |    4 ++--
>  drivers/scsi/sun3_scsi_vme.c          |    4 ++--
>  drivers/scsi/sym53c8xx_2/sym_glue.c   |    2 +-
>  drivers/scsi/tmscsim.c                |    2 +-
>  drivers/scsi/ultrastor.c              |    4 ++--
>  drivers/scsi/wd7000.c                 |    2 +-
>  84 files changed, 137 insertions(+), 146 deletions(-)
> 
> fb66571c6fde956fb8bddacf11d64101f8df8bf8
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index fb14014..ec76865 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -1192,7 +1192,7 @@ out:
>  } /* End twa_initialize_device_extension() */
>  
>  /* This function is the interrupt service routine */
> -static irqreturn_t twa_interrupt(int irq, void *dev_instance)
> +static irqreturn_t twa_interrupt(void *dev_instance)
>  {
>  	int request_id, error = 0;
>  	u32 status_reg_value;
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index a64153b..2ec0c28 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -2021,7 +2021,7 @@ static int tw_scsi_queue(struct 
> scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
>  } /* End tw_scsi_queue() */
>  
>  /* This function is the interrupt service routine */
> -static irqreturn_t tw_interrupt(int irq, void *dev_instance) 
> +static irqreturn_t tw_interrupt(void *dev_instance) 
>  {
>  	int request_id;
>  	u32 status_reg_value;
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index 71ff3fb..43e4633 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -1479,7 +1479,7 @@ NCR_700_start_command(struct scsi_cmnd *SCp)
>  }
>  
>  irqreturn_t
> -NCR_700_intr(int irq, void *dev_id)
> +NCR_700_intr(void *dev_id)
>  {
>  	struct Scsi_Host *host = (struct Scsi_Host *)dev_id;
>  	struct NCR_700_Host_Parameters *hostdata =
> diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
> index e06bdfe..d601ab3 100644
> --- a/drivers/scsi/53c700.h
> +++ b/drivers/scsi/53c700.h
> @@ -57,7 +57,7 @@ struct NCR_700_Host_Parameters;
>  struct Scsi_Host *NCR_700_detect(struct scsi_host_template *,
>  		struct NCR_700_Host_Parameters *, struct device *);
>  int NCR_700_release(struct Scsi_Host *host);
> -irqreturn_t NCR_700_intr(int, void *);
> +irqreturn_t NCR_700_intr(void *);
>  
>  
>  enum NCR_700_Host_State {
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 49e1ffa..144b6e2 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2665,7 +2665,7 @@ static void 
> BusLogic_ProcessCompletedCCBs(struct BusLogic_HostAdapter *HostAdapt
>    Adapters.
>  */
>  
> -static irqreturn_t BusLogic_InterruptHandler(int 
> IRQ_Channel, void *DeviceIdentifier)
> +static irqreturn_t BusLogic_InterruptHandler(void *DeviceIdentifier)
>  {
>  	struct BusLogic_HostAdapter *HostAdapter = (struct 
> BusLogic_HostAdapter *) DeviceIdentifier;
>  	unsigned long ProcessorFlags;
> diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
> index bfbfb5c..3dfe9ce 100644
> --- a/drivers/scsi/BusLogic.h
> +++ b/drivers/scsi/BusLogic.h
> @@ -1341,7 +1341,7 @@ static int 
> BusLogic_BIOSDiskParameters(struct scsi_device *, struct block_device
>  static int BusLogic_ProcDirectoryInfo(struct Scsi_Host *, 
> char *, char **, off_t, int, int);
>  static int BusLogic_SlaveConfigure(struct scsi_device *);
>  static void BusLogic_QueueCompletedCCB(struct BusLogic_CCB *);
> -static irqreturn_t BusLogic_InterruptHandler(int, void *);
> +static irqreturn_t BusLogic_InterruptHandler(void *);
>  static int BusLogic_ResetHostAdapter(struct 
> BusLogic_HostAdapter *, bool HardReset);
>  static void BusLogic_Message(enum BusLogic_MessageLevel, 
> char *, struct BusLogic_HostAdapter *, ...);
>  static int __init BusLogic_Setup(char *);
> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index bdc468c..7d932ac 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -303,7 +303,7 @@ static int NCR5380_init(struct Scsi_Host 
> *instance, int flags);
>  static void NCR5380_exit(struct Scsi_Host *instance);
>  static void NCR5380_information_transfer(struct Scsi_Host *instance);
>  #ifndef DONT_USE_INTR
> -static irqreturn_t NCR5380_intr(int irq, void *dev_id);
> +static irqreturn_t NCR5380_intr(void *dev_id);
>  #endif
>  static void NCR5380_main(struct work_struct *work);
>  static void __maybe_unused NCR5380_print_options(struct 
> Scsi_Host *instance);
> diff --git a/drivers/scsi/NCR53C9x.h b/drivers/scsi/NCR53C9x.h
> index d85cb73..ff0fbd9 100644
> --- a/drivers/scsi/NCR53C9x.h
> +++ b/drivers/scsi/NCR53C9x.h
> @@ -656,7 +656,7 @@ extern struct NCR_ESP 
> *esp_allocate(struct scsi_host_template *, void *, int);
>  extern void esp_deallocate(struct NCR_ESP *);
>  extern void esp_release(void);
>  extern void esp_initialize(struct NCR_ESP *);
> -extern irqreturn_t esp_intr(int, void *);
> +extern irqreturn_t esp_intr(void *);
>  extern const char *esp_info(struct Scsi_Host *);
>  extern int esp_queue(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
>  extern int esp_abort(Scsi_Cmnd *);
> diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
> index 3168a17..3aef1da 100644
> --- a/drivers/scsi/NCR53c406a.c
> +++ b/drivers/scsi/NCR53c406a.c
> @@ -168,7 +168,7 @@ enum Phase {
>  
>  /* Static function prototypes */
>  static void NCR53c406a_intr(void *);
> -static irqreturn_t do_NCR53c406a_intr(int, void *);
> +static irqreturn_t do_NCR53c406a_intr(void *);
>  static void chip_init(void);
>  static void calc_port_addr(void);
>  #ifndef IRQ_LEV
> @@ -765,7 +765,7 @@ static int NCR53c406a_biosparm(struct 
> scsi_device *disk,
>  	return 0;
>  }
>  
> -static irqreturn_t do_NCR53c406a_intr(int unused, void *dev_id)
> +static irqreturn_t do_NCR53c406a_intr(void *dev_id)
>  {
>  	unsigned long flags;
>  	struct Scsi_Host *dev = dev_id;
> diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
> index 9e64b21..2afd135 100644
> --- a/drivers/scsi/NCR_D700.c
> +++ b/drivers/scsi/NCR_D700.c
> @@ -224,15 +224,15 @@ NCR_D700_probe_one(struct 
> NCR_D700_private *p, int siop, int irq,
>  	return ret;
>  }
>  
> -static int
> -NCR_D700_intr(int irq, void *data)
> +static irqreturn_t
> +NCR_D700_intr(void *data)
>  {
> -	struct NCR_D700_private *p = (struct NCR_D700_private *)data;
> +	struct NCR_D700_private *p = data;
>  	int i, found = 0;
>  
>  	for (i = 0; i < 2; i++)
>  		if (p->hosts[i] &&
> -		    NCR_700_intr(irq, p->hosts[i]) == IRQ_HANDLED)
> +		    NCR_700_intr(p->hosts[i]) == IRQ_HANDLED)
>  			found++;
>  
>  	return found ? IRQ_HANDLED : IRQ_NONE;
> diff --git a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
> index a8bbdc2..aa2bc5d 100644
> --- a/drivers/scsi/NCR_Q720.c
> +++ b/drivers/scsi/NCR_Q720.c
> @@ -54,7 +54,7 @@ static struct scsi_host_template NCR_Q720_tpnt = {
>  };
>  
>  static irqreturn_t
> -NCR_Q720_intr(int irq, void *data)
> +NCR_Q720_intr(void *data)
>  {
>  	struct NCR_Q720_private *p = (struct NCR_Q720_private *)data;
>  	__u8 sir = (readb(p->mem_base + 0x0d) & 0xf0) >> 4;
> @@ -65,10 +65,9 @@ NCR_Q720_intr(int irq, void *data)
>  	if(sir == 0xff)
>  		return IRQ_NONE;
>  
> -
>  	while((siop = ffz(sir)) < p->siops) {
>  		sir |= 1<<siop;
> -		ncr53c8xx_intr(irq, p->hosts[siop]);
> +		ncr53c8xx_intr(p->hosts[siop]);
>  	}
>  	return IRQ_HANDLED;
>  }
> diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
> index d3a6d15..954e6d6 100644
> --- a/drivers/scsi/a100u2w.c
> +++ b/drivers/scsi/a100u2w.c
> @@ -1045,7 +1045,7 @@ static void inia100_scb_handler(struct 
> orc_host *host, struct orc_scb *scb)
>   *	Entry point for IRQ handling. All the real work is performed
>   *	by orc_interrupt.
>   */
> -static irqreturn_t inia100_intr(int irqno, void *devid)
> +static irqreturn_t inia100_intr(void *devid)
>  {
>  	struct Scsi_Host *shost = (struct Scsi_Host *)devid;
>  	struct orc_host *host = (struct orc_host *)shost->hostdata;
> diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
> index b7c5385..d2db130 100644
> --- a/drivers/scsi/a2091.c
> +++ b/drivers/scsi/a2091.c
> @@ -23,7 +23,7 @@
>  #define DMA(ptr) ((a2091_scsiregs *)((ptr)->base))
>  #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
>  
> -static irqreturn_t a2091_intr (int irq, void *_instance)
> +static irqreturn_t a2091_intr (void *_instance)
>  {
>      unsigned long flags;
>      unsigned int status;
> diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
> index 796f1c4..863de5b 100644
> --- a/drivers/scsi/a3000.c
> +++ b/drivers/scsi/a3000.c
> @@ -25,7 +25,7 @@
>  
>  static struct Scsi_Host *a3000_host = NULL;
>  
> -static irqreturn_t a3000_intr (int irq, void *dummy)
> +static irqreturn_t a3000_intr (void *dummy)
>  {
>  	unsigned long flags;
>  	unsigned int status = DMA(a3000_host)->ISTR;
> diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
> index 73eef3d..d9c1441 100644
> --- a/drivers/scsi/aacraid/rx.c
> +++ b/drivers/scsi/aacraid/rx.c
> @@ -45,7 +45,7 @@
>  
>  #include "aacraid.h"
>  
> -static irqreturn_t aac_rx_intr_producer(int irq, void *dev_id)
> +static irqreturn_t aac_rx_intr_producer(void *dev_id)
>  {
>  	struct aac_dev *dev = dev_id;
>  	unsigned long bellbits;
> @@ -84,7 +84,7 @@ static irqreturn_t aac_rx_intr_producer(int 
> irq, void *dev_id)
>  	return IRQ_NONE;
>  }
>  
> -static irqreturn_t aac_rx_intr_message(int irq, void *dev_id)
> +static irqreturn_t aac_rx_intr_message(void *dev_id)
>  {
>  	struct aac_dev *dev = dev_id;
>  	u32 Index = rx_readl(dev, MUnit.OutboundQueue);
> diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
> index 85b91bc..7a236d1 100644
> --- a/drivers/scsi/aacraid/sa.c
> +++ b/drivers/scsi/aacraid/sa.c
> @@ -44,7 +44,7 @@
>  
>  #include "aacraid.h"
>  
> -static irqreturn_t aac_sa_intr(int irq, void *dev_id)
> +static irqreturn_t aac_sa_intr(void *dev_id)
>  {
>  	struct aac_dev *dev = dev_id;
>  	unsigned short intstat, mask;
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 9dd3952..f6167bc 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -9600,7 +9600,7 @@ advansys_biosparam(struct scsi_device 
> *sdev, struct block_device *bdev,
>   *
>   * 'dev_id' is a pointer to the interrupting adapter's Scsi_Host.
>   */
> -static irqreturn_t advansys_interrupt(int irq, void *dev_id)
> +static irqreturn_t advansys_interrupt(void *dev_id)
>  {
>  	struct Scsi_Host *shost = dev_id;
>  	struct asc_board *boardp = shost_priv(shost);
> diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
> index f6722fd..aaf6e99 100644
> --- a/drivers/scsi/aha1740.c
> +++ b/drivers/scsi/aha1740.c
> @@ -223,7 +223,7 @@ static int aha1740_test_port(unsigned int base)
>  }
>  
>  /* A "high" level interrupt handler */
> -static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
> +static irqreturn_t aha1740_intr_handle(void *dev_id)
>  {
>  	struct Scsi_Host *host = (struct Scsi_Host *) dev_id;
>          void (*my_done)(Scsi_Cmnd *);
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c 
> b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 42c0f14..0751639 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1526,7 +1526,7 @@ ahd_linux_run_command(struct ahd_softc 
> *ahd, struct ahd_linux_device *dev,
>   * SCSI controller interrupt handler.
>   */
>  irqreturn_t
> -ahd_linux_isr(int irq, void *dev_id)
> +ahd_linux_isr(void *dev_id)
>  {
>  	struct	ahd_softc *ahd;
>  	u_long	flags;
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h 
> b/drivers/scsi/aic7xxx/aic79xx_osm.h
> index 853998b..ee488a4 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.h
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
> @@ -852,7 +852,7 @@ int	ahd_platform_abort_scbs(struct 
> ahd_softc *ahd, int target,
>  				char channel, int lun, u_int tag,
>  				role_t role, uint32_t status);
>  irqreturn_t
> -	ahd_linux_isr(int irq, void *dev_id);
> +	ahd_linux_isr(void *dev_id);
>  void	ahd_done(struct ahd_softc*, struct scb*);
>  void	ahd_send_async(struct ahd_softc *, char channel,
>  		       u_int target, u_int lun, ac_code);
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c 
> b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index 7770bef..5bcf877 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1532,7 +1532,7 @@ ahc_linux_run_command(struct ahc_softc 
> *ahc, struct ahc_linux_device *dev,
>   * SCSI controller interrupt handler.
>   */
>  irqreturn_t
> -ahc_linux_isr(int irq, void *dev_id)
> +ahc_linux_isr(void *dev_id)
>  {
>  	struct	ahc_softc *ahc;
>  	u_long	flags;
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h 
> b/drivers/scsi/aic7xxx/aic7xxx_osm.h
> index b48dab4..e24d6c8 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
> @@ -820,7 +820,7 @@ int	ahc_platform_abort_scbs(struct 
> ahc_softc *ahc, int target,
>  				char channel, int lun, u_int tag,
>  				role_t role, uint32_t status);
>  irqreturn_t
> -	ahc_linux_isr(int irq, void *dev_id);
> +	ahc_linux_isr(void *dev_id);
>  void	ahc_platform_flushwork(struct ahc_softc *ahc);
>  void	ahc_done(struct ahc_softc*, struct scb*);
>  void	ahc_send_async(struct ahc_softc *, char channel,
> diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
> index 4025608..4c6ad7a 100644
> --- a/drivers/scsi/aic7xxx_old.c
> +++ b/drivers/scsi/aic7xxx_old.c
> @@ -6467,12 +6467,12 @@ aic7xxx_isr(void *dev_id)
>   *   anything like it, please inform the Gross Hack Police 
> immediately
>   
> *-F***********************************************************
> **************/
>  static irqreturn_t
> -do_aic7xxx_isr(int irq, void *dev_id)
> +do_aic7xxx_isr(void *dev_id)
>  {
>    unsigned long cpu_flags;
>    struct aic7xxx_host *p;
>    
> -  p = (struct aic7xxx_host *)dev_id;
> +  p = dev_id;
>    if(!p)
>      return IRQ_NONE;
>    spin_lock_irqsave(p->host->host_lock, cpu_flags);
> diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c 
> b/drivers/scsi/aic94xx/aic94xx_hwi.c
> index 0cd7eed..c2bf1ed 100644
> --- a/drivers/scsi/aic94xx/aic94xx_hwi.c
> +++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
> @@ -1017,7 +1017,7 @@ static inline void 
> asd_hst_pcix_isr(struct asd_ha_struct *asd_ha)
>   *
>   * The ISR processes done list entries and level 3 error handling.
>   */
> -irqreturn_t asd_hw_isr(int irq, void *dev_id)
> +irqreturn_t asd_hw_isr(void *dev_id)
>  {
>  	struct asd_ha_struct *asd_ha = dev_id;
>  	u32 chimint = asd_read_reg_dword(asd_ha, CHIMINT);
> diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h 
> b/drivers/scsi/aic94xx/aic94xx_hwi.h
> index 491e5d8..6bb6e07 100644
> --- a/drivers/scsi/aic94xx/aic94xx_hwi.h
> +++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
> @@ -372,7 +372,7 @@ static inline void 
> asd_ascb_free_list(struct asd_ascb *ascb_list)
>  /* ---------- Function declarations ---------- */
>  
>  int  asd_init_hw(struct asd_ha_struct *asd_ha);
> -irqreturn_t asd_hw_isr(int irq, void *dev_id);
> +irqreturn_t asd_hw_isr(void *dev_id);
>  
>  
>  struct asd_ascb *asd_ascb_alloc_list(struct asd_ha_struct
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c 
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> index f817775..60fbfa5 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -168,7 +168,7 @@ static struct pci_driver arcmsr_pci_driver = {
>  	#endif
>  };
>  
> -static irqreturn_t arcmsr_do_interrupt(int irq, void *dev_id)
> +static irqreturn_t arcmsr_do_interrupt(void *dev_id)
>  {
>  	irqreturn_t handle_state;
>  	struct AdapterControlBlock *acb = dev_id;
> diff --git a/drivers/scsi/arm/acornscsi.c 
> b/drivers/scsi/arm/acornscsi.c
> index eceacf6..419cd8b 100644
> --- a/drivers/scsi/arm/acornscsi.c
> +++ b/drivers/scsi/arm/acornscsi.c
> @@ -2460,13 +2460,12 @@ intr_ret_t acornscsi_sbicintr(AS_Host 
> *host, int in_irq)
>  }
>  
>  /*
> - * Prototype: void acornscsi_intr(int irq, void *dev_id)
> + * Prototype: void acornscsi_intr(void *dev_id)
>   * Purpose  : handle interrupts from Acorn SCSI card
> - * Params   : irq    - interrupt number
> - *	      dev_id - device specific data (AS_Host structure)
> + * Params   : dev_id - device specific data (AS_Host structure)
>   */
>  static irqreturn_t
> -acornscsi_intr(int irq, void *dev_id)
> +acornscsi_intr(void *dev_id)
>  {
>      AS_Host *host = (AS_Host *)dev_id;
>      intr_ret_t ret;
> diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
> index 68a6412..6740fb0 100644
> --- a/drivers/scsi/arm/cumana_2.c
> +++ b/drivers/scsi/arm/cumana_2.c
> @@ -134,11 +134,10 @@ cumanascsi_2_terminator_ctl(struct 
> Scsi_Host *host, int on_off)
>  
>  /* Prototype: void cumanascsi_2_intr(irq, *dev_id, *regs)
>   * Purpose  : handle interrupts from Cumana SCSI 2 card
> - * Params   : irq    - interrupt number
> - *	      dev_id - user-defined (Scsi_Host structure)
> + * Params   : dev_id - user-defined (Scsi_Host structure)
>   */
>  static irqreturn_t
> -cumanascsi_2_intr(int irq, void *dev_id)
> +cumanascsi_2_intr(void *dev_id)
>  {
>  	struct cumanascsi2_info *info = dev_id;
>  
> diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
> index bb2477b..8c8cbf0 100644
> --- a/drivers/scsi/arm/eesox.c
> +++ b/drivers/scsi/arm/eesox.c
> @@ -135,11 +135,10 @@ eesoxscsi_terminator_ctl(struct 
> Scsi_Host *host, int on_off)
>  
>  /* Prototype: void eesoxscsi_intr(irq, *dev_id, *regs)
>   * Purpose  : handle interrupts from EESOX SCSI card
> - * Params   : irq    - interrupt number
> - *	      dev_id - user-defined (Scsi_Host structure)
> + * Params   : dev_id - user-defined (Scsi_Host structure)
>   */
>  static irqreturn_t
> -eesoxscsi_intr(int irq, void *dev_id)
> +eesoxscsi_intr(void *dev_id)
>  {
>  	struct eesoxscsi_info *info = dev_id;
>  
> diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
> index d9a546d..247f904 100644
> --- a/drivers/scsi/arm/powertec.c
> +++ b/drivers/scsi/arm/powertec.c
> @@ -109,10 +109,9 @@ powertecscsi_terminator_ctl(struct 
> Scsi_Host *host, int on_off)
>  
>  /* Prototype: void powertecscsi_intr(irq, *dev_id, *regs)
>   * Purpose  : handle interrupts from Powertec SCSI card
> - * Params   : irq    - interrupt number
> - *	      dev_id - user-defined (Scsi_Host structure)
> + * Params   : dev_id - user-defined (Scsi_Host structure)
>   */
> -static irqreturn_t powertecscsi_intr(int irq, void *dev_id)
> +static irqreturn_t powertecscsi_intr(void *dev_id)
>  {
>  	struct powertec_info *info = dev_id;
>  
> diff --git a/drivers/scsi/atari_NCR5380.c 
> b/drivers/scsi/atari_NCR5380.c
> index 52d0b87..e1a8b0f 100644
> --- a/drivers/scsi/atari_NCR5380.c
> +++ b/drivers/scsi/atari_NCR5380.c
> @@ -1271,11 +1271,11 @@ static void 
> NCR5380_dma_complete(struct Scsi_Host *instance)
>   *	from the disconnected queue, and restarting NCR5380_main()
>   *	as required.
>   *
> - * Inputs : int irq, irq that caused this interrupt.
> + * Inputs : void *dev_id: instance structure
>   *
>   */
>  
> -static irqreturn_t NCR5380_intr(int irq, void *dev_id)
> +static irqreturn_t NCR5380_intr(void *dev_id)
>  {
>  	struct Scsi_Host *instance = first_instance;
>  	int done = 1, handled = 0;
> diff --git a/drivers/scsi/atari_dma_emul.c 
> b/drivers/scsi/atari_dma_emul.c
> index cdc710e..587f051 100644
> --- a/drivers/scsi/atari_dma_emul.c
> +++ b/drivers/scsi/atari_dma_emul.c
> @@ -110,7 +110,7 @@ static inline void 
> set_restdata_reg(unsigned char *cur_addr)
>  }
>  
>  /*
> - * void hades_dma_emulator(int irq, void *dummy)
> + * void hades_dma_emulator(void *dummy)
>   * 
>   * This code emulates TT SCSI DMA on the Hades.
>   * 
> @@ -140,7 +140,7 @@ static inline void 
> set_restdata_reg(unsigned char *cur_addr)
>   *    increased with one.
>   */
>  
> -static irqreturn_t hades_dma_emulator(int irq, void *dummy)
> +static irqreturn_t hades_dma_emulator(void *dummy)
>  {
>  	unsigned long dma_base;
>  	register unsigned long dma_cnt asm ("d3");
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index 6f8403b..7cfebd2 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -193,8 +193,8 @@ static int falcon_classify_cmd(Scsi_Cmnd *cmd);
>  static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
>  					Scsi_Cmnd *cmd, int write_flag);
>  #endif
> -static irqreturn_t scsi_tt_intr(int irq, void *dummy);
> -static irqreturn_t scsi_falcon_intr(int irq, void *dummy);
> +static irqreturn_t scsi_tt_intr(void *dummy);
> +static irqreturn_t scsi_falcon_intr(void *dummy);
>  static void falcon_release_lock_if_possible(struct 
> NCR5380_hostdata *hostdata);
>  static void falcon_get_lock(void);
>  #ifdef CONFIG_ATARI_SCSI_RESET_BOOT
> @@ -282,7 +282,7 @@ static int 
> scsi_dma_is_ignored_buserr(unsigned char dma_stat)
>   * end-of-DMA, both SCSI ints are triggered simultaneously, 
> so the NCR int has
>   * to clear the DMA int pending bit before it allows other 
> level 6 interrupts.
>   */
> -static void scsi_dma_buserr(int irq, void *dummy)
> +static void scsi_dma_buserr(void *dummy)
>  {
>  	unsigned char dma_stat = tt_scsi_dma.dma_ctrl;
>  
> @@ -310,7 +310,7 @@ static void scsi_dma_buserr(int irq, void *dummy)
>  #endif
>  
>  
> -static irqreturn_t scsi_tt_intr(int irq, void *dummy)
> +static irqreturn_t scsi_tt_intr(void *dummy)
>  {
>  #ifdef REAL_DMA
>  	int dma_stat;
> @@ -403,7 +403,7 @@ static irqreturn_t scsi_tt_intr(int irq, 
> void *dummy)
>  }
>  
>  
> -static irqreturn_t scsi_falcon_intr(int irq, void *dummy)
> +static irqreturn_t scsi_falcon_intr(void *dummy)
>  {
>  #ifdef REAL_DMA
>  	int dma_stat;
> diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
> index fec58cc..5a6ada2 100644
> --- a/drivers/scsi/atp870u.c
> +++ b/drivers/scsi/atp870u.c
> @@ -44,7 +44,7 @@ static void send_s870(struct atp_unit 
> *dev,unsigned char c);
>  static void is885(struct atp_unit *dev, unsigned int 
> wkport,unsigned char c);
>  static void tscam_885(void);
>  
> -static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
> +static irqreturn_t atp870u_intr_handle(void *dev_id)
>  {
>  	unsigned long flags;
>  	unsigned short int tmpcip, id;
> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index fd42d47..d300a5f 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -1800,7 +1800,7 @@ static void 
> dc395x_handle_interrupt(struct AdapterCtlBlk *acb,
>  }
>  
>  
> -static irqreturn_t dc395x_interrupt(int irq, void *dev_id)
> +static irqreturn_t dc395x_interrupt(void *dev_id)
>  {
>  	struct AdapterCtlBlk *acb = dev_id;
>  	u16 scsi_status;
> diff --git a/drivers/scsi/dec_esp.c b/drivers/scsi/dec_esp.c
> index d42ad66..9af7fdd 100644
> --- a/drivers/scsi/dec_esp.c
> +++ b/drivers/scsi/dec_esp.c
> @@ -94,9 +94,9 @@ volatile unsigned char pmaz_cmd_buffer[16];
>  				 * via PIO.
>  				 */
>  
> -static irqreturn_t scsi_dma_merr_int(int, void *);
> -static irqreturn_t scsi_dma_err_int(int, void *);
> -static irqreturn_t scsi_dma_int(int, void *);
> +static irqreturn_t scsi_dma_merr_int(void *);
> +static irqreturn_t scsi_dma_err_int(void *);
> +static irqreturn_t scsi_dma_int(void *);
>  
>  static struct scsi_host_template dec_esp_template = {
>  	.module			= THIS_MODULE,
> @@ -352,7 +352,7 @@ static void __exit dec_esp_remove(struct 
> device *dev)
>  
>  
>  
> /*************************************************************
>  DMA Functions */
> -static irqreturn_t scsi_dma_merr_int(int irq, void *dev_id)
> +static irqreturn_t scsi_dma_merr_int(void *dev_id)
>  {
>  	printk("Got unexpected SCSI DMA Interrupt! < ");
>  	printk("SCSI_DMA_MEMRDERR ");
> @@ -361,14 +361,14 @@ static irqreturn_t 
> scsi_dma_merr_int(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static irqreturn_t scsi_dma_err_int(int irq, void *dev_id)
> +static irqreturn_t scsi_dma_err_int(void *dev_id)
>  {
>  	/* empty */
>  
>  	return IRQ_HANDLED;
>  }
>  
> -static irqreturn_t scsi_dma_int(int irq, void *dev_id)
> +static irqreturn_t scsi_dma_int(void *dev_id)
>  {
>  	u32 scsi_next_ptr;
>  
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 8258506..f87b897 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -1966,7 +1966,7 @@ static int adpt_ioctl(struct inode 
> *inode, struct file *file, uint cmd,
>  }
>  
>  
> -static irqreturn_t adpt_isr(int irq, void *dev_id)
> +static irqreturn_t adpt_isr(void *dev_id)
>  {
>  	struct scsi_cmnd* cmd;
>  	adpt_hba* pHba = dev_id;
> diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
> index 0892f6c..64be1df 100644
> --- a/drivers/scsi/dpti.h
> +++ b/drivers/scsi/dpti.h
> @@ -259,7 +259,7 @@ struct sg_simple_element {
>  static void adpt_i2o_sys_shutdown(void);
>  static int adpt_init(void);
>  static int adpt_i2o_build_sys_table(void);
> -static irqreturn_t adpt_isr(int irq, void *dev_id);
> +static irqreturn_t adpt_isr(void *dev_id);
>  #ifdef REBOOT_NOTIFIER
>  static int adpt_reboot_event(struct notifier_block *n, ulong 
> code, void *p);
>  #endif
> diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
> index 96180bb..17bcdfe 100644
> --- a/drivers/scsi/eata_pio.c
> +++ b/drivers/scsi/eata_pio.c
> @@ -178,9 +178,9 @@ static void IncStat(struct scsi_pointer 
> *SCp, unsigned int Increment)
>  	}
>  }
>  
> -static irqreturn_t eata_pio_int_handler(int irq, void *dev_id);
> +static irqreturn_t eata_pio_int_handler(void *dev_id);
>  
> -static irqreturn_t do_eata_pio_int_handler(int irq, void *dev_id)
> +static irqreturn_t do_eata_pio_int_handler(void *dev_id)
>  {
>  	unsigned long flags;
>  	struct Scsi_Host *dev = dev_id;
> @@ -192,7 +192,7 @@ static irqreturn_t 
> do_eata_pio_int_handler(int irq, void *dev_id)
>  	return ret;
>  }
>  
> -static irqreturn_t eata_pio_int_handler(int irq, void *dev_id)
> +static irqreturn_t eata_pio_int_handler(void *dev_id)
>  {
>  	unsigned int eata_stat = 0xfffff;
>  	struct scsi_cmnd *cmd;
> diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
> index 668569e..254827f 100644
> --- a/drivers/scsi/fd_mcs.c
> +++ b/drivers/scsi/fd_mcs.c
> @@ -281,7 +281,7 @@ static struct fd_mcs_adapters_struct 
> fd_mcs_adapters[] = {
>  
>  #define FD_BRDS ARRAY_SIZE(fd_mcs_adapters)
>  
> -static irqreturn_t fd_mcs_intr(int irq, void *dev_id);
> +static irqreturn_t fd_mcs_intr(void *dev_id);
>  
>  static unsigned long addresses[] = { 0xc8000, 0xca000, 
> 0xce000, 0xde000 };
>  static unsigned short ports[] = { 0x140, 0x150, 0x160, 0x170 };
> @@ -619,7 +619,7 @@ static void my_done(struct Scsi_Host 
> *shpnt, int error)
>  }
>  
>  /* only my_done needs to be protected  */
> -static irqreturn_t fd_mcs_intr(int irq, void *dev_id)
> +static irqreturn_t fd_mcs_intr(void *dev_id)
>  {
>  	unsigned long flags;
>  	int status;
> diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
> index 5d282e6..fc03f07 100644
> --- a/drivers/scsi/fdomain.c
> +++ b/drivers/scsi/fdomain.c
> @@ -406,7 +406,7 @@ static volatile int      in_interrupt_flag;
>  static int               FIFO_Size = 0x2000; /* 8k FIFO for
>  						pre-tmc18c30 chips */
>  
> -static irqreturn_t       do_fdomain_16x0_intr( int irq, void 
> *dev_id );
> +static irqreturn_t       do_fdomain_16x0_intr( void *dev_id );
>  /* Allow insmod parameters to be like LILO parameters.  For example:
>     insmod fdomain fdomain=0x140,11 */
>  static char * fdomain = NULL;
> @@ -1123,7 +1123,7 @@ static void my_done(int error)
>  #endif
>  }
>  
> -static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
> +static irqreturn_t do_fdomain_16x0_intr(void *dev_id)
>  {
>     unsigned long flags;
>     int      status;
> diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
> index 37741e9..74cab0b 100644
> --- a/drivers/scsi/gvp11.c
> +++ b/drivers/scsi/gvp11.c
> @@ -23,7 +23,7 @@
>  #define DMA(ptr) ((gvp11_scsiregs *)((ptr)->base))
>  #define HDATA(ptr) ((struct WD33C93_hostdata *)((ptr)->hostdata))
>  
> -static irqreturn_t gvp11_intr (int irq, void *_instance)
> +static irqreturn_t gvp11_intr (void *_instance)
>  {
>      unsigned long flags;
>      unsigned int status;
> diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
> index 8515054..9205ebb 100644
> --- a/drivers/scsi/hptiop.c
> +++ b/drivers/scsi/hptiop.c
> @@ -429,7 +429,7 @@ void hptiop_iop_request_callback(struct 
> hptiop_hba *hba, u32 tag)
>  	writel(tag, &hba->iop->outbound_queue);
>  }
>  
> -static irqreturn_t hptiop_intr(int irq, void *dev_id)
> +static irqreturn_t hptiop_intr(void *dev_id)
>  {
>  	struct hptiop_hba  *hba = dev_id;
>  	int  handled;
> diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
> index 714e627..683fe1d 100644
> --- a/drivers/scsi/ibmmca.c
> +++ b/drivers/scsi/ibmmca.c
> @@ -497,7 +497,7 @@ static int option_setup(char *);
>  static int ldn_access_load(struct Scsi_Host *, int);
>  static int ldn_access_total_read_write(struct Scsi_Host *);
>  
> -static irqreturn_t interrupt_handler(int irq, void *dev_id)
> +static irqreturn_t interrupt_handler(void *dev_id)
>  {
>  	unsigned int intr_reg;
>  	unsigned int cmd_result;
> diff --git a/drivers/scsi/ibmvscsi/rpa_vscsi.c 
> b/drivers/scsi/ibmvscsi/rpa_vscsi.c
> index 1821461..8003fb1 100644
> --- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
> +++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c
> @@ -43,13 +43,12 @@ static unsigned int partition_number = -1;
>   */
>  /**
>   * rpavscsi_handle_event: - Interrupt handler for crq events
> - * @irq:	number of irq to handle, not used
>   * @dev_instance: ibmvscsi_host_data of host that received interrupt
>   *
>   * Disables interrupts and schedules srp_task
>   * Always returns IRQ_HANDLED
>   */
> -static irqreturn_t rpavscsi_handle_event(int irq, void *dev_instance)
> +static irqreturn_t rpavscsi_handle_event(void *dev_instance)
>  {
>  	struct ibmvscsi_host_data *hostdata =
>  	    (struct ibmvscsi_host_data *)dev_instance;
> diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
> index ab7cbf3..c6754d1 100644
> --- a/drivers/scsi/in2000.c
> +++ b/drivers/scsi/in2000.c
> @@ -829,7 +829,7 @@ static void transfer_bytes(Scsi_Cmnd * 
> cmd, int data_in_dir)
>   * but it _does_ need to be able to compile and run in an 
> SMP kernel.)
>   */
>  
> -static irqreturn_t in2000_intr(int irqnum, void *dev_id)
> +static irqreturn_t in2000_intr(void *dev_id)
>  {
>  	struct Scsi_Host *instance = dev_id;
>  	struct IN2000_hostdata *hostdata;
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 22d40fd..87c7537 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -2532,7 +2532,7 @@ static int initio_wait_done_disc(struct 
> initio_host * host)
>   *	code under the lock.
>   */
>  
> -static irqreturn_t i91u_intr(int irqno, void *dev_id)
> +static irqreturn_t i91u_intr(void *dev_id)
>  {
>  	struct Scsi_Host *dev = dev_id;
>  	unsigned long flags;
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index c316a0b..78a44ab 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -4178,7 +4178,7 @@ static irqreturn_t 
> ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg,
>   * Return value:
>   * 	IRQ_NONE / IRQ_HANDLED
>   **/
> -static irqreturn_t ipr_isr(int irq, void *devp)
> +static irqreturn_t ipr_isr(void *devp)
>  {
>  	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)devp;
>  	unsigned long lock_flags = 0;
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index edaac27..0f1edb9 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -235,7 +235,7 @@ static int ips_eh_abort(struct scsi_cmnd *);
>  static int ips_eh_reset(struct scsi_cmnd *);
>  static int ips_queue(struct scsi_cmnd *, void (*)(struct 
> scsi_cmnd *));
>  static const char *ips_info(struct Scsi_Host *);
> -static irqreturn_t do_ipsintr(int, void *);
> +static irqreturn_t do_ipsintr(void *);
>  static int ips_hainit(ips_ha_t *);
>  static int ips_map_status(ips_ha_t *, ips_scb_t *, ips_stat_t *);
>  static int ips_send_wait(ips_ha_t *, ips_scb_t *, int, int);
> @@ -1231,7 +1231,7 @@ ips_slave_configure(struct scsi_device * SDptr)
>  /*                                                           
>                */
>  
> /*************************************************************
> ***************/
>  static irqreturn_t
> -do_ipsintr(int irq, void *dev_id)
> +do_ipsintr(void *dev_id)
>  {
>  	ips_ha_t *ha;
>  	struct Scsi_Host *host;
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h 
> b/drivers/scsi/lpfc/lpfc_crtn.h
> index a599e15..0771fbc 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -152,7 +152,7 @@ int lpfc_sli_queue_setup(struct lpfc_hba *);
>  
>  void lpfc_handle_eratt(struct lpfc_hba *);
>  void lpfc_handle_latt(struct lpfc_hba *);
> -irqreturn_t lpfc_intr_handler(int, void *);
> +irqreturn_t lpfc_intr_handler(void *);
>  
>  void lpfc_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *);
>  void lpfc_config_ring(struct lpfc_hba *, int, LPFC_MBOXQ_t *);
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c 
> b/drivers/scsi/lpfc/lpfc_sli.c
> index ce348c5..f1e20e7 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -3765,7 +3765,7 @@ lpfc_sli_flush_mbox_queue(struct 
> lpfc_hba * phba)
>  }
>  
>  irqreturn_t
> -lpfc_intr_handler(int irq, void *dev_id)
> +lpfc_intr_handler(void *dev_id)
>  {
>  	struct lpfc_hba  *phba;
>  	uint32_t ha_copy;
> diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
> index a035001..db29fc0 100644
> --- a/drivers/scsi/mac53c94.c
> +++ b/drivers/scsi/mac53c94.c
> @@ -60,8 +60,8 @@ struct fsc_state {
>  
>  static void mac53c94_init(struct fsc_state *);
>  static void mac53c94_start(struct fsc_state *);
> -static void mac53c94_interrupt(int, void *);
> -static irqreturn_t do_mac53c94_interrupt(int, void *);
> +static void mac53c94_interrupt(void *);
> +static irqreturn_t do_mac53c94_interrupt(void *);
>  static void cmd_done(struct fsc_state *, int result);
>  static void set_dma_cmds(struct fsc_state *, struct scsi_cmnd *);
>  
> @@ -176,7 +176,7 @@ static void mac53c94_start(struct 
> fsc_state *state)
>  	set_dma_cmds(state, cmd);
>  }
>  
> -static irqreturn_t do_mac53c94_interrupt(int irq, void *dev_id)
> +static irqreturn_t do_mac53c94_interrupt(void *dev_id)
>  {
>  	unsigned long flags;
>  	struct Scsi_Host *dev = ((struct fsc_state *) 
> dev_id)->current_req->device->host;
> @@ -187,7 +187,7 @@ static irqreturn_t 
> do_mac53c94_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> -static void mac53c94_interrupt(int irq, void *dev_id)
> +static void mac53c94_interrupt(void *dev_id)
>  {
>  	struct fsc_state *state = (struct fsc_state *) dev_id;
>  	struct mac53c94_regs __iomem *regs = state->regs;
> diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
> index bcb4902..fc03a88 100644
> --- a/drivers/scsi/mac_esp.c
> +++ b/drivers/scsi/mac_esp.c
> @@ -44,7 +44,7 @@
>  /* #define DEBUG_MAC_ESP */
>  
>  extern void esp_handle(struct NCR_ESP *esp);
> -extern void mac_esp_intr(int irq, void *dev_id);
> +extern void mac_esp_intr(void *dev_id);
>  
>  static int  dma_bytes_sent(struct NCR_ESP * esp, int fifo_count);
>  static int  dma_can_transfer(struct NCR_ESP * esp, Scsi_Cmnd *sp);
> @@ -88,7 +88,7 @@ static int setup_hostid = -1;
>   * set up properly!
>   */
>  
> -void mac_esp_intr(int irq, void *dev_id)
> +void mac_esp_intr(void *dev_id)
>  {
>  	struct NCR_ESP *esp = (struct NCR_ESP *) dev_id;
>  	int irq_p = 0;
> @@ -122,7 +122,7 @@ void mac_esp_intr(int irq, void *dev_id)
>   * acknowledge on the various machines
>   */
>  
> -void scsi_esp_polled(int irq, void *dev_id)
> +void scsi_esp_polled(void *dev_id)
>  {
>  	if (esp_initialized == 0)
>  		return;
> @@ -130,7 +130,7 @@ void scsi_esp_polled(int irq, void *dev_id)
>  	mac_esp_intr(irq, dev_id);
>  }
>  
> -void fake_intr(int irq, void *dev_id)
> +void fake_intr(void *dev_id)
>  {
>  #ifdef DEBUG_MAC_ESP
>  	printk("mac_esp: got irq\n");
> @@ -139,7 +139,7 @@ void fake_intr(int irq, void *dev_id)
>  	mac_esp_intr(irq, dev_id);
>  }
>  
> -irqreturn_t fake_drq(int irq, void *dev_id)
> +irqreturn_t fake_drq(void *dev_id)
>  {
>  	printk("mac_esp: got drq\n");
>  	return IRQ_HANDLED;
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 10d1aff..ff6d232 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -1244,7 +1244,6 @@ bug_blocked_mailbox:
>  
>  /**
>   * megaraid_isr_iomapped()
> - * @irq - irq
>   * @devp - pointer to our soft state
>   *
>   * Interrupt service routine for io-mapped controllers.
> @@ -1252,7 +1251,7 @@ bug_blocked_mailbox:
>   * and service the completed commands.
>   */
>  static irqreturn_t
> -megaraid_isr_iomapped(int irq, void *devp)
> +megaraid_isr_iomapped(void *devp)
>  {
>  	adapter_t	*adapter = devp;
>  	unsigned long	flags;
> @@ -1328,7 +1327,7 @@ megaraid_isr_iomapped(int irq, void *devp)
>   * and service the completed commands.
>   */
>  static irqreturn_t
> -megaraid_isr_memmapped(int irq, void *devp)
> +megaraid_isr_memmapped(void *devp)
>  {
>  	adapter_t	*adapter = devp;
>  	unsigned long	flags;
> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> index ee70bd4..a04f446 100644
> --- a/drivers/scsi/megaraid.h
> +++ b/drivers/scsi/megaraid.h
> @@ -992,8 +992,8 @@ static scb_t * mega_build_cmd(adapter_t 
> *, Scsi_Cmnd *, int *);
>  static void __mega_runpendq(adapter_t *);
>  static int issue_scb_block(adapter_t *, u_char *);
>  
> -static irqreturn_t megaraid_isr_memmapped(int, void *);
> -static irqreturn_t megaraid_isr_iomapped(int, void *);
> +static irqreturn_t megaraid_isr_memmapped(void *);
> +static irqreturn_t megaraid_isr_iomapped(void *);
>  
>  static void mega_free_scb(adapter_t *, scb_t *);
>  
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c 
> b/drivers/scsi/megaraid/megaraid_mbox.c
> index e4e4c6a..f179000 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -121,7 +121,7 @@ static void 
> megaraid_mbox_prepare_pthru(adapter_t *, scb_t *,
>  static void megaraid_mbox_prepare_epthru(adapter_t *, scb_t *,
>  		struct scsi_cmnd *);
>  
> -static irqreturn_t megaraid_isr(int, void *);
> +static irqreturn_t megaraid_isr(void *);
>  
>  static void megaraid_mbox_dpc(unsigned long);
>  
> @@ -2188,7 +2188,7 @@ megaraid_ack_sequence(adapter_t *adapter)
>   * Interrupt service routine for memory-mapped mailbox controllers.
>   */
>  static irqreturn_t
> -megaraid_isr(int irq, void *devp)
> +megaraid_isr(void *devp)
>  {
>  	adapter_t	*adapter = devp;
>  	int		handled;
> diff --git a/drivers/scsi/megaraid/megaraid_sas.c 
> b/drivers/scsi/megaraid/megaraid_sas.c
> index e3c5c52..b76847c 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.c
> +++ b/drivers/scsi/megaraid/megaraid_sas.c
> @@ -1316,7 +1316,7 @@ out_done:
>  /**
>   * megasas_isr - isr entry point
>   */
> -static irqreturn_t megasas_isr(int irq, void *devp)
> +static irqreturn_t megasas_isr(void *devp)
>  {
>  	return megasas_deplete_reply_queue((struct 
> megasas_instance *)devp,
>  					   DID_OK);
> diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
> index 7470ff3..b1c5f46 100644
> --- a/drivers/scsi/mesh.c
> +++ b/drivers/scsi/mesh.c
> @@ -1018,7 +1018,7 @@ static void handle_reset(struct mesh_state *ms)
>  	out_8(&mr->sequence, SEQ_ENBRESEL);
>  }
>  
> -static irqreturn_t do_mesh_interrupt(int irq, void *dev_id)
> +static irqreturn_t do_mesh_interrupt(void *dev_id)
>  {
>  	unsigned long flags;
>  	struct mesh_state *ms = dev_id;
> diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
> index be41aad..4f99eb0 100644
> --- a/drivers/scsi/mvme147.c
> +++ b/drivers/scsi/mvme147.c
> @@ -19,7 +19,7 @@
>  
>  static struct Scsi_Host *mvme147_host = NULL;
>  
> -static irqreturn_t mvme147_intr (int irq, void *dummy)
> +static irqreturn_t mvme147_intr (void *dummy)
>  {
>      if (irq == MVME147_IRQ_SCSI_PORT)
>  	wd33c93_intr (mvme147_host);
> diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
> index 016c462..59fef30 100644
> --- a/drivers/scsi/ncr53c8xx.c
> +++ b/drivers/scsi/ncr53c8xx.c
> @@ -8066,7 +8066,7 @@ printk("ncr53c8xx : command 
> successfully queued\n");
>       return sts;
>  }
>  
> -irqreturn_t ncr53c8xx_intr(int irq, void *dev_id)
> +irqreturn_t ncr53c8xx_intr(void *dev_id)
>  {
>       unsigned long flags;
>       struct Scsi_Host *shost = (struct Scsi_Host *)dev_id;
> diff --git a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
> index 0e008da..0eaee1b 100644
> --- a/drivers/scsi/ncr53c8xx.h
> +++ b/drivers/scsi/ncr53c8xx.h
> @@ -1322,7 +1322,7 @@ struct ncr_device {
>  
>  extern struct Scsi_Host *ncr_attach(struct 
> scsi_host_template *tpnt, int unit, struct ncr_device *device);
>  extern void ncr53c8xx_release(struct Scsi_Host *host);
> -irqreturn_t ncr53c8xx_intr(int irq, void *dev_id);
> +irqreturn_t ncr53c8xx_intr(void *dev_id);
>  extern int ncr53c8xx_init(void);
>  extern void ncr53c8xx_exit(void);
>  
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 28161dc..c50373b 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -243,7 +243,7 @@ static void nsp32_sack_negate (nsp32_hw_data *);
>  static void nsp32_do_bus_reset(nsp32_hw_data *);
>  
>  /* hardware interrupt handler */
> -static irqreturn_t do_nsp32_isr(int, void *);
> +static irqreturn_t do_nsp32_isr(void *);
>  
>  /* initialize hardware */
>  static int  nsp32hw_init(nsp32_hw_data *);
> @@ -1161,7 +1161,7 @@ static int nsp32hw_init(nsp32_hw_data *data)
>  
>  
>  /* interrupt routine */
> -static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
> +static irqreturn_t do_nsp32_isr(void *dev_id)
>  {
>  	nsp32_hw_data *data = dev_id;
>  	unsigned int base = data->BaseAddress;
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c 
> b/drivers/scsi/pcmcia/nsp_cs.c
> index a45d89b..49f42c3 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -940,7 +940,7 @@ static int nsp_nexus(struct scsi_cmnd *SCpnt)
>  /*
>   * interrupt handler
>   */
> -static irqreturn_t nspintr(int irq, void *dev_id)
> +static irqreturn_t nspintr(void *dev_id)
>  {
>  	unsigned int   base;
>  	unsigned char  irq_status, irq_phase, phase;
> diff --git a/drivers/scsi/pcmcia/nsp_cs.h 
> b/drivers/scsi/pcmcia/nsp_cs.h
> index b7f0fa2..1ea53ae 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -332,7 +332,7 @@ static int  nsp_reselected       (struct 
> scsi_cmnd *SCpnt);
>  static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
>  
>  /* Interrupt handler */
> -//static irqreturn_t nspintr(int irq, void *dev_id);
> +//static irqreturn_t nspintr(void *dev_id);
>  
>  /* Module entry point*/
>  static int  __init nsp_cs_init(void);
> diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c 
> b/drivers/scsi/pcmcia/sym53c500_cs.c
> index 190e2a7..45e52df 100644
> --- a/drivers/scsi/pcmcia/sym53c500_cs.c
> +++ b/drivers/scsi/pcmcia/sym53c500_cs.c
> @@ -362,7 +362,7 @@ SYM53C500_pio_write(int fast_pio, int 
> base, unsigned char *request, unsigned int
>  }
>  
>  static irqreturn_t
> -SYM53C500_intr(int irq, void *dev_id)
> +SYM53C500_intr(void *dev_id)
>  {
>  	unsigned long flags;
>  	struct Scsi_Host *dev = dev_id;
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 76089cf..013e4c1 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -1111,7 +1111,7 @@ qla1280_enable_intrs(struct scsi_qla_host *ha)
>   *   Handles the H/W interrupt
>   
> **************************************************************
> ************/
>  static irqreturn_t
> -qla1280_intr_handler(int irq, void *dev_id)
> +qla1280_intr_handler(void *dev_id)
>  {
>  	struct scsi_qla_host *ha;
>  	struct device_reg __iomem *reg;
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h 
> b/drivers/scsi/qla2xxx/qla_gbl.h
> index 09cb2a9..e5de80e 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -258,9 +258,9 @@ qla2x00_set_idma_speed(scsi_qla_host_t *, 
> uint16_t, uint16_t, uint16_t *);
>  /*
>   * Global Function Prototypes in qla_isr.c source file.
>   */
> -extern irqreturn_t qla2100_intr_handler(int, void *);
> -extern irqreturn_t qla2300_intr_handler(int, void *);
> -extern irqreturn_t qla24xx_intr_handler(int, void *);
> +extern irqreturn_t qla2100_intr_handler(void *);
> +extern irqreturn_t qla2300_intr_handler(void *);
> +extern irqreturn_t qla24xx_intr_handler(void *);
>  extern void qla2x00_process_response_queue(struct scsi_qla_host *);
>  extern void qla24xx_process_response_queue(struct scsi_qla_host *);
>  
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h 
> b/drivers/scsi/qla2xxx/qla_inline.h
> index 8e3b044..cf05419 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -104,7 +104,7 @@ static __inline__ void 
> qla2x00_poll(scsi_qla_host_t *);
>  static inline void
>  qla2x00_poll(scsi_qla_host_t *ha)
>  {
> -	ha->isp_ops->intr_handler(0, ha);
> +	ha->isp_ops->intr_handler(ha);
>  }
>  
>  static __inline__ void 
> qla2x00_check_fabric_devices(scsi_qla_host_t *);
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c 
> b/drivers/scsi/qla2xxx/qla_isr.c
> index c4768c4..714c100 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -20,7 +20,6 @@ static void 
> qla24xx_ms_entry(scsi_qla_host_t *, struct ct_entry_24xx *);
>  
>  /**
>   * qla2100_intr_handler() - Process interrupts for the 
> ISP2100 and ISP2200.
> - * @irq:
>   * @dev_id: SCSI driver HA context
>   *
>   * Called by system whenever the host adapter generates an interrupt.
> @@ -28,7 +27,7 @@ static void 
> qla24xx_ms_entry(scsi_qla_host_t *, struct ct_entry_24xx *);
>   * Returns handled flag.
>   */
>  irqreturn_t
> -qla2100_intr_handler(int irq, void *dev_id)
> +qla2100_intr_handler(void *dev_id)
>  {
>  	scsi_qla_host_t	*ha;
>  	struct device_reg_2xxx __iomem *reg;
> @@ -120,7 +119,7 @@ qla2100_intr_handler(int irq, void *dev_id)
>   * Returns handled flag.
>   */
>  irqreturn_t
> -qla2300_intr_handler(int irq, void *dev_id)
> +qla2300_intr_handler(void *dev_id)
>  {
>  	scsi_qla_host_t	*ha;
>  	struct device_reg_2xxx __iomem *reg;
> @@ -1541,7 +1540,7 @@ done:
>   * Returns handled flag.
>   */
>  irqreturn_t
> -qla24xx_intr_handler(int irq, void *dev_id)
> +qla24xx_intr_handler(void *dev_id)
>  {
>  	scsi_qla_host_t	*ha;
>  	struct device_reg_24xx __iomem *reg;
> @@ -1665,7 +1664,7 @@ qla24xx_ms_entry(scsi_qla_host_t *ha, 
> struct ct_entry_24xx *pkt)
>  }
>  
>  static irqreturn_t
> -qla24xx_msix_rsp_q(int irq, void *dev_id)
> +qla24xx_msix_rsp_q(void *dev_id)
>  {
>  	scsi_qla_host_t	*ha;
>  	struct device_reg_24xx __iomem *reg;
> @@ -1686,7 +1685,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
>  }
>  
>  static irqreturn_t
> -qla24xx_msix_default(int irq, void *dev_id)
> +qla24xx_msix_default(void *dev_id)
>  {
>  	scsi_qla_host_t	*ha;
>  	struct device_reg_24xx __iomem *reg;
> diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h 
> b/drivers/scsi/qla4xxx/ql4_glbl.h
> index a3608e0..da9e27e 100644
> --- a/drivers/scsi/qla4xxx/ql4_glbl.h
> +++ b/drivers/scsi/qla4xxx/ql4_glbl.h
> @@ -17,7 +17,7 @@ int qla4xxx_send_command_to_isp(struct 
> scsi_qla_host *ha, struct srb * srb);
>  int qla4xxx_initialize_adapter(struct scsi_qla_host * ha,
>  			       uint8_t renew_ddb_list);
>  int qla4xxx_soft_reset(struct scsi_qla_host *ha);
> -irqreturn_t qla4xxx_intr_handler(int irq, void *dev_id);
> +irqreturn_t qla4xxx_intr_handler(void *dev_id);
>  
>  void qla4xxx_free_ddb_list(struct scsi_qla_host * ha);
>  void qla4xxx_process_aen(struct scsi_qla_host * ha, uint8_t 
> process_aen);
> diff --git a/drivers/scsi/qla4xxx/ql4_isr.c 
> b/drivers/scsi/qla4xxx/ql4_isr.c
> index 4a154be..118d23a 100644
> --- a/drivers/scsi/qla4xxx/ql4_isr.c
> +++ b/drivers/scsi/qla4xxx/ql4_isr.c
> @@ -633,10 +633,9 @@ void 
> qla4xxx_interrupt_service_routine(struct scsi_qla_host * ha,
>  
>  /**
>   * qla4xxx_intr_handler - hardware interrupt handler.
> - * @irq: Unused
>   * @dev_id: Pointer to host adapter structure
>   **/
> -irqreturn_t qla4xxx_intr_handler(int irq, void *dev_id)
> +irqreturn_t qla4xxx_intr_handler(void *dev_id)
>  {
>  	struct scsi_qla_host *ha;
>  	uint32_t intr_status;
> diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
> index 2bfbf26..ac372b1 100644
> --- a/drivers/scsi/qlogicfas408.c
> +++ b/drivers/scsi/qlogicfas408.c
> @@ -424,7 +424,7 @@ static void ql_ihandl(void *dev_id)
>  	(icmd->scsi_done) (icmd);
>  }
>  
> -irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id)
> +irqreturn_t qlogicfas408_ihandl(void *dev_id)
>  {
>  	unsigned long flags;
>  	struct Scsi_Host *host = dev_id;
> diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
> index 2606264..57e7ed2 100644
> --- a/drivers/scsi/qlogicfas408.h
> +++ b/drivers/scsi/qlogicfas408.h
> @@ -102,7 +102,7 @@ struct qlogicfas408_priv {
>  #define get_priv_by_cmd(x) (struct qlogicfas408_priv 
> *)&((x)->device->host->hostdata[0])
>  #define get_priv_by_host(x) (struct qlogicfas408_priv 
> *)&((x)->hostdata[0])
>  
> -irqreturn_t qlogicfas408_ihandl(int irq, void *dev_id);
> +irqreturn_t qlogicfas408_ihandl(void *dev_id);
>  int qlogicfas408_queuecommand(struct scsi_cmnd * cmd,
>  			      void (*done) (struct scsi_cmnd *));
>  int qlogicfas408_biosparam(struct scsi_device * disk,
> diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
> index 7a2e798..a08b023 100644
> --- a/drivers/scsi/qlogicpti.c
> +++ b/drivers/scsi/qlogicpti.c
> @@ -649,7 +649,7 @@ static int qlogicpti_verify_tmon(struct 
> qlogicpti *qpti)
>  	return 0;
>  }
>  
> -static irqreturn_t qpti_intr(int irq, void *dev_id);
> +static irqreturn_t qpti_intr(void *dev_id);
>  
>  static void __init qpti_chain_add(struct qlogicpti *qpti)
>  {
> @@ -1180,7 +1180,7 @@ static struct scsi_cmnd 
> *qlogicpti_intr_handler(struct qlogicpti *qpti)
>  	return done_queue;
>  }
>  
> -static irqreturn_t qpti_intr(int irq, void *dev_id)
> +static irqreturn_t qpti_intr(void *dev_id)
>  {
>  	struct qlogicpti *qpti = dev_id;
>  	unsigned long flags;
> diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
> index ce80fa9..440aff0 100644
> --- a/drivers/scsi/seagate.c
> +++ b/drivers/scsi/seagate.c
> @@ -321,8 +321,8 @@ static Signature __initdata signatures[] = {
>   */
>  
>  static int hostno = -1;
> -static void seagate_reconnect_intr (int, void *);
> -static irqreturn_t do_seagate_reconnect_intr (int, void *);
> +static void seagate_reconnect_intr (void *);
> +static irqreturn_t do_seagate_reconnect_intr (void *);
>  static int seagate_st0x_bus_reset(struct scsi_cmnd *);
>  
>  #ifdef FAST
> @@ -620,18 +620,18 @@ static int should_reconnect = 0;
>   * asserting SEL.
>   */
>  
> -static irqreturn_t do_seagate_reconnect_intr(int irq, void *dev_id)
> +static irqreturn_t do_seagate_reconnect_intr(void *dev_id)
>  {
>  	unsigned long flags;
>  	struct Scsi_Host *dev = dev_id;
>  	
>  	spin_lock_irqsave (dev->host_lock, flags);
> -	seagate_reconnect_intr (irq, dev_id);
> +	seagate_reconnect_intr (dev_id);
>  	spin_unlock_irqrestore (dev->host_lock, flags);
>  	return IRQ_HANDLED;
>  }
>  
> -static void seagate_reconnect_intr (int irq, void *dev_id)
> +static void seagate_reconnect_intr (void *dev_id)
>  {
>  	int temp;
>  	struct scsi_cmnd *SCtmp;
> diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
> index eef8275..48e4b72 100644
> --- a/drivers/scsi/sgiwd93.c
> +++ b/drivers/scsi/sgiwd93.c
> @@ -46,7 +46,7 @@ struct hpc_chunk {
>  	u32 _padding;	/* align to quadword boundary */
>  };
>  
> -static irqreturn_t sgiwd93_intr(int irq, void *dev_id)
> +static irqreturn_t sgiwd93_intr(void *dev_id)
>  {
>  	struct Scsi_Host * host = dev_id;
>  	unsigned long flags;
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index e3fab3a..79b98f1 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -838,7 +838,7 @@ update_status:
>  	readl(base + IMR1); /* flush */
>  }
>  
> -static irqreturn_t stex_intr(int irq, void *__hba)
> +static irqreturn_t stex_intr(void *__hba)
>  {
>  	struct st_hba *hba = __hba;
>  	void __iomem *base = hba->mmio_base;
> diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
> index dc15a22..3f20aa6 100644
> --- a/drivers/scsi/sun3_NCR5380.c
> +++ b/drivers/scsi/sun3_NCR5380.c
> @@ -1255,7 +1255,7 @@ static void NCR5380_dma_complete( 
> struct Scsi_Host *instance )
>   *
>   */
>  
> -static irqreturn_t NCR5380_intr (int irq, void *dev_id)
> +static irqreturn_t NCR5380_intr (void *dev_id)
>  {
>      struct Scsi_Host *instance = first_instance;
>      int done = 1, handled = 0;
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index 5e46d84..aa76608 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -101,7 +101,7 @@ static void NCR5380_print(struct 
> Scsi_Host *instance);
>  #define	ENABLE_IRQ()	enable_irq( IRQ_SUN3_SCSI ); 
>  
>  
> -static irqreturn_t scsi_sun3_intr(int irq, void *dummy);
> +static irqreturn_t scsi_sun3_intr(void *dummy);
>  static inline unsigned char sun3scsi_read(int reg);
>  static inline void sun3scsi_write(int reg, int value);
>  
> @@ -370,7 +370,7 @@ const char * sun3scsi_info (struct 
> Scsi_Host *spnt) {
>  // safe bits for the CSR
>  #define CSR_GOOD 0x060f
>  
> -static irqreturn_t scsi_sun3_intr(int irq, void *dummy)
> +static irqreturn_t scsi_sun3_intr(void *dummy)
>  {
>  	unsigned short csr = dregs->csr;
>  	int handled = 0;
> diff --git a/drivers/scsi/sun3_scsi_vme.c 
> b/drivers/scsi/sun3_scsi_vme.c
> index 7cb4a31..cf243a7 100644
> --- a/drivers/scsi/sun3_scsi_vme.c
> +++ b/drivers/scsi/sun3_scsi_vme.c
> @@ -66,7 +66,7 @@ extern int sun3_map_test(unsigned long, char *);
>  #define ENABLE_IRQ()
>  
>  
> -static irqreturn_t scsi_sun3_intr(int irq, void *dummy);
> +static irqreturn_t scsi_sun3_intr(void *dummy);
>  static inline unsigned char sun3scsi_read(int reg);
>  static inline void sun3scsi_write(int reg, int value);
>  
> @@ -339,7 +339,7 @@ static const char * sun3scsi_info (struct 
> Scsi_Host *spnt) {
>  // safe bits for the CSR
>  #define CSR_GOOD 0x060f
>  
> -static irqreturn_t scsi_sun3_intr(int irq, void *dummy)
> +static irqreturn_t scsi_sun3_intr(void *dummy)
>  {
>  	unsigned short csr = dregs->csr;
>  	int handled = 0;
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c 
> b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index db03c4c..e6766b4 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -591,7 +591,7 @@ static int sym53c8xx_queue_command(struct 
> scsi_cmnd *cmd,
>  /*
>   *  Linux entry point of the interrupt handler.
>   */
> -static irqreturn_t sym53c8xx_intr(int irq, void *dev_id)
> +static irqreturn_t sym53c8xx_intr(void *dev_id)
>  {
>  	unsigned long flags;
>  	struct sym_hcb *np = (struct sym_hcb *)dev_id;
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 5c72ca3..ea27599 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -742,7 +742,7 @@ DC390_Interrupt(void *dev_id)
>      return IRQ_HANDLED;
>  }
>  
> -static irqreturn_t do_DC390_Interrupt(int irq, void *dev_id)
> +static irqreturn_t do_DC390_Interrupt(void *dev_id)
>  {
>      irqreturn_t ret;
>      DEBUG1(printk (KERN_INFO "DC390: Irq (%i) caught: ", irq));
> diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
> index ea72bbe..cdde36a 100644
> --- a/drivers/scsi/ultrastor.c
> +++ b/drivers/scsi/ultrastor.c
> @@ -288,7 +288,7 @@ static const unsigned short 
> ultrastor_ports_14f[] = {
>  #endif
>  
>  static void ultrastor_interrupt(void *);
> -static irqreturn_t do_ultrastor_interrupt(int, void *);
> +static irqreturn_t do_ultrastor_interrupt(void *);
>  static inline void build_sg_list(struct mscp *, struct 
> scsi_cmnd *SCpnt);
>  
>  
> @@ -1170,7 +1170,7 @@ static void ultrastor_interrupt(void *dev_id)
>  #endif
>  }
>  
> -static irqreturn_t do_ultrastor_interrupt(int irq, void *dev_id)
> +static irqreturn_t do_ultrastor_interrupt(void *dev_id)
>  {
>      unsigned long flags;
>      struct Scsi_Host *dev = dev_id;
> diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
> index 255c611..19ca418 100644
> --- a/drivers/scsi/wd7000.c
> +++ b/drivers/scsi/wd7000.c
> @@ -998,7 +998,7 @@ static int make_code(unsigned hosterr, 
> unsigned scsierr)
>  #define wd7000_intr_ack(host)   outb (0, host->iobase + ASC_INTR_ACK)
>  
>  
> -static irqreturn_t wd7000_intr(int irq, void *dev_id)
> +static irqreturn_t wd7000_intr(void *dev_id)
>  {
>  	Adapter *host = (Adapter *) dev_id;
>  	int flag, icmb, errstatus, icmb_status;
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
