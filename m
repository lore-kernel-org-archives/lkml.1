Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYKZBKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYKZBKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYKZBJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:09:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49265 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbYKZBJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:09:40 -0500
Date: Wed, 26 Nov 2008 02:09:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: [warnings] 37 warning fixes in networking related files
Message-ID: <20081126010927.GA9527@elte.hu>
References: <20081125085820.GA11401@elte.hu> <20081125152014.GB29096@gondor.apana.org.au> <20081125171438.GK22504@elte.hu> <20081125.135231.81163255.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081125.135231.81163255.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 25 Nov 2008 18:14:38 +0100
> 
> > btw, on a related note, there's a couple of networking related warning 
> > fixes/annotations i've got queued up.
> 
> I see these now, but they would get properly logged and
> tracked at:
> 
> 	http://patchwork.ozlabs.org/project/netdev/
> 
> if you would simply CC: netdev instead of sending them into
> the ether by informing lkml and the crypto list about them.

sure - netdev Cc:-ed, subject line changed - mail repeated below.

This one seems to be a real bug too (subject line nonwithstanding):

  69f38f6: fix warning in drivers/net/depca.c

besides the bugfixes, the annotations would be nice to have too - i 
got the warnings with latest-gcc (4.3.2) and once we reach a baseline 
of no warnings it will be much easier to go forward in a delta manner. 
At that points commits that actually cause new warnings will be much 
fresher - and the warnings will be a lot more interesting in general 
as well.

Right now we've got a baseline noise where it's mostly GCC that is 
wrong. Obviously those are the warnings that tend to linger around in 
the kernel source: people see the warnings and determine that GCC is 
wrong and keep the source unchanged.

The arch/x86/* files already have a zero warnings baseline (clean 
-Werror builds), and my experience is that the new warnings that pop 
up are generally quite healthy and interesting, with a low false 
positive rate.

Hm?

	Ingo

---------------->

I've got 37 commits of that nature in the tip/warnings/* topic 
branches:

  d94b43b: fix warning in drivers/net/s2io.c
  78f065d: fix warnings in drivers/net/niu.c
  9cc0c65: fix warning in drivers/net/niu.c
  32fd3b5: fix warning in drivers/net/qla3xxx.c
  ba58621: fix warning in net/sunrpc/xprtrdma/svc_rdma_transport.c
  b91eb99: fix warning in net/sched/sch_hfsc.c
  c390a37: fix warning in net/netfilter/nf_conntrack_ftp.c
  8fecea6: fix warning in net/ipv6/ip6_flowlabel.c
  e5e5492: fix warning in drivers/net/wan/z85230.c
  67230f2: fix warning in net/dsa/mv88e6xxx.c
  948158e: fix warning in net/dsa/mv88e6060.c
  8574b3b: fix warning in fs/dlm/netlink.c
  9b9c8fd: fix warning in drivers/net/sis900.c
  924a289: fix warning in drivers/net/wireless/iwlwifi/iwl-3945.c
  2267239: fix warning in drivers/net/wireless/b43/main.c
  de96506: fix warning in drivers/net/wireless/ath9k/rc.c
  742cddc: fix error path in drivers/net/mlx4/en_rx.c
  181787d: fix warning in drivers/net/cassini.c
  96c7925: fix warning in net/dccp/options.c
  193e56a: fix warning in drivers/net/mlx4/mcg.c
  bcc35f7: fix warning in net/ax25/sysctl_net_ax25.c
  59681c6: fix warning in net/sunrpc/xprtrdma/verbs.c
  ad8d03b: fix warning in net/bluetooth/rfcomm/sock.c
  320451a: fix warning in drivers/net/wireless/ray_cs.c
  decc165: fix warning in net/netfilter/nf_conntrack_proto_sctp.c
  b547d51: fix warning in net/netfilter/ipvs/ip_vs_ctl.c
  2281d27: fix warning in drivers/net/atlx/atl2.c
  b5a7c2b: fix warning in net/netfilter/nf_conntrack_proto_tcp.c
  822c18d: fix warning in drivers/net/wireless/iwlwifi/iwl-scan.c
  69f38f6: fix warning in drivers/net/depca.c
  557073e: fix warning in drivers/net/3c523.c
  d138e44: drivers/net/wireless/b43/phy_g.c: type check debug printouts
  7e4f788: fix warning in drivers/net/sky2.c
  deb797f: fix warning in net/sunrpc/svcauth_unix.c
  923a5a9: fix warning in security/selinux/netnode.c
  c62cda5: fix warning in net/packet/af_packet.c
  d581867: fix warning in net/rfkill/rfkill.c

Note that the reason there's so many annotations is that this a full 
range of fixes for allyes/allno/allmod and randconfig kernels on x86. 
That's a lot of build configurations and a lot of warnings to 
annotate.

Another one of them is a real bugfix:

  742cddc: fix error path in drivers/net/mlx4/en_rx.c

these are side products of -tip's -Werror testing, i.e. not merged 
anywhere in the direction of linux-next or -git (obviously).

They are done mainly so that we can notice the warnings we introduce 
via any of the -tip trees - but we analyze and look at all other types 
of upstream kernel warnings as well.

I'll thus keep these commits indefinitely - but if someone from the 
networking side would like to work with us to pick them up and 
eventually nurse them upstream, that would be great!

One thing is not really feasible: there's just too many of them for me 
to spend 10 minutes on each to submit them with a proper Cc:, etc. 
(such overhead mounts up quickly if you do the numbers)

So i've attached them below as a dump of patches. If someone wants to 
cherry-pick bits of them, they are also available in 
tip/auto-warnings-next:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git auto-warnings-next

Warning: some of them might be bad, so please double check the 
analysis.

	Ingo

-------------->
commit d94b43b196712688c7b018edd69a4ca1650f61e0
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 12:55:10 2008 +0100

    fix warning in drivers/net/s2io.c
    
    this warning:
    
      drivers/net/s2io.c: In function ‘rx_intr_handler’:
      drivers/net/s2io.c:7369: warning: ‘lro’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between:
    
     - s2io_club_tcp_session()and 'lro'
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 6a1375f..a150575 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -7366,7 +7366,7 @@ static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp)
 	int ring_no = ring_data->ring_no;
 	u16 l3_csum, l4_csum;
 	unsigned long long err = rxdp->Control_1 & RXD_T_CODE;
-	struct lro *lro;
+	struct lro *uninitialized_var(lro);
 	u8 err_mask;
 
 	skb->dev = dev;

commit 78f065dd3b7f8116dafc7eb6bf966e8276580c15
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 12:58:10 2008 +0100

    fix warnings in drivers/net/niu.c
    
    these warnings:
    
      drivers/net/niu.c: In function ‘serdes_init_niu_1g_serdes’:
      drivers/net/niu.c:451: warning: ‘sig’ may be used uninitialized in this function
      drivers/net/niu.c: In function ‘serdes_init_niu_10g_serdes’:
      drivers/net/niu.c:550: warning: ‘sig’ may be used uninitialized in this function
    
    triggers because GCC does not recognize that the max_retry loop
    always initializes 'sig', due to max_retry != 0.
    
    Annotate them.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index afa399c..7e25142 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -448,7 +448,7 @@ static int serdes_init_niu_1g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u16 pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 sig, mask, val;
+	u64 uninitialized_var(sig), mask, val;
 	u32 tx_cfg, rx_cfg;
 	unsigned long i;
 	int err;
@@ -547,7 +547,7 @@ static int serdes_init_niu_10g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u32 tx_cfg, rx_cfg, pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 sig, mask, val;
+	u64 uninitialized_var(sig), mask, val;
 	unsigned long i;
 	int err;
 

commit 9cc0c65af74e02da2c3d621cb061bd61b64cc24e
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 12:54:50 2008 +0100

    fix warning in drivers/net/niu.c
    
    this warning:
    
      drivers/net/niu.c: In function ‘esr_reset’:
      drivers/net/niu.c:741: warning: ‘reset’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between:
    
     - esr_read_reset() and 'reset'
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 1b6f548..afa399c 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -738,7 +738,7 @@ static int esr_write_glue0(struct niu *np, unsigned long chan, u32 val)
 
 static int esr_reset(struct niu *np)
 {
-	u32 reset;
+	u32 uninitialized_var(reset);
 	int err;
 
 	err = mdio_write(np, np->port, NIU_ESR_DEV_ADDR,

commit 32fd3b535aa43e290c33873124f91fec6a4329f7
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 12:37:40 2008 +0100

    fix warning in drivers/net/qla3xxx.c
    
    this warning:
    
      drivers/net/qla3xxx.c: In function ‘ql3xxx_probe’:
      drivers/net/qla3xxx.c:3912: warning: ‘pci_using_dac’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between 'pci_using_dac' and 'err'.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index 508452c..3ae623e 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -3909,7 +3909,7 @@ static int __devinit ql3xxx_probe(struct pci_dev *pdev,
 	struct net_device *ndev = NULL;
 	struct ql3_adapter *qdev = NULL;
 	static int cards_found = 0;
-	int pci_using_dac, err;
+	int uninitialized_var(pci_using_dac), err;
 
 	err = pci_enable_device(pdev);
 	if (err) {

commit ba58621694ef08b59b753bc5042b3db9472c5aff
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 12:03:21 2008 +0100

    fix warning in net/sunrpc/xprtrdma/svc_rdma_transport.c
    
    this warning:
    
      net/sunrpc/xprtrdma/svc_rdma_transport.c: In function ‘svc_rdma_accept’:
      net/sunrpc/xprtrdma/svc_rdma_transport.c:830: warning: ‘dma_mr_acc’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) flow connection
    between need_dma_mr and dma_mr_acc.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 6fb493c..636095c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -827,7 +827,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	struct rdma_conn_param conn_param;
 	struct ib_qp_init_attr qp_attr;
 	struct ib_device_attr devattr;
-	int dma_mr_acc;
+	int uninitialized_var(dma_mr_acc);
 	int need_dma_mr;
 	int ret;
 	int i;

commit b91eb990a0d839e810bb15048af08a69ab1b6ffe
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 12:03:12 2008 +0100

    fix warning in net/sched/sch_hfsc.c
    
    this warning:
    
      net/sched/sch_hfsc.c: In function ‘hfsc_enqueue’:
      net/sched/sch_hfsc.c:1577: warning: ‘err’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between hfsc_classify(), 'cl' and 'err'.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index c1e77da..b39e3b5 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1574,7 +1574,7 @@ static int
 hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 {
 	struct hfsc_class *cl;
-	int err;
+	int uninitialized_var(err);
 
 	cl = hfsc_classify(skb, sch, &err);
 	if (cl == NULL) {

commit c390a3784564c1fb2183e4a31ea39a9beb47d034
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 11:31:28 2008 +0100

    fix warning in net/netfilter/nf_conntrack_ftp.c
    
    this warning:
    
      net/netfilter/nf_conntrack_ftp.c: In function ‘help’:
      net/netfilter/nf_conntrack_ftp.c:360: warning: ‘matchoff’ may be used uninitialized in this function
      net/netfilter/nf_conntrack_ftp.c:360: warning: ‘matchlen’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between find_pattern(), 'found', 'matchoff' and 'matchlen'.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 4f71071..af7ad91 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -357,7 +357,7 @@ static int help(struct sk_buff *skb,
 	int ret;
 	u32 seq;
 	int dir = CTINFO2DIR(ctinfo);
-	unsigned int matchlen, matchoff;
+	unsigned int uninitialized_var(matchlen), uninitialized_var(matchoff);
 	struct nf_ct_ftp_master *ct_ftp_info = &nfct_help(ct)->help.ct_ftp_info;
 	struct nf_conntrack_expect *exp;
 	union nf_inet_addr *daddr;
@@ -592,3 +592,4 @@ static int __init nf_conntrack_ftp_init(void)
 
 module_init(nf_conntrack_ftp_init);
 module_exit(nf_conntrack_ftp_fini);
+

commit 8fecea67aa434dd1653c4a275532e29903caeb88
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 11:31:20 2008 +0100

    fix warning in net/ipv6/ip6_flowlabel.c
    
    this warning:
    
      net/ipv6/ip6_flowlabel.c: In function ‘ipv6_flowlabel_opt’:
      net/ipv6/ip6_flowlabel.c:467: warning: ‘err’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between fl_create() and 'err'.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 37a4e77..62809ec 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -464,7 +464,7 @@ static inline void fl_link(struct ipv6_pinfo *np, struct ipv6_fl_socklist *sfl,
 
 int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
 {
-	int err;
+	int uninitialized_var(err);
 	struct net *net = sock_net(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct in6_flowlabel_req freq;

commit 67230f214ec140d07fcd32535841ee6eb4437364
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 11:31:12 2008 +0100

    fix warning in net/dsa/mv88e6xxx.c
    
    this warning:
    
      net/dsa/mv88e6xxx.c: In function ‘mv88e6xxx_poll_link’:
      net/dsa/mv88e6xxx.c:361: warning: ‘port_status’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between 'link' and 'port_status'.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/dsa/mv88e6xxx.c b/net/dsa/mv88e6xxx.c
index aa6c609..4e4d8b5 100644
--- a/net/dsa/mv88e6xxx.c
+++ b/net/dsa/mv88e6xxx.c
@@ -358,7 +358,7 @@ void mv88e6xxx_poll_link(struct dsa_switch *ds)
 
 	for (i = 0; i < DSA_MAX_PORTS; i++) {
 		struct net_device *dev;
-		int port_status;
+		int uninitialized_var(port_status);
 		int link;
 		int speed;
 		int duplex;

commit 948158e35984f86e565db303e0f026e536edca85
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 11:31:04 2008 +0100

    fix warning in net/dsa/mv88e6060.c
    
    this warning:
    
      net/dsa/mv88e6060.c: In function ‘mv88e6060_poll_link’:
      net/dsa/mv88e6060.c:225: warning: ‘port_status’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between 'link' and 'port_status'.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/dsa/mv88e6060.c b/net/dsa/mv88e6060.c
index 54068ef..bfb4a64 100644
--- a/net/dsa/mv88e6060.c
+++ b/net/dsa/mv88e6060.c
@@ -222,7 +222,7 @@ static void mv88e6060_poll_link(struct dsa_switch *ds)
 
 	for (i = 0; i < DSA_MAX_PORTS; i++) {
 		struct net_device *dev;
-		int port_status;
+		int uninitialized_var(port_status);
 		int link;
 		int speed;
 		int duplex;

commit 8574b3b4834c740d37d6eb2d6839037779b56da4
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 11:30:57 2008 +0100

    fix warning in fs/dlm/netlink.c
    
    this warning:
    
      fs/dlm/netlink.c: In function ‘dlm_timeout_warn’:
      fs/dlm/netlink.c:131: warning: ‘send_skb’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between prepare_data() and send_skb.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 18bda83..aa2a577 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -127,8 +127,8 @@ static void fill_data(struct dlm_lock_data *data, struct dlm_lkb *lkb)
 
 void dlm_timeout_warn(struct dlm_lkb *lkb)
 {
+	struct sk_buff *uninitialized_var(send_skb);
 	struct dlm_lock_data *data;
-	struct sk_buff *send_skb;
 	size_t size;
 	int rv;
 

commit 9b9c8fde6c9d175bb7a108e3d231626984364451
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 11:30:15 2008 +0100

    fix warning in drivers/net/sis900.c
    
    this warning:
    
      drivers/net/sis900.c: In function ‘sis900_timer’:
      drivers/net/sis900.c:1280: warning: ‘speed’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between sis900_read_mode(), 'speed' and 'duplex'.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index fa3a460..8be433e 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -1277,7 +1277,7 @@ static void sis900_timer(unsigned long data)
 	u16 status;
 
 	if (!sis_priv->autong_complete){
-		int speed, duplex = 0;
+		int uninitialized_var(speed), duplex = 0;
 
 		sis900_read_mode(net_dev, &speed, &duplex);
 		if (duplex){

commit 924a289446dadc9c3c9896c87446e0403c746537
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 10:38:24 2008 +0100

    fix warning in drivers/net/wireless/iwlwifi/iwl-3945.c
    
    this warning:
    
      drivers/net/wireless/iwlwifi/iwl-3945.c: In function ‘iwl3945_txpower_set_from_eeprom’:
      drivers/net/wireless/iwlwifi/iwl-3945.c:2182: warning: ‘power_idx’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between iwl3945_hw_reg_get_matched_power_index() and power_idx.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7ca5627..e9e0b1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2179,7 +2179,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv)
 		/* set tx power value for all OFDM rates */
 		for (rate_index = 0; rate_index < IWL_OFDM_RATES;
 		     rate_index++) {
-			s32 power_idx;
+			s32 uninitialized_var(power_idx);
 			int rc;
 
 			/* use channel group's clip-power table,

commit 22672393d84dc3c74b7cd46eebdb44d43747318b
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 10:38:08 2008 +0100

    fix warning in drivers/net/wireless/b43/main.c
    
    this warning:
    
      drivers/net/wireless/b43/main.c: In function ‘b43_op_config’:
      drivers/net/wireless/b43/main.c:3258: warning: ‘gmode’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between the list_for_each_entry() loop, up_dev and gmode.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 14c44df..bd70b27 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3255,7 +3255,7 @@ static int b43_switch_band(struct b43_wl *wl, struct ieee80211_channel *chan)
 	struct b43_wldev *down_dev;
 	struct b43_wldev *d;
 	int err;
-	bool gmode;
+	bool uninitialized_var(gmode);
 	int prev_status;
 
 	/* Find a device and PHY which supports the band. */

commit de965062d615afc885bd800976e488bd3c2d1d6f
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 10:37:58 2008 +0100

    fix warning in drivers/net/wireless/ath9k/rc.c
    
    this warning:
    
      drivers/net/wireless/ath9k/rc.c: In function ‘ath_rc_rate_getidx’:
      drivers/net/wireless/ath9k/rc.c:1033: warning: ‘nextindex’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between ath_rc_get_nextlowervalid_txrate() and &nextindex.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index cca2fc5..27b35d3 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1030,7 +1030,7 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 			     u16 min_rate)
 {
 	u32 j;
-	u8 nextindex;
+	u8 uninitialized_var(nextindex);
 	struct ath_tx_ratectrl *rate_ctrl =
 		(struct ath_tx_ratectrl *)(ath_rc_priv);
 

commit e5e5492e7094ed4bea8daf0302f60fbb21daa4c7
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 14:52:20 2008 +0100

    fix warning in drivers/net/wan/z85230.c
    
    this warning:
    
      drivers/net/wan/z85230.c: In function ‘z8530_interrupt’:
      drivers/net/wan/z85230.c:713: warning: ‘intr’ may be used uninitialized in this function
    
    is clearly bogus - annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 5bf7e01..d7bf53a 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -710,7 +710,7 @@ EXPORT_SYMBOL(z8530_nop);
 irqreturn_t z8530_interrupt(int irq, void *dev_id)
 {
 	struct z8530_dev *dev=dev_id;
-	u8 intr;
+	u8 uninitialized_var(intr);
 	static volatile int locker=0;
 	int work=0;
 	struct z8530_irqhandler *irqs;

commit 742cddc749294be3c0fa909e6255c5a338a1ac40
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 10:37:47 2008 +0100

    fix error path in drivers/net/mlx4/en_rx.c
    
    this warning:
    
      drivers/net/mlx4/en_rx.c: In function ‘mlx4_en_activate_rx_rings’:
      drivers/net/mlx4/en_rx.c:412: warning: ‘err’ may be used uninitialized in this function
    
    Triggers because 'err' is uninitialized in the following input
    conditions: priv->rx_ring_num is zero and mlx4_en_fill_rx_buffers()
    fails.
    
    But even if ->rx_ring_num is nonzero, 'err' will be zero if
    mlx4_en_fill_rx_buffers() fails and mlx4_en_activate_rx_rings() returns
    success - incorrectly.
    
    So it's best to keep the error code uptodate on mlx4_en_fill_rx_buffers()
    calls as well.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
index 6232227..aed7739 100644
--- a/drivers/net/mlx4/en_rx.c
+++ b/drivers/net/mlx4/en_rx.c
@@ -443,7 +443,8 @@ int mlx4_en_activate_rx_rings(struct mlx4_en_priv *priv)
 		/* Fill Rx buffers */
 		ring->full = 0;
 	}
-	if (mlx4_en_fill_rx_buffers(priv))
+	err = mlx4_en_fill_rx_buffers(priv);
+	if (err)
 		goto err_buffers;
 
 	for (ring_ind = 0; ring_ind < priv->rx_ring_num; ring_ind++) {

commit 181787d1c30af364ffd15428fe6fab7798c3f3c1
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 10:37:35 2008 +0100

    fix warning in drivers/net/cassini.c
    
    this warning:
    
      drivers/net/cassini.c: In function ‘cas_rx_ringN’:
      drivers/net/cassini.c:2350: warning: ‘skb’ may be used uninitialized in this function
    
    triggers because GCC does not recognize the (correct) error flow
    between cas_rx_process_pkt() and 'skb'.
    
    Annotate it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 86909cf..e083e1c 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -2347,7 +2347,7 @@ static int cas_rx_ringN(struct cas *cp, int ring, int budget)
 	drops = 0;
 	while (1) {
 		struct cas_rx_comp *rxc = rxcs + entry;
-		struct sk_buff *skb;
+		struct sk_buff *uninitialized_var(skb);
 		int type, len;
 		u64 words[4];
 		int i, dring;

commit 96c79254264033f1505198d5d362b68d88d1bbaf
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 12:41:30 2008 +0200

    fix warning in net/dccp/options.c
    
    this warning:
    
      net/dccp/options.c: In function ‘dccp_parse_options’:
      net/dccp/options.c:67: warning: ‘value’ may be used uninitialized in this function
    
    is a bogus GCC warning. The compiler does not recognize the relation
    between "value" and "mandatory" variables: the code flow can ever reach
    the "out_invalid_option:" label if 'mandatory' is set to 1, and when
    'mandatory' is non-zero, we'll always have 'value' initialized.
    
    Help out the compiler by annotating the variable.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/dccp/options.c b/net/dccp/options.c
index 0809b63..18dcfb9 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -64,7 +64,7 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 					(dh->dccph_doff * 4);
 	struct dccp_options_received *opt_recv = &dp->dccps_options_received;
 	unsigned char opt, len;
-	unsigned char *value;
+	unsigned char *uninitialized_var(value);
 	u32 elapsed_time;
 	__be32 opt_val;
 	int rc;

commit 193e56a10e56505dc7eac9e5632834c72b55613d
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Aug 18 16:18:34 2008 +0200

    fix warning in drivers/net/mlx4/mcg.c
    
    fix warning:
    
      drivers/net/mlx4/mcg.c: In function ‘mlx4_multicast_attach’:
      drivers/net/mlx4/mcg.c:217: warning: integer overflow in expression
    
    there was no real danger of overflow here though.
    
    md5:
       db8eb55620f886c03854a2abb2ce6c3f  mcg.o.before.asm
       db8eb55620f886c03854a2abb2ce6c3f  mcg.o.after.asm
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index 592c01a..224ef0f 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -215,7 +215,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 
 	if (block_mcast_loopback)
 		mgm->qp[members_count++] = cpu_to_be32((qp->qpn & MGM_QPN_MASK) |
-						       (1 << MGM_BLCK_LB_BIT));
+						       (1U << MGM_BLCK_LB_BIT));
 	else
 		mgm->qp[members_count++] = cpu_to_be32(qp->qpn & MGM_QPN_MASK);
 

commit bcc35f75a3b9b96c53a74176b135304fc7ffe052
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 15:49:15 2008 +0200

    fix warning in net/ax25/sysctl_net_ax25.c
    
    fix this warning:
    
      net/ax25/sysctl_net_ax25.c:27: warning: ‘min_ds_timeout’ defined but not used
      net/ax25/sysctl_net_ax25.c:27: warning: ‘max_ds_timeout’ defined but not used
    
    These are only used in the CONFIG_AX25_DAMA_SLAVE case.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/ax25/sysctl_net_ax25.c b/net/ax25/sysctl_net_ax25.c
index f288fc4..735ceef 100644
--- a/net/ax25/sysctl_net_ax25.c
+++ b/net/ax25/sysctl_net_ax25.c
@@ -24,7 +24,9 @@ static int min_idle[1],			max_idle[] = {65535000};
 static int min_n2[] = {1},		max_n2[] = {31};
 static int min_paclen[] = {1},		max_paclen[] = {512};
 static int min_proto[1],		max_proto[] = { AX25_PROTO_MAX };
+#ifdef CONFIG_AX25_DAMA_SLAVE
 static int min_ds_timeout[1],		max_ds_timeout[] = {65535000};
+#endif
 
 static struct ctl_table_header *ax25_table_header;
 

commit 59681c6c30e3f700af8d716f66e41ad18f726b80
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Oct 20 18:50:11 2008 +0200

    fix warning in net/sunrpc/xprtrdma/verbs.c
    
    fix this warning:
    
      net/sunrpc/xprtrdma/verbs.c: In function ‘rpcrdma_conn_upcall’:
      net/sunrpc/xprtrdma/verbs.c:279: warning: unused variable ‘addr’
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index a5fef5e..900e595 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -276,7 +276,9 @@ rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
 	struct rpcrdma_xprt *xprt = id->context;
 	struct rpcrdma_ia *ia = &xprt->rx_ia;
 	struct rpcrdma_ep *ep = &xprt->rx_ep;
+#ifdef RPC_DEBUG
 	struct sockaddr_in *addr = (struct sockaddr_in *) &ep->rep_remote_addr;
+#endif
 	struct ib_qp_attr attr;
 	struct ib_qp_init_attr iattr;
 	int connstate = 0;

commit ad8d03b315507a954160fcf04dc94cef9f118e77
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Oct 20 17:34:02 2008 +0200

    fix warning in net/bluetooth/rfcomm/sock.c
    
    fix this warning:
    
      net/bluetooth/rfcomm/sock.c: In function ‘rfcomm_sock_ioctl’:
      net/bluetooth/rfcomm/sock.c:795: warning: unused variable ‘sk’
    
    perhaps BT_DEBUG() should be improved to do printf format checking
    instead of the #ifdef, but that looks quite intrusive: each bluetooth
    .c file undefines the macro.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 8a972b6..bc0d4a7 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -792,7 +792,9 @@ static int rfcomm_sock_getsockopt(struct socket *sock, int level, int optname, c
 
 static int rfcomm_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
+#if defined(CONFIG_BT_RFCOMM_TTY) || defined(CONFIG_BT_RFCOMM_DEBUG)
 	struct sock *sk = sock->sk;
+#endif
 	int err;
 
 	BT_DBG("sk %p cmd %x arg %lx", sk, cmd, arg);

commit 320451a3f79098ca800f2e58674074c26efee020
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Oct 18 21:33:06 2008 +0200

    fix warning in drivers/net/wireless/ray_cs.c
    
    fix this warning:
    
      drivers/net/wireless/ray_cs.c:297: warning: ‘rcsid’ defined but not used
    
    'rcsid' is only used in the CONFIG_PROC_FS=y case.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 1404a57..c23a811 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -294,7 +294,9 @@ static char hop_pattern_length[] = { 1,
 	     JAPAN_TEST_HOP_MOD
 };
 
+#ifdef CONFIG_PROC_FS
 static char rcsid[] = "Raylink/WebGear wireless LAN - Corey <Thomas corey@world.std.com>";
+#endif
 
 /*=============================================================================
     ray_attach() creates an "instance" of the driver, allocating

commit decc1656e870c9e5bd94f2357b8496b8da6c2e73
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Oct 18 19:14:40 2008 +0200

    fix warning in net/netfilter/nf_conntrack_proto_sctp.c
    
    fix this warning:
    
      net/netfilter/nf_conntrack_proto_sctp.c: In function ‘sctp_packet’:
      net/netfilter/nf_conntrack_proto_sctp.c:376: warning: array subscript is above array bounds
    
    GCC noticed that new_state could in theory be SCTP_CONNTRACK_MAX,
    which is beyond the limit of the sctp_timeouts[] array.
    
    This situation could happen if for_each_sctp_chunk() exits immediately.
    That should not normally happen - but it's not obvious to me and it's
    better to insert an extra check to the end of the loop for this case.
    
    This gets rid of warning as well.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index ae8c260..d31ced4 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -373,6 +373,9 @@ static int sctp_packet(struct nf_conn *ct,
 	}
 	write_unlock_bh(&sctp_lock);
 
+	if (new_state == SCTP_CONNTRACK_MAX)
+		goto out;
+
 	nf_ct_refresh_acct(ct, ctinfo, skb, sctp_timeouts[new_state]);
 
 	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&

commit b547d51a26c5ed23571df50c7254439e2f5dbebe
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Oct 18 19:02:37 2008 +0200

    fix warning in net/netfilter/ipvs/ip_vs_ctl.c
    
    Impact: fix potential kernel stack information exposure to user-space.
    
    fix this warning:
    
      net/netfilter/ipvs/ip_vs_ctl.c: In function ‘ip_vs_genl_set_cmd’:
      net/netfilter/ipvs/ip_vs_ctl.c:3034: warning: ‘t.udp_timeout’ may be used uninitialized in this function
      net/netfilter/ipvs/ip_vs_ctl.c:3034: note: ‘t.udp_timeout’ was declared here
    
    GCC seems to be correct here: in the !CONFIG_IP_VS_PROTO_UDP case
    __ip_vs_get_timeouts keeps the timeout structure uninitialized. But
    in a couple of places we use and copy this structure to user-space,
    potentially exposing kernel-stack data to user-space.
    
    While it's a minor issue that only triggers with certain config variations,
    it's best to always initialize this structure in __ip_vs_get_timeouts().
    (GCC will eliminate this memset)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 0302cf3..7e3a0c7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2327,6 +2327,7 @@ __ip_vs_get_dest_entries(const struct ip_vs_get_dests *get,
 static inline void
 __ip_vs_get_timeouts(struct ip_vs_timeout_user *u)
 {
+	memset(u, 0, sizeof(*u));
 #ifdef CONFIG_IP_VS_PROTO_TCP
 	u->tcp_timeout =
 		ip_vs_protocol_tcp.timeout_table[IP_VS_TCP_S_ESTABLISHED] / HZ;

commit 2281d27663a5f17689ec49e029b4962cba19d614
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Oct 18 16:27:37 2008 +0200

    fix warning in drivers/net/atlx/atl2.c
    
    fix this warning:
    
      drivers/net/atlx/atl2.c: In function ‘atl2_request_irq’:
      drivers/net/atlx/atl2.c:644: warning: unused variable ‘err’
    
    'err' is unused in the !CONFIG_PCI_MSI case.
    
    Instead of further increasing the #ifdeffery in this function,
    restructure the code a bit and get rid of the #ifdef. This
    relies on the fact that pci_enable_msi() will always fail in
    the !CONFIG_PCI_MSI case.
    
    There should be no change in driver behavior.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index 8571e8c..e02bd7e 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -644,7 +644,6 @@ static int atl2_request_irq(struct atl2_adapter *adapter)
 	int flags, err = 0;
 
 	flags = IRQF_SHARED;
-#ifdef CONFIG_PCI_MSI
 	adapter->have_msi = true;
 	err = pci_enable_msi(adapter->pdev);
 	if (err)
@@ -652,7 +651,6 @@ static int atl2_request_irq(struct atl2_adapter *adapter)
 
 	if (adapter->have_msi)
 		flags &= ~IRQF_SHARED;
-#endif
 
 	return request_irq(adapter->pdev->irq, &atl2_intr, flags, netdev->name,
 		netdev);

commit b5a7c2b9e1a1b4d80da5d66b330545fdeafe1dad
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 19:48:51 2008 +0200

    fix warning in net/netfilter/nf_conntrack_proto_tcp.c
    
    fix this warning:
    
      net/netfilter/nf_conntrack_proto_tcp.c: In function ‘tcp_in_window’:
      net/netfilter/nf_conntrack_proto_tcp.c:491: warning: unused variable ‘net’
      net/netfilter/nf_conntrack_proto_tcp.c: In function ‘tcp_packet’:
      net/netfilter/nf_conntrack_proto_tcp.c:812: warning: unused variable ‘net’
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 7f2f43c..debdaf7 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -129,7 +129,7 @@ extern const struct nla_policy nf_ct_port_nla_policy[];
 	 && net_ratelimit())
 #endif
 #else
-#define LOG_INVALID(net, proto) 0
+static inline int LOG_INVALID(struct net *net, int proto) { return 0; }
 #endif /* CONFIG_SYSCTL */
 
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/

commit 822c18db871bc88b2a60d7a9618ec79a8b5e1ef5
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 18:31:33 2008 +0200

    fix warning in drivers/net/wireless/iwlwifi/iwl-scan.c
    
    fix this warning:
    
      drivers/net/wireless/iwlwifi/iwl-scan.c:92: warning: ‘iwl_escape_essid’ defined but not used
    
    Convert the IWL debug macros to proper printf format checking.
    Besides better type checking, this gets rid of the warning as well.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index e548d67..ddc1fbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -68,8 +68,10 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
 #endif
 
 #else
-#define IWL_DEBUG(level, fmt, args...)
-#define IWL_DEBUG_LIMIT(level, fmt, args...)
+static inline void __attribute__ ((format(printf, 2, 3)))
+IWL_DEBUG(int level, const char *fmt, ...) { }
+static inline void __attribute__ ((format(printf, 2, 3)))
+IWL_DEBUG_LIMIT(int level, const char *fmt, ...) { }
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 4eee1b1..f4f0664 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -43,7 +43,6 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
 static const char *led_type_str[] = {
 	__stringify(IWL_LED_TRG_TX),
 	__stringify(IWL_LED_TRG_RX),
@@ -51,7 +50,6 @@ static const char *led_type_str[] = {
 	__stringify(IWL_LED_TRG_RADIO),
 	NULL
 };
-#endif /* CONFIG_IWLWIFI_DEBUG */
 
 
 static const struct {

commit 69f38f617c3f832e088be9d35242d929aa623fd4
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Aug 27 19:06:48 2008 +0200

    fix warning in drivers/net/depca.c
    
    fix warning:
    
      drivers/net/depca.c: In function ‘depca_eisa_probe’:
      drivers/net/depca.c:1564: warning: ‘mem_start’ may be used uninitialized in this function
    
    this seems to be a real bug - depca_eisa_probe() does not check
    for failure. Add it, symmetric to depca_isa_probe().
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index ace39ec..f00bd64 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -1558,6 +1558,7 @@ static int __init depca_isa_probe (struct platform_device *device)
 #ifdef CONFIG_EISA
 static int __init depca_eisa_probe (struct device *device)
 {
+	enum depca_type adapter = unknown;
 	struct eisa_device *edev;
 	struct net_device *dev;
 	struct depca_private *lp;
@@ -1576,7 +1577,11 @@ static int __init depca_eisa_probe (struct device *device)
 	 * the EISA configuration structures (yet... :-), just rely on
 	 * the ISA probing to sort it out... */
 
-	depca_shmem_probe (&mem_start);
+	adapter = depca_shmem_probe (&mem_start);
+	if (adapter == unknown) {
+		status = -ENODEV;
+		goto out_free;
+	}
 
 	dev->base_addr = ioaddr;
 	dev->irq = irq;

commit 557073e3dac7b8479df69c140a5fd2b8f4a9cfad
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Aug 27 19:05:19 2008 +0200

    fix warning in drivers/net/3c523.c
    
    fix warning:
    
      drivers/net/3c523.c:582: warning: ‘cleanup_card’ defined but not used
    
    No code changed:
    
    md5:
       ebe4a1b27d3f21b0b12a78c58463b0d7  3c523.o.before.asm
       ebe4a1b27d3f21b0b12a78c58463b0d7  3c523.o.after.asm
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/3c523.c b/drivers/net/3c523.c
index e2ce41d..7b9d427 100644
--- a/drivers/net/3c523.c
+++ b/drivers/net/3c523.c
@@ -578,13 +578,13 @@ err_out:
 	return retval;
 }
 
+#ifdef MODULE
 static void cleanup_card(struct net_device *dev)
 {
 	mca_set_adapter_procfn(((struct priv *) (dev->priv))->slot, NULL, NULL);
 	release_region(dev->base_addr, ELMC_IO_EXTENT);
 }
-
-#ifndef MODULE
+#else
 struct net_device * __init elmc_probe(int unit)
 {
 	struct net_device *dev = alloc_etherdev(sizeof(struct priv));

commit d138e44e2f8d0f26e04b0386d328d9cc7e33d82e
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 14:30:37 2008 +0200

    drivers/net/wireless/b43/phy_g.c: type check debug printouts
    
    this warning:
    
      drivers/net/wireless/b43/phy_g.c: In function ‘b43_gphy_op_recalc_txpower’:
      drivers/net/wireless/b43/phy_g.c:3191: warning: unused variable ‘dbm’
    
    is caused because b43dbg() is a macro, hence in the !B43_DEBUG
    case the compiler does not know that the variables are used.
    
    Convert it to a proper inline instead. This also improves type checking
    in the !B43_DEBUG case.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 427b820..ac55b62 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -853,7 +853,8 @@ void b43warn(struct b43_wl *wl, const char *fmt, ...)
 void b43dbg(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 #else /* DEBUG */
-# define b43dbg(wl, fmt...) do { /* nothing */ } while (0)
+static inline void __attribute__ ((format(printf, 2, 3)))
+b43dbg(struct b43_wl *wl, const char *fmt, ...) { }
 #endif /* DEBUG */
 
 /* A WARN_ON variant that vanishes when b43 debugging is disabled.

commit 7e4f7889aca92f2cf95ba31e005fc1368c1cbc5a
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 17:47:04 2008 +0200

    fix warning in drivers/net/sky2.c
    
    fix this warning:
    
      drivers/net/sky2.c: In function ‘sky2_mhz’:
      drivers/net/sky2.c:2753: warning: control reaches end of non-void function
    
    BUG() can be NOP on !CONFIG_BUG.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 3813d15..85fdacc 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2748,7 +2748,7 @@ static u32 sky2_mhz(const struct sky2_hw *hw)
 		return 156;
 
 	default:
-		BUG();
+		panic("sky2_mhz: unknown chip id!");
 	}
 }
 

commit deb797f96d920083ba8a0bcfa6f57b19fc593571
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 17:34:27 2008 +0200

    fix warning in net/sunrpc/svcauth_unix.c
    
    fix this warning:
    
      net/sunrpc/svcauth_unix.c: In function ‘svcauth_unix_set_client’:
      net/sunrpc/svcauth_unix.c:681: warning: ‘sin6’ may be used uninitialized in this function
    
    caused by BUG() being a NOP on !CONFIG_BUG.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index f24800f..200ed93 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -692,7 +692,7 @@ svcauth_unix_set_client(struct svc_rqst *rqstp)
 		sin6 = svc_addr_in6(rqstp);
 		break;
 	default:
-		BUG();
+		panic("svcauth_unix_set_client: bad address family!");
 	}
 
 	rqstp->rq_client = NULL;
@@ -873,3 +873,4 @@ struct auth_ops svcauth_unix = {
 	.set_client	= svcauth_unix_set_client,
 };
 
+

commit 923a5a960577dcc5189b6113300a122c0212b292
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 16:55:34 2008 +0200

    fix warning in security/selinux/netnode.c
    
    fix this warning:
    
      security/selinux/netnode.c: In function ‘sel_netnode_find’:
      security/selinux/netnode.c:131: warning: ‘idx’ may be used uninitialized in this function
    
    BUG() can be a NOP in the !CONFIG_BUG case. Return NULL in that case,
    instead of running in an undefined way.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 7100072..a307122 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -140,6 +140,7 @@ static struct sel_netnode *sel_netnode_find(const void *addr, u16 family)
 		break;
 	default:
 		BUG();
+		return NULL;
 	}
 
 	list_for_each_entry_rcu(node, &sel_netnode_hash[idx].list, list)

commit c62cda5dfaf7630edefe097a3e23af7732060b08
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 16:26:02 2008 +0200

    fix warning in net/packet/af_packet.c
    
    fix this warning:
    
      net/packet/af_packet.c: In function ‘tpacket_rcv’:
      net/packet/af_packet.c:604: warning: ‘hdrlen’ may be used uninitialized in this function
    
    This is because in the !CONFIG_BUG case BUG() is a NOP.
    
    There is no other sane way to continue but to panic the system
    unconditionally, regardless of the CONFIG_BUG setting.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c718e7e..1478fb8 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -709,7 +709,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 		hdrlen = sizeof(*h.h2);
 		break;
 	default:
-		BUG();
+		panic("AF_PACKET: bad tp->version");
 	}
 
 	sll = h.raw + TPACKET_ALIGN(hdrlen);

commit d581867031ebe3c6f4e018ea32ed8b9ee5141ead
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 16:15:59 2008 +0200

    fix warning in net/rfkill/rfkill.c
    
    fix this warning:
    
      net/rfkill/rfkill.c: In function ‘rfkill_get_type_str’:
      net/rfkill/rfkill.c:393: warning: control reaches end of non-void function
    
    in the embedded !CONFIG_BUG case BUG() is a NOP.
    
    Return NULL to solve this (unlikely) scenario. All callers feed this
    pointer into sprintf %s so NULL should be fine.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index f949a48..eecb9a8 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -389,6 +389,7 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
 		return "wwan";
 	default:
 		BUG();
+		return NULL;
 	}
 }
 

