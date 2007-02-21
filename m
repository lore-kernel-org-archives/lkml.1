Return-Path: <linux-kernel-owner+w=401wt.eu-S1751245AbXBUObr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbXBUObr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXBUObr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:31:47 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:37392 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbXBUObq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:31:46 -0500
Subject: Re: [2.6 patch] drivers/infiniband/hw/cxgb3/: cleanups
From: Steve Wise <swise@opengridcomputing.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Roland Dreier <rolandd@cisco.com>, linux-kernel@vger.kernel.org,
       mshefty@ichips.intel.com, halr@voltaire.com, openib-general@openib.org
In-Reply-To: <20070221105249.GC13958@stusta.de>
References: <20070220000211.GZ13958@stusta.de>
	 <1171982587.2101.0.camel@stevo-desktop>  <20070221105249.GC13958@stusta.de>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 08:31:45 -0600
Message-Id: <1172068305.21243.2.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Adrian!

Acked-by: Steve Wise <swise@opengridcomputing.com>


On Wed, 2007-02-21 at 11:52 +0100, Adrian Bunk wrote:
> On Tue, Feb 20, 2007 at 08:43:06AM -0600, Steve Wise wrote:
> > On Tue, 2007-02-20 at 01:02 +0100, Adrian Bunk wrote:
> > > This patch contains the following possible cleanups:
> > > - don't mark static functions in C files as inline - gcc should know
> > >   best whether inlining makes sense
> > > - never compile the unused cxio_dbg.c
> > > - make the following needlessly global functions static:
> > >   - cxio_hal.c: cxio_hal_clear_qp_ctx()
> > >   - iwch_provider.c: iwch_get_qp()
> > > - #if 0 the following unused global functions:
> > >   - cxio_hal.c: cxio_allocate_stag()
> > >   - cxio_resource.: cxio_hal_get_rhdl()
> > >   - cxio_resource.: cxio_hal_put_rhdl()
> > > 
> > 
> > You could just remove the code instead of #if 0...
> >...
> 
> Updated patch below.
> 
> cu
> Adrian
> 
> 
> <--  snip  -->
> 
> 
> This patch contains the following possible cleanups:
> - don't mark static functions in C files as inline - gcc should know
>   best whether inlining makes sense
> - never compile the unused cxio_dbg.c
> - make the following needlessly global functions static:
>   - cxio_hal.c: cxio_hal_clear_qp_ctx()
>   - iwch_provider.c: iwch_get_qp()
> - remove the following unused global functions:
>   - cxio_hal.c: cxio_allocate_stag()
>   - cxio_resource.: cxio_hal_get_rhdl()
>   - cxio_resource.: cxio_hal_put_rhdl()
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  drivers/infiniband/hw/cxgb3/Makefile        |    1 
>  drivers/infiniband/hw/cxgb3/cxio_hal.c      |   31 +++++---------------
>  drivers/infiniband/hw/cxgb3/cxio_hal.h      |    5 ---
>  drivers/infiniband/hw/cxgb3/cxio_resource.c |   14 +--------
>  drivers/infiniband/hw/cxgb3/iwch_cm.c       |    5 +--
>  drivers/infiniband/hw/cxgb3/iwch_provider.c |    2 -
>  drivers/infiniband/hw/cxgb3/iwch_provider.h |    1 
>  drivers/infiniband/hw/cxgb3/iwch_qp.c       |   29 ++++++++----------
>  8 files changed, 27 insertions(+), 61 deletions(-)
> 
> --- linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/Makefile.old	2007-02-17 17:21:03.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/Makefile	2007-02-17 17:21:08.000000000 +0100
> @@ -8,5 +8,4 @@
>  
>  ifdef CONFIG_INFINIBAND_CXGB3_DEBUG
>  EXTRA_CFLAGS += -DDEBUG
> -iw_cxgb3-y += cxio_dbg.o
>  endif
> --- linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/cxio_hal.h.old	2007-02-17 17:22:53.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/cxio_hal.h	2007-02-17 17:25:08.000000000 +0100
> @@ -144,7 +144,6 @@
>  void cxio_rdev_close(struct cxio_rdev *rdev);
>  int cxio_hal_cq_op(struct cxio_rdev *rdev, struct t3_cq *cq,
>  		   enum t3_cq_opcode op, u32 credit);
> -int cxio_hal_clear_qp_ctx(struct cxio_rdev *rdev, u32 qpid);
>  int cxio_create_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
>  int cxio_destroy_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
>  int cxio_resize_cq(struct cxio_rdev *rdev, struct t3_cq *cq);
> @@ -155,8 +154,6 @@
>  int cxio_destroy_qp(struct cxio_rdev *rdev, struct t3_wq *wq,
>  		    struct cxio_ucontext *uctx);
>  int cxio_peek_cq(struct t3_wq *wr, struct t3_cq *cq, int opcode);
> -int cxio_allocate_stag(struct cxio_rdev *rdev, u32 * stag, u32 pdid,
> -		       enum tpt_mem_perm perm, u32 * pbl_size, u32 * pbl_addr);
>  int cxio_register_phys_mem(struct cxio_rdev *rdev, u32 * stag, u32 pdid,
>  			   enum tpt_mem_perm perm, u32 zbva, u64 to, u32 len,
>  			   u8 page_size, __be64 *pbl, u32 *pbl_size,
> @@ -172,8 +169,6 @@
>  int cxio_rdma_init(struct cxio_rdev *rdev, struct t3_rdma_init_attr *attr);
>  void cxio_register_ev_cb(cxio_hal_ev_callback_func_t ev_cb);
>  void cxio_unregister_ev_cb(cxio_hal_ev_callback_func_t ev_cb);
> -u32 cxio_hal_get_rhdl(void);
> -void cxio_hal_put_rhdl(u32 rhdl);
>  u32 cxio_hal_get_pdid(struct cxio_hal_resource *rscp);
>  void cxio_hal_put_pdid(struct cxio_hal_resource *rscp, u32 pdid);
>  int __init cxio_hal_init(void);
> --- linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/iwch_provider.h.old	2007-02-17 17:25:35.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/iwch_provider.h	2007-02-17 17:25:41.000000000 +0100
> @@ -179,7 +179,6 @@
>  
>  void iwch_qp_add_ref(struct ib_qp *qp);
>  void iwch_qp_rem_ref(struct ib_qp *qp);
> -struct ib_qp *iwch_get_qp(struct ib_device *dev, int qpn);
>  
>  struct iwch_ucontext {
>  	struct ib_ucontext ibucontext;
> --- linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/iwch_provider.c.old	2007-02-17 17:25:50.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/iwch_provider.c	2007-02-17 17:25:57.000000000 +0100
> @@ -949,7 +949,7 @@
>  	        wake_up(&(to_iwch_qp(qp)->wait));
>  }
>  
> -struct ib_qp *iwch_get_qp(struct ib_device *dev, int qpn)
> +static struct ib_qp *iwch_get_qp(struct ib_device *dev, int qpn)
>  {
>  	PDBG("%s ib_dev %p qpn 0x%x\n", __FUNCTION__, dev, qpn);
>  	return (struct ib_qp *)get_qhp(to_iwch_dev(dev), qpn);
> --- linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/iwch_qp.c.old	2007-02-17 17:27:31.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/iwch_qp.c	2007-02-17 17:38:07.000000000 +0100
> @@ -37,8 +37,8 @@
>  
>  #define NO_SUPPORT -1
>  
> -static inline int iwch_build_rdma_send(union t3_wr *wqe, struct ib_send_wr *wr,
> -				       u8 * flit_cnt)
> +static int iwch_build_rdma_send(union t3_wr *wqe, struct ib_send_wr *wr,
> +				u8 * flit_cnt)
>  {
>  	int i;
>  	u32 plen;
> @@ -97,8 +97,8 @@
>  	return 0;
>  }
>  
> -static inline int iwch_build_rdma_write(union t3_wr *wqe, struct ib_send_wr *wr,
> -					u8 *flit_cnt)
> +static int iwch_build_rdma_write(union t3_wr *wqe, struct ib_send_wr *wr,
> +				 u8 *flit_cnt)
>  {
>  	int i;
>  	u32 plen;
> @@ -138,8 +138,8 @@
>  	return 0;
>  }
>  
> -static inline int iwch_build_rdma_read(union t3_wr *wqe, struct ib_send_wr *wr,
> -				       u8 *flit_cnt)
> +static int iwch_build_rdma_read(union t3_wr *wqe, struct ib_send_wr *wr,
> +				u8 *flit_cnt)
>  {
>  	if (wr->num_sge > 1)
>  		return -EINVAL;
> @@ -159,9 +159,8 @@
>  /*
>   * TBD: this is going to be moved to firmware. Missing pdid/qpid check for now.
>   */
> -static inline int iwch_sgl2pbl_map(struct iwch_dev *rhp,
> -				   struct ib_sge *sg_list, u32 num_sgle,
> -				   u32 * pbl_addr, u8 * page_size)
> +static int iwch_sgl2pbl_map(struct iwch_dev *rhp, struct ib_sge *sg_list,
> +			    u32 num_sgle, u32 * pbl_addr, u8 * page_size)
>  {
>  	int i;
>  	struct iwch_mr *mhp;
> @@ -207,9 +206,8 @@
>  	return 0;
>  }
>  
> -static inline int iwch_build_rdma_recv(struct iwch_dev *rhp,
> -						    union t3_wr *wqe,
> -						    struct ib_recv_wr *wr)
> +static int iwch_build_rdma_recv(struct iwch_dev *rhp, union t3_wr *wqe,
> +				struct ib_recv_wr *wr)
>  {
>  	int i, err = 0;
>  	u32 pbl_addr[4];
> @@ -474,8 +472,7 @@
>  	return err;
>  }
>  
> -static inline void build_term_codes(int t3err, u8 *layer_type, u8 *ecode,
> -				    int tagged)
> +static void build_term_codes(int t3err, u8 *layer_type, u8 *ecode, int tagged)
>  {
>  	switch (t3err) {
>  	case TPT_ERR_STAG:
> @@ -673,7 +670,7 @@
>  	spin_lock_irqsave(&qhp->lock, *flag);
>  }
>  
> -static inline void flush_qp(struct iwch_qp *qhp, unsigned long *flag)
> +static void flush_qp(struct iwch_qp *qhp, unsigned long *flag)
>  {
>  	if (t3b_device(qhp->rhp))
>  		cxio_set_wq_in_error(&qhp->wq);
> @@ -685,7 +682,7 @@
>  /*
>   * Return non zero if at least one RECV was pre-posted.
>   */
> -static inline int rqes_posted(struct iwch_qp *qhp)
> +static int rqes_posted(struct iwch_qp *qhp)
>  {
>  	return fw_riwrh_opcode((struct fw_riwrh *)qhp->wq.queue) == T3_WR_RCV;
>  }
> --- linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/iwch_cm.c.old	2007-02-17 17:27:53.000000000 +0100
> +++ linux-2.6.20-mm1/drivers/infiniband/hw/cxgb3/iwch_cm.c	2007-02-17 17:38:23.000000000 +0100
> @@ -210,8 +210,7 @@
>  	return state;
>  }
>  
> -static inline void __state_set(struct iwch_ep_common *epc,
> -			       enum iwch_ep_state new)
> +static void __state_set(struct iwch_ep_common *epc, enum iwch_ep_state new)
>  {
>  	epc->state = new;
>  }
> @@ -1460,7 +1459,7 @@
>  /*
>   * Returns whether an ABORT_REQ_RSS message is a negative advice.
>   */
> -static inline int is_neg_adv_abort(unsigned int status)
> +static int is_neg_adv_abort(unsigned int status)
>  {
>  	return status == CPL_ERR_RTX_NEG_ADVICE ||
>  	       status == CPL_ERR_PERSIST_NEG_ADVICE;
> --- linux-2.6.20-mm2/drivers/infiniband/hw/cxgb3/cxio_resource.c.old	2007-02-20 23:22:29.000000000 +0100
> +++ linux-2.6.20-mm2/drivers/infiniband/hw/cxgb3/cxio_resource.c	2007-02-20 23:12:04.000000000 +0100
> @@ -179,7 +179,7 @@
>  /*
>   * returns 0 if no resource available
>   */
> -static inline u32 cxio_hal_get_resource(struct kfifo *fifo)
> +static u32 cxio_hal_get_resource(struct kfifo *fifo)
>  {
>  	u32 entry;
>  	if (kfifo_get(fifo, (unsigned char *) &entry, sizeof(u32)))
> @@ -188,21 +188,11 @@
>  		return 0;	/* fifo emptry */
>  }
>  
> -static inline void cxio_hal_put_resource(struct kfifo *fifo, u32 entry)
> +static void cxio_hal_put_resource(struct kfifo *fifo, u32 entry)
>  {
>  	BUG_ON(kfifo_put(fifo, (unsigned char *) &entry, sizeof(u32)) == 0);
>  }
>  
> -u32 cxio_hal_get_rhdl(void)
> -{
> -	return cxio_hal_get_resource(rhdl_fifo);
> -}
> -
> -void cxio_hal_put_rhdl(u32 rhdl)
> -{
> -	cxio_hal_put_resource(rhdl_fifo, rhdl);
> -}
> -
>  u32 cxio_hal_get_stag(struct cxio_hal_resource *rscp)
>  {
>  	return cxio_hal_get_resource(rscp->tpt_fifo);
> --- linux-2.6.20-mm2/drivers/infiniband/hw/cxgb3/cxio_hal.c.old	2007-02-20 23:22:42.000000000 +0100
> +++ linux-2.6.20-mm2/drivers/infiniband/hw/cxgb3/cxio_hal.c	2007-02-20 23:12:43.000000000 +0100
> @@ -45,7 +45,7 @@
>  static LIST_HEAD(rdev_list);
>  static cxio_hal_ev_callback_func_t cxio_ev_cb = NULL;
>  
> -static inline struct cxio_rdev *cxio_hal_find_rdev_by_name(char *dev_name)
> +static struct cxio_rdev *cxio_hal_find_rdev_by_name(char *dev_name)
>  {
>  	struct cxio_rdev *rdev;
>  
> @@ -55,8 +55,7 @@
>  	return NULL;
>  }
>  
> -static inline struct cxio_rdev *cxio_hal_find_rdev_by_t3cdev(struct t3cdev
> -							     *tdev)
> +static struct cxio_rdev *cxio_hal_find_rdev_by_t3cdev(struct t3cdev *tdev)
>  {
>  	struct cxio_rdev *rdev;
>  
> @@ -118,7 +117,7 @@
>  	return 0;
>  }
>  
> -static inline int cxio_hal_clear_cq_ctx(struct cxio_rdev *rdev_p, u32 cqid)
> +static int cxio_hal_clear_cq_ctx(struct cxio_rdev *rdev_p, u32 cqid)
>  {
>  	struct rdma_cq_setup setup;
>  	setup.id = cqid;
> @@ -130,7 +129,7 @@
>  	return (rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, RDMA_CQ_SETUP, &setup));
>  }
>  
> -int cxio_hal_clear_qp_ctx(struct cxio_rdev *rdev_p, u32 qpid)
> +static int cxio_hal_clear_qp_ctx(struct cxio_rdev *rdev_p, u32 qpid)
>  {
>  	u64 sge_cmd;
>  	struct t3_modify_qp_wr *wqe;
> @@ -425,7 +424,7 @@
>  	}
>  }
>  
> -static inline int cqe_completes_wr(struct t3_cqe *cqe, struct t3_wq *wq)
> +static int cqe_completes_wr(struct t3_cqe *cqe, struct t3_wq *wq)
>  {
>  	if (CQE_OPCODE(*cqe) == T3_TERMINATE)
>  		return 0;
> @@ -760,17 +759,6 @@
>  	return err;
>  }
>  
> -/* IN : stag key, pdid, pbl_size
> - * Out: stag index, actaul pbl_size, and pbl_addr allocated.
> - */
> -int cxio_allocate_stag(struct cxio_rdev *rdev_p, u32 * stag, u32 pdid,
> -		       enum tpt_mem_perm perm, u32 * pbl_size, u32 * pbl_addr)
> -{
> -	*stag = T3_STAG_UNSET;
> -	return (__cxio_tpt_op(rdev_p, 0, stag, 0, pdid, TPT_NON_SHARED_MR,
> -			      perm, 0, 0ULL, 0, 0, NULL, pbl_size, pbl_addr));
> -}
> -
>  int cxio_register_phys_mem(struct cxio_rdev *rdev_p, u32 *stag, u32 pdid,
>  			   enum tpt_mem_perm perm, u32 zbva, u64 to, u32 len,
>  			   u8 page_size, __be64 *pbl, u32 *pbl_size,
> @@ -1029,7 +1017,7 @@
>  	cxio_hal_destroy_rhdl_resource();
>  }
>  
> -static inline void flush_completed_wrs(struct t3_wq *wq, struct t3_cq *cq)
> +static void flush_completed_wrs(struct t3_wq *wq, struct t3_cq *cq)
>  {
>  	struct t3_swsq *sqp;
>  	__u32 ptr = wq->sq_rptr;
> @@ -1058,9 +1046,8 @@
>  			break;
>  }
>  
> -static inline void create_read_req_cqe(struct t3_wq *wq,
> -				       struct t3_cqe *hw_cqe,
> -				       struct t3_cqe *read_cqe)
> +static void create_read_req_cqe(struct t3_wq *wq, struct t3_cqe *hw_cqe,
> +				struct t3_cqe *read_cqe)
>  {
>  	read_cqe->u.scqe.wrid_hi = wq->oldest_read->sq_wptr;
>  	read_cqe->len = wq->oldest_read->read_len;
> @@ -1073,7 +1060,7 @@
>  /*
>   * Return a ptr to the next read wr in the SWSQ or NULL.
>   */
> -static inline void advance_oldest_read(struct t3_wq *wq)
> +static void advance_oldest_read(struct t3_wq *wq)
>  {
>  
>  	u32 rptr = wq->oldest_read - wq->sq + 1;
> 

