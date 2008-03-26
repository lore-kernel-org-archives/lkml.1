Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbYCZQxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbYCZQxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760880AbYCZQxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:53:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38084 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760860AbYCZQxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:53:06 -0400
Date: Wed, 26 Mar 2008 11:53:04 -0500
From: Dean Nelson <dcn@sgi.com>
To: jes@sgi.com, tony.luck@intel.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: [Patch 5/5] run drivers/misc/xp through scripts/checkpatch.pl -v2
Message-ID: <20080326165304.GF20663@sgi.com>
References: <20080326163823.GA25653@sgi.com>
MIME-Version: 1.0
Content-Type: application/x-perl
Content-Disposition: attachment; filename="checkpatch.pl"
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20080326163823.GA25653@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addressed issues raised by scripts/checkpatch.pl. Removed unnecessary curly=
=0Abraces.  Eliminated uses of volatiles and use of kernel_thread() and=0Ad=
aemonize().=0A=0ASigned-off-by: Dean Nelson <dcn@sgi.com>=0A=0A---=0A=0AThe=
re are still a few false positives from checkpatch.pl concerning=0AWARNING:=
 EXPORT_SYMBOL(foo); should immediately follow its function/variable=0A=0A =
drivers/misc/xp/xp_main.c       |   68 ++++------=0A drivers/misc/xp/xp_sn2=
=2Ec        |   23 +--=0A drivers/misc/xp/xp_uv.c         |    2=0A drivers=
/misc/xp/xpc.h           |  116 ++++++++---------=0A drivers/misc/xp/xpc_ch=
annel.c   |  243 +++++++++++++++---------------------=0A drivers/misc/xp/xp=
c_main.c      |  239 ++++++++++++-----------------------=0A drivers/misc/xp=
/xpc_partition.c |   78 ++++-------=0A drivers/misc/xp/xpnet.c         |   =
15 --=0A 8 files changed, 324 insertions(+), 460 deletions(-)=0A=0AIndex: l=
inux-2.6/drivers/misc/xp/xpnet.c=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=0A--- linux-2.6.orig/drivers/misc/xp/xpnet.c	2008-03-25 07:10:=
15.693148179 -0500=0A+++ linux-2.6/drivers/misc/xp/xpnet.c	2008-03-25 07:10=
:17.729402225 -0500=0A@@ -84,8 +84,8 @@ struct xpnet_message {=0A #define X=
PNET_VERSION_MAJOR(_v)		((_v) >> 4)=0A #define XPNET_VERSION_MINOR(_v)		((_=
v) & 0xf)=0A =0A-#define	XPNET_VERSION _XPNET_VERSION(1,0)	/* version 1.0 *=
/=0A-#define	XPNET_VERSION_EMBED _XPNET_VERSION(1,1)	/* version 1.1 */=0A+#=
define	XPNET_VERSION _XPNET_VERSION(1, 0)	/* version 1.0 */=0A+#define	XPNE=
T_VERSION_EMBED _XPNET_VERSION(1, 1)	/* version 1.1 */=0A #define XPNET_MAG=
IC	0x88786984	/* "XNET" */=0A =0A #define XPNET_VALID_MSG(_m)						     \=
=0A@@ -571,9 +571,8 @@ xpnet_init(void)=0A 	short partid;=0A 	int result =
=3D -ENOMEM;=0A =0A-	if (!is_shub() && !is_uv()) {=0A+	if (!is_shub() && !i=
s_uv())=0A 		return -ENODEV;=0A-	}=0A =0A 	dev_info(xpnet, "registering net=
work device %s\n", XPNET_DEVICE_NAME);=0A =0A@@ -583,9 +582,8 @@ xpnet_init=
(void)=0A 	 */=0A 	xpnet_device =3D alloc_netdev(sizeof(struct xpnet_dev_pr=
ivate),=0A 				    XPNET_DEVICE_NAME, ether_setup);=0A-	if (xpnet_device =
=3D=3D NULL) {=0A+	if (xpnet_device =3D=3D NULL)=0A 		return -ENOMEM;=0A-	}=
=0A =0A 	netif_carrier_off(xpnet_device);=0A =0A@@ -603,7 +601,7 @@ xpnet_i=
nit(void)=0A 	 * MAC addresses.  We chose the first octet of the MAC to be =
unlikely=0A 	 * to collide with any vendor's officially issued MAC.=0A 	 */=
=0A-	xpnet_device->dev_addr[0] =3D 0x02;	/* locally administered, no OUI */=
=0A+	xpnet_device->dev_addr[0] =3D 0x02;     /* locally administered, no OU=
I */=0A =0A 	partid =3D xp_partition_id;=0A =0A@@ -624,9 +622,8 @@ xpnet_in=
it(void)=0A 	xpnet_device->features =3D NETIF_F_NO_CSUM;=0A =0A 	result =3D=
 register_netdev(xpnet_device);=0A-	if (result !=3D 0) {=0A+	if (result !=
=3D 0)=0A 		free_netdev(xpnet_device);=0A-	}=0A =0A 	return result;=0A }=0A=
Index: linux-2.6/drivers/misc/xp/xpc_partition.c=0A=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A--- linux-2.6.orig/drivers/misc/xp/xpc_partit=
ion.c	2008-03-25 07:10:15.693148179 -0500=0A+++ linux-2.6/drivers/misc/xp/x=
pc_partition.c	2008-03-25 07:10:17.737403223 -0500=0A@@ -64,19 +64,19 @@ xp=
c_kmalloc_cacheline_aligned(size_t siz=0A {=0A 	/* see if kmalloc will give=
 us cachline aligned memory by default */=0A 	*base =3D kmalloc(size, flags=
);=0A-	if (*base =3D=3D NULL) {=0A+	if (*base =3D=3D NULL)=0A 		return NULL=
;=0A-	}=0A-	if ((u64)*base =3D=3D L1_CACHE_ALIGN((u64)*base)) {=0A+=0A+	if =
((u64)*base =3D=3D L1_CACHE_ALIGN((u64)*base))=0A 		return *base;=0A-	}=0A+=
=0A 	kfree(*base);=0A =0A 	/* nope, we'll have to do it ourselves */=0A 	*b=
ase =3D kmalloc(size + L1_CACHE_BYTES, flags);=0A-	if (*base =3D=3D NULL) {=
=0A+	if (*base =3D=3D NULL)=0A 		return NULL;=0A-	}=0A+=0A 	return (void *)=
L1_CACHE_ALIGN((u64)*base);=0A }=0A =0A@@ -103,9 +103,8 @@ xpc_get_rsvd_pag=
e_pa(int nasid)=0A 			"x, address=3D0x%016" U64_ELL "x len=3D0x%016lx\n", r=
et,=0A 			cookie, rp_pa, len);=0A =0A-		if (ret !=3D xpNeedMoreInfo) {=0A+	=
	if (ret !=3D xpNeedMoreInfo)=0A 			break;=0A-		}=0A =0A 		if (L1_CACHE_ALI=
GN(len) > buf_len) {=0A 			kfree(buf_base);=0A@@ -130,9 +129,9 @@ xpc_get_r=
svd_page_pa(int nasid)=0A =0A 	kfree(buf_base);=0A =0A-	if (ret !=3D xpSucc=
ess) {=0A+	if (ret !=3D xpSuccess)=0A 		rp_pa =3D 0;=0A-	}=0A+=0A 	dev_dbg(=
xpc_part, "reserved page at phys address 0x%016" U64_ELL "x\n",=0A 		rp_pa)=
;=0A 	return rp_pa;=0A@@ -195,7 +194,8 @@ xpc_rsvd_page_init(void)=0A 	 * t=
hat saved copy on subsequent loads of XPC. This AMO page is never=0A 	 * fr=
eed, and its memory protections are never restricted.=0A 	 */=0A-	if ((amos=
_page =3D xpc_vars->amos_page) =3D=3D NULL) {=0A+	amos_page =3D xpc_vars->a=
mos_page;=0A+	if (amos_page =3D=3D NULL) {=0A 		n_amos =3D xpc_number_of_am=
os(XP_NPARTITIONS);=0A 		amos_page =3D xp_alloc_amos(n_amos);=0A 		if (amos=
_page =3D=3D NULL) {=0A@@ -236,9 +236,8 @@ xpc_rsvd_page_init(void)=0A =0A =
	/* initialize the activate IRQ related AMO variables */=0A 	activate_irq_a=
mos =3D xpc_activate_irq_amos(XP_NPARTITIONS);=0A-	for (i =3D 0; i < xp_nas=
id_mask_words(); i++) {=0A+	for (i =3D 0; i < xp_nasid_mask_words(); i++)=
=0A 		(void)xpc_IPI_init(activate_irq_amos + i);=0A-	}=0A =0A 	/* initializ=
e the engaged remote partitions related AMO variables */=0A 	engaged_partit=
ions_amos =3D xpc_engaged_partitions_amos(XP_NPARTITIONS);=0A@@ -276,13 +27=
5,11 @@ xpc_check_remote_hb(void)=0A =0A 	for (partid =3D XP_MIN_PARTID; pa=
rtid <=3D XP_MAX_PARTID; partid++) {=0A =0A-		if (xpc_exiting) {=0A+		if (x=
pc_exiting)=0A 			break;=0A-		}=0A =0A-		if (partid =3D=3D xp_partition_id)=
 {=0A+		if (partid =3D=3D xp_partition_id)=0A 			continue;=0A-		}=0A =0A 		=
part =3D &xpc_partitions[partid];=0A =0A@@ -335,23 +332,20 @@ xpc_get_remot=
e_rp(int nasid, u64 *discov=0A 	/* get the reserved page's physical address=
 */=0A =0A 	*remote_rp_pa =3D xpc_get_rsvd_page_pa(nasid);=0A-	if (*remote_=
rp_pa =3D=3D 0) {=0A+	if (*remote_rp_pa =3D=3D 0)=0A 		return xpNoRsvdPageA=
ddr;=0A-	}=0A =0A 	/* pull over the reserved page header and part_nasids ma=
sk */=0A 	ret =3D xp_remote_memcpy(remote_rp, (void *)*remote_rp_pa,=0A 			=
       XPC_RP_HEADER_SIZE + xp_sizeof_nasid_mask);=0A-	if (ret !=3D xpSucce=
ss) {=0A+	if (ret !=3D xpSuccess)=0A 		return ret;=0A-	}=0A =0A 	if (discov=
ered_nasids !=3D NULL) {=0A 		u64 *remote_part_nasids =3D XPC_RP_PART_NASID=
S(remote_rp);=0A =0A-		for (i =3D 0; i < xp_nasid_mask_words(); i++) {=0A+	=
	for (i =3D 0; i < xp_nasid_mask_words(); i++)=0A 			discovered_nasids[i] |=
=3D remote_part_nasids[i];=0A-		}=0A 	}=0A =0A 	if (XPC_VERSION_MAJOR(remot=
e_rp->version) !=3D=0A@@ -373,16 +367,14 @@ xpc_get_remote_vars(u64 remote_=
vars_pa, =0A {=0A 	enum xp_retval ret;=0A =0A-	if (remote_vars_pa =3D=3D 0)=
 {=0A+	if (remote_vars_pa =3D=3D 0)=0A 		return xpVarsNotSet;=0A-	}=0A =0A =
	/* pull over the cross partition variables */=0A 	ret =3D xp_remote_memcpy=
(remote_vars, (void *)remote_vars_pa,=0A 			       XPC_RP_VARS_SIZE);=0A-	i=
f (ret !=3D xpSuccess) {=0A+	if (ret !=3D xpSuccess)=0A 		return ret;=0A-	}=
=0A =0A 	if (XPC_VERSION_MAJOR(remote_vars->version) !=3D=0A 	    XPC_VERSI=
ON_MAJOR(XPC_V_VERSION)) {=0A@@ -391,8 +383,9 @@ xpc_get_remote_vars(u64 re=
mote_vars_pa, =0A =0A 	/* check that the partid is for another partition */=
=0A 	if (remote_vars->partid < XP_MIN_PARTID ||=0A-	    remote_vars->partid=
 > XP_MAX_PARTID)=0A+	    remote_vars->partid > XP_MAX_PARTID) {=0A 		retur=
n xpInvalidPartid;=0A+	}=0A 	if (remote_vars->partid =3D=3D xp_partition_id=
)=0A 		return xpLocalPartid;=0A =0A@@ -494,9 +487,8 @@ xpc_identify_act_IRQ=
_req(int nasid)=0A =0A 	remote_vars_pa =3D remote_rp->vars_pa;=0A 	remote_r=
p_version =3D remote_rp->version;=0A-	if (XPC_SUPPORTS_RP_STAMP(remote_rp_v=
ersion)) {=0A+	if (XPC_SUPPORTS_RP_STAMP(remote_rp_version))=0A 		remote_rp=
_stamp =3D remote_rp->stamp;=0A-	}=0A =0A 	/* pull over the cross partition=
 variables */=0A =0A@@ -656,9 +648,8 @@ xpc_identify_act_IRQ_sender(void)=
=0A 	/* scan through activation AMO variables looking for non-zero entries =
*/=0A 	for (w_index =3D 0; w_index < xp_nasid_mask_words(); w_index++) {=0A=
 =0A-		if (xpc_exiting) {=0A+		if (xpc_exiting)=0A 			break;=0A-		}=0A =0A =
		ret =3D xp_get_amo(amo_va, XP_AMO_CLEAR, &nasid_mask);=0A 		BUG_ON(ret !=
=3D xpSuccess);	/* should never happen */=0A@@ -733,13 +724,11 @@ xpc_parti=
tion_disengaged(struct xpc_part=0A =0A 		DBUG_ON(part->act_state !=3D XPC_P=
_AS_DEACTIVATING &&=0A 			part->act_state !=3D XPC_P_AS_INACTIVE);=0A-		if =
(part->act_state !=3D XPC_P_AS_INACTIVE) {=0A+		if (part->act_state !=3D XP=
C_P_AS_INACTIVE)=0A 			xpc_wakeup_channel_mgr(part);=0A-		}=0A =0A-		if (XP=
C_SUPPORTS_DISENGAGE_REQUEST(part->remote_vars_version)) {=0A+		if (XPC_SUP=
PORTS_DISENGAGE_REQUEST(part->remote_vars_version))=0A 			xpc_cancel_partit=
ion_disengage_request(part);=0A-		}=0A 	}=0A 	return disengaged;=0A }=0A@@ =
-912,9 +901,9 @@ xpc_discovery(void)=0A 	remote_rp =3D xpc_kmalloc_cachelin=
e_aligned(XPC_RP_HEADER_SIZE +=0A 						  xp_sizeof_nasid_mask,=0A 						  =
GFP_KERNEL, &remote_rp_base);=0A-	if (remote_rp =3D=3D NULL) {=0A+	if (remo=
te_rp =3D=3D NULL)=0A 		return;=0A-	}=0A+=0A 	remote_vars =3D (struct xpc_v=
ars *)remote_rp;=0A =0A 	discovered_nasids =3D kzalloc(sizeof(u64) * xp_nas=
id_mask_words(),=0A@@ -947,18 +936,16 @@ xpc_discovery(void)=0A =0A 	for (r=
egion =3D 0; region < max_regions; region++) {=0A =0A-		if ((volatile int)x=
pc_exiting) {=0A+		if (xpc_exiting)=0A 			break;=0A-		}=0A =0A 		dev_dbg(xp=
c_part, "searching region %d\n", region);=0A =0A 		for (nasid =3D (region *=
 region_size * 2);=0A 		     nasid < ((region + 1) * region_size * 2); nasi=
d +=3D 2) {=0A =0A-			if ((volatile int)xpc_exiting) {=0A+			if (xpc_exitin=
g)=0A 				break;=0A-			}=0A =0A 			dev_dbg(xpc_part, "checking nasid %d\n",=
 nasid);=0A =0A@@ -1027,8 +1014,8 @@ xpc_discovery(void)=0A 			ret =3D xpc_=
register_remote_amos(part);=0A 			if (ret !=3D xpSuccess) {=0A 				dev_warn=
(xpc_part, "xpc_discovery() failed to "=0A-					 "register remote AMOs for =
partition %d,"=0A-					 "ret=3D%d\n", partid, ret);=0A+					 "register remo=
te AMOs for partition %d"=0A+					 ", ret=3D%d\n", partid, ret);=0A =0A 			=
	XPC_SET_REASON(part, xpPhysAddrRegFailed,=0A 					       __LINE__);=0A@@ -=
1072,9 +1059,8 @@ xpc_initiate_partid_to_nasids(short part=0A 	u64 part_nas=
id_pa;=0A =0A 	part =3D &xpc_partitions[partid];=0A-	if (part->remote_rp_pa=
 =3D=3D 0) {=0A+	if (part->remote_rp_pa =3D=3D 0)=0A 		return xpPartitionDo=
wn;=0A-	}=0A =0A 	memset(nasid_mask, 0, xp_sizeof_nasid_mask);=0A =0AIndex:=
 linux-2.6/drivers/misc/xp/xpc_channel.c=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=0A--- linux-2.6.orig/drivers/misc/xp/xpc_channel.c	20=
08-03-25 07:10:15.693148179 -0500=0A+++ linux-2.6/drivers/misc/xp/xpc_chann=
el.c	2008-03-25 13:34:50.777575812 -0500=0A@@ -24,7 +24,7 @@=0A #include "x=
pc.h"=0A =0A #ifdef CONFIG_X86_64=0A-#define cmpxchg_rel(ptr,o,n)	cmpxchg(p=
tr,o,n)=0A+#define cmpxchg_rel(ptr, o, n)	cmpxchg(ptr, o, n)=0A #endif=0A =
=0A /*=0A@@ -35,19 +35,19 @@ xpc_kzalloc_cacheline_aligned(size_t siz=0A {=
=0A 	/* see if kzalloc will give us cachline aligned memory by default */=
=0A 	*base =3D kzalloc(size, flags);=0A-	if (*base =3D=3D NULL) {=0A+	if (*=
base =3D=3D NULL)=0A 		return NULL;=0A-	}=0A-	if ((u64)*base =3D=3D L1_CACH=
E_ALIGN((u64)*base)) {=0A+=0A+	if ((u64)*base =3D=3D L1_CACHE_ALIGN((u64)*b=
ase))=0A 		return *base;=0A-	}=0A+=0A 	kfree(*base);=0A =0A 	/* nope, we'll=
 have to do it ourselves */=0A 	*base =3D kzalloc(size + L1_CACHE_BYTES, fl=
ags);=0A-	if (*base =3D=3D NULL) {=0A+	if (*base =3D=3D NULL)=0A 		return N=
ULL;=0A-	}=0A+=0A 	return (void *)L1_CACHE_ALIGN((u64)*base);=0A }=0A =0A@@=
 -98,6 +98,7 @@ xpc_setup_infrastructure(struct xpc_part=0A 	int ret, cpuid=
;=0A 	struct timer_list *timer;=0A 	short partid =3D XPC_PARTID(part);=0A+	=
enum xp_retval retval;=0A =0A 	/*=0A 	 * Zero out MOST of the entry for thi=
s partition. Only the fields=0A@@ -127,11 +128,10 @@ xpc_setup_infrastructu=
re(struct xpc_part=0A 							GFP_KERNEL,=0A 							&part->local_GPs_base);=
=0A 	if (part->local_GPs =3D=3D NULL) {=0A-		kfree(part->channels);=0A-		pa=
rt->channels =3D NULL;=0A 		dev_err(xpc_chan, "can't get memory for local g=
et/put "=0A 			"values\n");=0A-		return xpNoMemory;=0A+		retval =3D xpNoMem=
ory;=0A+		goto out_1;=0A 	}=0A =0A 	part->remote_GPs =3D xpc_kzalloc_cachel=
ine_aligned(XPC_GP_SIZE,=0A@@ -141,11 +141,8 @@ xpc_setup_infrastructure(st=
ruct xpc_part=0A 	if (part->remote_GPs =3D=3D NULL) {=0A 		dev_err(xpc_chan=
, "can't get memory for remote get/put "=0A 			"values\n");=0A-		kfree(part=
->local_GPs_base);=0A-		part->local_GPs =3D NULL;=0A-		kfree(part->channels=
);=0A-		part->channels =3D NULL;=0A-		return xpNoMemory;=0A+		retval =3D xp=
NoMemory;=0A+		goto out_2;=0A 	}=0A =0A 	/* allocate all the required open =
and close args */=0A@@ -155,13 +152,8 @@ xpc_setup_infrastructure(struct xp=
c_part=0A 					  &part->local_openclose_args_base);=0A 	if (part->local_ope=
nclose_args =3D=3D NULL) {=0A 		dev_err(xpc_chan, "can't get memory for loc=
al connect args\n");=0A-		kfree(part->remote_GPs_base);=0A-		part->remote_G=
Ps =3D NULL;=0A-		kfree(part->local_GPs_base);=0A-		part->local_GPs =3D NUL=
L;=0A-		kfree(part->channels);=0A-		part->channels =3D NULL;=0A-		return xp=
NoMemory;=0A+		retval =3D xpNoMemory;=0A+		goto out_3;=0A 	}=0A =0A 	part->=
remote_openclose_args =3D=0A@@ -169,15 +161,8 @@ xpc_setup_infrastructure(s=
truct xpc_part=0A 					  &part->remote_openclose_args_base);=0A 	if (part->=
remote_openclose_args =3D=3D NULL) {=0A 		dev_err(xpc_chan, "can't get memo=
ry for remote connect args\n");=0A-		kfree(part->local_openclose_args_base)=
;=0A-		part->local_openclose_args =3D NULL;=0A-		kfree(part->remote_GPs_bas=
e);=0A-		part->remote_GPs =3D NULL;=0A-		kfree(part->local_GPs_base);=0A-		=
part->local_GPs =3D NULL;=0A-		kfree(part->channels);=0A-		part->channels =
=3D NULL;=0A-		return xpNoMemory;=0A+		retval =3D xpNoMemory;=0A+		goto out=
_4;=0A 	}=0A =0A 	xpc_initialize_channels(part, partid);=0A@@ -201,17 +186,=
8 @@ xpc_setup_infrastructure(struct xpc_part=0A 	if (ret !=3D 0) {=0A 		de=
v_err(xpc_chan, "can't register NOTIFY IRQ handler, "=0A 			"errno=3D%d\n",=
 -ret);=0A-		kfree(part->remote_openclose_args_base);=0A-		part->remote_ope=
nclose_args =3D NULL;=0A-		kfree(part->local_openclose_args_base);=0A-		par=
t->local_openclose_args =3D NULL;=0A-		kfree(part->remote_GPs_base);=0A-		p=
art->remote_GPs =3D NULL;=0A-		kfree(part->local_GPs_base);=0A-		part->loca=
l_GPs =3D NULL;=0A-		kfree(part->channels);=0A-		part->channels =3D NULL;=
=0A-		return xpLackOfResources;=0A+		retval =3D xpLackOfResources;=0A+		got=
o out_5;=0A 	}=0A =0A 	/* Setup a timer to check for dropped IPIs */=0A@@ -=
246,6 +222,25 @@ xpc_setup_infrastructure(struct xpc_part=0A 	xpc_vars_part=
[partid].magic =3D XPC_VP_MAGIC1;=0A =0A 	return xpSuccess;=0A+=0A+	/* setu=
p of infrastructure failed */=0A+out_5:=0A+	kfree(part->remote_openclose_ar=
gs_base);=0A+	part->remote_openclose_args =3D NULL;=0A+out_4:=0A+	kfree(par=
t->local_openclose_args_base);=0A+	part->local_openclose_args =3D NULL;=0A+=
out_3:=0A+	kfree(part->remote_GPs_base);=0A+	part->remote_GPs =3D NULL;=0A+=
out_2:=0A+	kfree(part->local_GPs_base);=0A+	part->local_GPs =3D NULL;=0A+ou=
t_1:=0A+	kfree(part->channels);=0A+	part->channels =3D NULL;=0A+=0A+	return=
 retval;=0A }=0A =0A /*=0A@@ -266,9 +261,8 @@ xpc_pull_remote_cachelines(st=
ruct xpc_pa=0A 	DBUG_ON((u64)dst !=3D L1_CACHE_ALIGN((u64)dst));=0A 	DBUG_O=
N(cnt !=3D L1_CACHE_ALIGN(cnt));=0A =0A-	if (part->act_state =3D=3D XPC_P_A=
S_DEACTIVATING) {=0A+	if (part->act_state =3D=3D XPC_P_AS_DEACTIVATING)=0A =
		return part->reason;=0A-	}=0A =0A 	ret =3D xp_remote_memcpy(dst, src, cnt=
);=0A 	if (ret !=3D xpSuccess) {=0A@@ -358,18 +352,16 @@ xpc_pull_remote_va=
rs_part(struct xpc_par=0A 		part->remote_IPI_nasid =3D pulled_entry->IPI_na=
sid;=0A 		part->remote_IPI_phys_cpuid =3D pulled_entry->IPI_phys_cpuid;=0A =
=0A-		if (part->nchannels > pulled_entry->nchannels) {=0A+		if (part->nchan=
nels > pulled_entry->nchannels)=0A 			part->nchannels =3D pulled_entry->nch=
annels;=0A-		}=0A =0A 		/* let the other side know that we've pulled their =
variables */=0A =0A 		xpc_vars_part[partid].magic =3D XPC_VP_MAGIC2;=0A 	}=
=0A =0A-	if (pulled_entry->magic =3D=3D XPC_VP_MAGIC1) {=0A+	if (pulled_ent=
ry->magic =3D=3D XPC_VP_MAGIC1)=0A 		return xpRetry;=0A-	}=0A =0A 	return x=
pSuccess;=0A }=0A@@ -389,9 +381,10 @@ xpc_get_IPI_flags(struct xpc_partitio=
n *=0A 	 */=0A =0A 	spin_lock_irqsave(&part->IPI_lock, irq_flags);=0A-	if (=
(IPI_amo =3D part->local_IPI_amo) !=3D 0) {=0A+	IPI_amo =3D part->local_IPI=
_amo;=0A+	if (IPI_amo !=3D 0)=0A 		part->local_IPI_amo =3D 0;=0A-	}=0A+=0A =
	spin_unlock_irqrestore(&part->IPI_lock, irq_flags);=0A =0A 	if (XPC_ANY_OP=
ENCLOSE_IPI_FLAGS_SET(IPI_amo)) {=0A@@ -445,11 +438,9 @@ xpc_allocate_local=
_msgqueue(struct xpc_c=0A 		nbytes =3D nentries * ch->msg_size;=0A 		ch->lo=
cal_msgqueue =3D xpc_kzalloc_cacheline_aligned(nbytes,=0A 								   GFP_KE=
RNEL,=0A-								   &ch->=0A-								   local_msgqueue_base);=0A-		if (ch->=
local_msgqueue =3D=3D NULL) {=0A+						      &ch->local_msgqueue_base);=0A+=
		if (ch->local_msgqueue =3D=3D NULL)=0A 			continue;=0A-		}=0A =0A 		nbyte=
s =3D nentries * sizeof(struct xpc_notify);=0A 		ch->notify_queue =3D kzall=
oc(nbytes, GFP_KERNEL);=0A@@ -493,11 +484,9 @@ xpc_allocate_remote_msgqueue=
(struct xpc_=0A 		nbytes =3D nentries * ch->msg_size;=0A 		ch->remote_msgqu=
eue =3D xpc_kzalloc_cacheline_aligned(nbytes,=0A 								    GFP_KERNEL,=0A=
-								    &ch->=0A-								    remote_msgqueue_base);=0A-		if (ch->remot=
e_msgqueue =3D=3D NULL) {=0A+						     &ch->remote_msgqueue_base);=0A+		if=
 (ch->remote_msgqueue =3D=3D NULL)=0A 			continue;=0A-		}=0A =0A 		spin_loc=
k_irqsave(&ch->lock, irq_flags);=0A 		if (nentries < ch->remote_nentries) {=
=0A@@ -529,11 +518,12 @@ xpc_allocate_msgqueues(struct xpc_channe=0A =0A 	D=
BUG_ON(ch->flags & XPC_C_SETUP);=0A =0A-	if ((ret =3D xpc_allocate_local_ms=
gqueue(ch)) !=3D xpSuccess) {=0A+	ret =3D xpc_allocate_local_msgqueue(ch);=
=0A+	if (ret !=3D xpSuccess)=0A 		return ret;=0A-	}=0A =0A-	if ((ret =3D xp=
c_allocate_remote_msgqueue(ch)) !=3D xpSuccess) {=0A+	ret =3D xpc_allocate_=
remote_msgqueue(ch);=0A+	if (ret !=3D xpSuccess) {=0A 		kfree(ch->local_msg=
queue_base);=0A 		ch->local_msgqueue =3D NULL;=0A 		kfree(ch->notify_queue)=
;=0A@@ -573,12 +563,11 @@ xpc_process_connect(struct xpc_channel *=0A 		ret=
 =3D xpc_allocate_msgqueues(ch);=0A 		spin_lock_irqsave(&ch->lock, *irq_fla=
gs);=0A =0A-		if (ret !=3D xpSuccess) {=0A+		if (ret !=3D xpSuccess)=0A 			=
XPC_DISCONNECT_CHANNEL(ch, ret, irq_flags);=0A-		}=0A-		if (ch->flags & (XP=
C_C_CONNECTED | XPC_C_DISCONNECTING)) {=0A+=0A+		if (ch->flags & (XPC_C_CON=
NECTED | XPC_C_DISCONNECTING))=0A 			return;=0A-		}=0A =0A 		DBUG_ON(!(ch->=
flags & XPC_C_SETUP));=0A 		DBUG_ON(ch->local_msgqueue =3D=3D NULL);=0A@@ -=
590,9 +579,8 @@ xpc_process_connect(struct xpc_channel *=0A 		xpc_IPI_send_=
openreply(ch, irq_flags);=0A 	}=0A =0A-	if (!(ch->flags & XPC_C_ROPENREPLY)=
) {=0A+	if (!(ch->flags & XPC_C_ROPENREPLY))=0A 		return;=0A-	}=0A =0A 	DBU=
G_ON(ch->remote_msgqueue_pa =3D=3D 0);=0A =0A@@ -711,9 +699,8 @@ xpc_proces=
s_disconnect(struct xpc_channe=0A =0A 	DBUG_ON(!spin_is_locked(&ch->lock));=
=0A =0A-	if (!(ch->flags & XPC_C_DISCONNECTING)) {=0A+	if (!(ch->flags & XP=
C_C_DISCONNECTING))=0A 		return;=0A-	}=0A =0A 	DBUG_ON(!(ch->flags & XPC_C_=
CLOSEREQUEST));=0A =0A@@ -728,26 +715,23 @@ xpc_process_disconnect(struct x=
pc_channe=0A =0A 	if (part->act_state =3D=3D XPC_P_AS_DEACTIVATING) {=0A 		=
/* can't proceed until the other side disengages from us */=0A-		if (xpc_pa=
rtition_engaged(ch->partid)) {=0A+		if (xpc_partition_engaged(ch->partid))=
=0A 			return;=0A-		}=0A =0A 	} else {=0A =0A 		/* as long as the other sid=
e is up do the full protocol */=0A =0A-		if (!(ch->flags & XPC_C_RCLOSEREQU=
EST)) {=0A+		if (!(ch->flags & XPC_C_RCLOSEREQUEST))=0A 			return;=0A-		}=
=0A =0A 		if (!(ch->flags & XPC_C_CLOSEREPLY)) {=0A 			ch->flags |=3D XPC_C=
_CLOSEREPLY;=0A 			xpc_IPI_send_closereply(ch, irq_flags);=0A 		}=0A =0A-		=
if (!(ch->flags & XPC_C_RCLOSEREPLY)) {=0A+		if (!(ch->flags & XPC_C_RCLOSE=
REPLY))=0A 			return;=0A-		}=0A 	}=0A =0A 	/* wake those waiting for notify=
 completion */=0A@@ -807,9 +791,10 @@ xpc_process_openclose_IPI(struct xpc_=
par=0A =0A 	spin_lock_irqsave(&ch->lock, irq_flags);=0A =0A-      again:=0A=
+again:=0A =0A-	if ((ch->flags & XPC_C_DISCONNECTED) && (ch->flags & XPC_C_=
WDISCONNECT)) {=0A+	if ((ch->flags & XPC_C_DISCONNECTED) &&=0A+	    (ch->fl=
ags & XPC_C_WDISCONNECT)) {=0A 		/*=0A 		 * Delay processing IPI flags unti=
l thread waiting disconnect=0A 		 * has had a chance to see that the channe=
l is disconnected.=0A@@ -882,11 +867,10 @@ xpc_process_openclose_IPI(struct=
 xpc_par=0A =0A 		if (!(ch->flags & XPC_C_DISCONNECTING)) {=0A 			reason =
=3D args->reason;=0A-			if (reason <=3D xpSuccess || reason > xpUnknownReas=
on) {=0A+			if (reason <=3D xpSuccess || reason > xpUnknownReason)=0A 				r=
eason =3D xpUnknownReason;=0A-			} else if (reason =3D=3D xpUnregistering) =
{=0A+			else if (reason =3D=3D xpUnregistering)=0A 				reason =3D xpOtherUn=
registering;=0A-			}=0A =0A 			XPC_DISCONNECT_CHANNEL(ch, reason, &irq_flag=
s);=0A =0A@@ -1060,9 +1044,8 @@ xpc_connect_channel(struct xpc_channel *=0A=
 	unsigned long irq_flags;=0A 	struct xpc_registration *registration =3D &x=
pc_registrations[ch->number];=0A =0A-	if (mutex_trylock(&registration->mute=
x) =3D=3D 0) {=0A+	if (mutex_trylock(&registration->mutex) =3D=3D 0)=0A 		r=
eturn xpRetry;=0A-	}=0A =0A 	if (!XPC_CHANNEL_REGISTERED(ch->number)) {=0A =
		mutex_unlock(&registration->mutex);=0A@@ -1151,7 +1134,7 @@ xpc_clear_loc=
al_msgqueue_flags(struct xp=0A 					 (get % ch->local_nentries) *=0A 					 =
ch->msg_size);=0A 		msg->flags =3D 0;=0A-	} while (++get < (volatile s64)ch=
->remote_GP.get);=0A+	} while (++get < ch->remote_GP.get);=0A }=0A =0A /*=
=0A@@ -1169,7 +1152,7 @@ xpc_clear_remote_msgqueue_flags(struct x=0A 					 =
(put % ch->remote_nentries) *=0A 					 ch->msg_size);=0A 		msg->flags =3D 0=
;=0A-	} while (++put < (volatile s64)ch->remote_GP.put);=0A+	} while (++put=
 < ch->remote_GP.put);=0A }=0A =0A static void=0A@@ -1236,9 +1219,8 @@ xpc_=
process_msg_IPI(struct xpc_partition=0A 		 * If anyone was waiting for mess=
age queue entries to become=0A 		 * available, wake them up.=0A 		 */=0A-		=
if (atomic_read(&ch->n_on_msg_allocate_wq) > 0) {=0A+		if (atomic_read(&ch-=
>n_on_msg_allocate_wq) > 0)=0A 			wake_up(&ch->msg_allocate_wq);=0A-		}=0A =
	}=0A =0A 	/*=0A@@ -1265,9 +1247,8 @@ xpc_process_msg_IPI(struct xpc_partit=
ion=0A 				"delivered=3D%d, partid=3D%d, channel=3D%d\n",=0A 				nmsgs_sent=
, ch->partid, ch->number);=0A =0A-			if (ch->flags & XPC_C_CONNECTEDCALLOUT=
_MADE) {=0A+			if (ch->flags & XPC_C_CONNECTEDCALLOUT_MADE)=0A 				xpc_acti=
vate_kthreads(ch, nmsgs_sent);=0A-			}=0A 		}=0A 	}=0A =0A@@ -1302,9 +1283,=
8 @@ xpc_process_channel_activity(struct xpc_=0A =0A 		IPI_flags =3D XPC_GE=
T_IPI_FLAGS(IPI_amo, ch_number);=0A =0A-		if (XPC_ANY_OPENCLOSE_IPI_FLAGS_S=
ET(IPI_flags)) {=0A+		if (XPC_ANY_OPENCLOSE_IPI_FLAGS_SET(IPI_flags))=0A 		=
	xpc_process_openclose_IPI(part, ch_number, IPI_flags);=0A-		}=0A =0A 		ch_=
flags =3D ch->flags;	/* need an atomic snapshot of flags */=0A =0A@@ -1315,=
9 +1295,8 @@ xpc_process_channel_activity(struct xpc_=0A 			continue;=0A 		=
}=0A =0A-		if (part->act_state =3D=3D XPC_P_AS_DEACTIVATING) {=0A+		if (par=
t->act_state =3D=3D XPC_P_AS_DEACTIVATING)=0A 			continue;=0A-		}=0A =0A 		=
if (!(ch_flags & XPC_C_CONNECTED)) {=0A 			if (!(ch_flags & XPC_C_OPENREQUE=
ST)) {=0A@@ -1337,9 +1316,8 @@ xpc_process_channel_activity(struct xpc_=0A =
		 * from the other partition.=0A 		 */=0A =0A-		if (XPC_ANY_MSG_IPI_FLAGS_=
SET(IPI_flags)) {=0A+		if (XPC_ANY_MSG_IPI_FLAGS_SET(IPI_flags))=0A 			xpc_=
process_msg_IPI(part, ch_number);=0A-		}=0A 	}=0A }=0A =0A@@ -1552,9 +1530,=
9 @@ xpc_disconnect_channel(const int line, s=0A =0A 	DBUG_ON(!spin_is_lock=
ed(&ch->lock));=0A =0A-	if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCON=
NECTED)) {=0A+	if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED))=
=0A 		return;=0A-	}=0A+=0A 	DBUG_ON(!(ch->flags & (XPC_C_CONNECTING | XPC_C=
_CONNECTED)));=0A =0A 	dev_dbg(xpc_chan, "reason=3D%d, line=3D%d, partid=3D=
%d, channel=3D%d\n",=0A@@ -1570,9 +1548,8 @@ xpc_disconnect_channel(const i=
nt line, s=0A =0A 	xpc_IPI_send_closerequest(ch, irq_flags);=0A =0A-	if (ch=
annel_was_connected) {=0A+	if (channel_was_connected)=0A 		ch->flags |=3D X=
PC_C_WASCONNECTED;=0A-	}=0A =0A 	spin_unlock_irqrestore(&ch->lock, *irq_fla=
gs);=0A =0A@@ -1587,9 +1564,8 @@ xpc_disconnect_channel(const int line, s=
=0A 	}=0A =0A 	/* wake those waiting to allocate an entry from the local ms=
g queue */=0A-	if (atomic_read(&ch->n_on_msg_allocate_wq) > 0) {=0A+	if (at=
omic_read(&ch->n_on_msg_allocate_wq) > 0)=0A 		wake_up(&ch->msg_allocate_wq=
);=0A-	}=0A =0A 	spin_lock_irqsave(&ch->lock, *irq_flags);=0A }=0A@@ -1677,=
9 +1653,9 @@ xpc_allocate_msg(struct xpc_channel *ch,=0A =0A 	while (1) {=
=0A =0A-		put =3D (volatile s64)ch->w_local_GP.put;=0A-		if (put - (volatil=
e s64)ch->w_remote_GP.get <=0A-		    ch->local_nentries) {=0A+		put =3D ch-=
>w_local_GP.put;=0A+		rmb();	/* guarantee that .put loads before .get */=0A=
+		if (put - ch->w_remote_GP.get < ch->local_nentries) {=0A =0A 			/* There=
 are available message entries. We need to try=0A 			 * to secure one for o=
urselves. We'll do this by trying=0A@@ -1703,9 +1679,8 @@ xpc_allocate_msg(=
struct xpc_channel *ch,=0A 		 * that will cause the IPI handler to fetch th=
e latest=0A 		 * GP values as if an IPI was sent by the other side.=0A 		 *=
/=0A-		if (ret =3D=3D xpTimeout) {=0A+		if (ret =3D=3D xpTimeout)=0A 			xpc=
_IPI_send_local_msgrequest(ch);=0A-		}=0A =0A 		if (flags & XPC_NOWAIT) {=
=0A 			xpc_msgqueue_deref(ch);=0A@@ -1764,9 +1739,8 @@ xpc_initiate_allocat=
e(short partid, int =0A 		ret =3D xpc_allocate_msg(&part->channels[ch_numbe=
r], flags, &msg);=0A 		xpc_part_deref(part);=0A =0A-		if (msg !=3D NULL) {=
=0A+		if (msg !=3D NULL)=0A 			*payload =3D &msg->payload;=0A-		}=0A 	}=0A =
=0A 	return ret;=0A@@ -1787,17 +1761,15 @@ xpc_send_msgs(struct xpc_channel=
 *ch, s6=0A 	while (1) {=0A =0A 		while (1) {=0A-			if (put =3D=3D (volatil=
e s64)ch->w_local_GP.put) {=0A+			if (put =3D=3D ch->w_local_GP.put)=0A 			=
	break;=0A-			}=0A =0A 			msg =3D (struct xpc_msg *)((u64)ch->local_msgqueu=
e +=0A 						 (put % ch->local_nentries) *=0A 						 ch->msg_size);=0A =0A-=
			if (!(msg->flags & XPC_M_READY)) {=0A+			if (!(msg->flags & XPC_M_READY)=
)=0A 				break;=0A-			}=0A =0A 			put++;=0A 		}=0A@@ -1810,7 +1782,7 @@ xpc=
_send_msgs(struct xpc_channel *ch, s6=0A 		if (cmpxchg_rel(&ch->local_GP->p=
ut, initial_put, put) !=3D=0A 		    initial_put) {=0A 			/* someone else be=
at us to it */=0A-			DBUG_ON((volatile s64)ch->local_GP->put < initial_put)=
;=0A+			DBUG_ON(ch->local_GP->put < initial_put);=0A 			break;=0A 		}=0A =
=0A@@ -1829,9 +1801,8 @@ xpc_send_msgs(struct xpc_channel *ch, s6=0A 		init=
ial_put =3D put;=0A 	}=0A =0A-	if (send_IPI) {=0A+	if (send_IPI)=0A 		xpc_I=
PI_send_msgrequest(ch);=0A-	}=0A }=0A =0A /*=0A@@ -1905,9 +1876,8 @@ xpc_se=
nd_msg(struct xpc_channel *ch, str=0A 	/* see if the message is next in lin=
e to be sent, if so send it */=0A =0A 	put =3D ch->local_GP->put;=0A-	if (p=
ut =3D=3D msg_number) {=0A+	if (put =3D=3D msg_number)=0A 		xpc_send_msgs(c=
h, put);=0A-	}=0A =0A 	/* drop the reference grabbed in xpc_allocate_msg() =
*/=0A 	xpc_msgqueue_deref(ch);=0A@@ -2024,10 +1994,8 @@ xpc_pull_remote_msg=
(struct xpc_channel *=0A =0A 		msg_index =3D ch->next_msg_to_pull % ch->rem=
ote_nentries;=0A =0A-		DBUG_ON(ch->next_msg_to_pull >=3D=0A-			(volatile s6=
4)ch->w_remote_GP.put);=0A-		nmsgs =3D (volatile s64)ch->w_remote_GP.put -=
=0A-		    ch->next_msg_to_pull;=0A+		DBUG_ON(ch->next_msg_to_pull >=3D ch->=
w_remote_GP.put);=0A+		nmsgs =3D ch->w_remote_GP.put - ch->next_msg_to_pull=
;=0A 		if (msg_index + nmsgs > ch->remote_nentries) {=0A 			/* ignore the o=
nes that wrap the msg queue for now */=0A 			nmsgs =3D ch->remote_nentries =
- msg_index;=0A@@ -2038,10 +2006,9 @@ xpc_pull_remote_msg(struct xpc_channe=
l *=0A 		remote_msg =3D (struct xpc_msg *)(ch->remote_msgqueue_pa +=0A 				=
		msg_offset);=0A =0A-		if ((ret =3D xpc_pull_remote_cachelines(part, msg, =
remote_msg,=0A-						      nmsgs * ch->msg_size)) !=3D=0A-		    xpSuccess) =
{=0A-=0A+		ret =3D xpc_pull_remote_cachelines(part, msg, remote_msg, nmsgs =
*=0A+						 ch->msg_size);=0A+		if (ret !=3D xpSuccess) {=0A 			dev_dbg(xpc=
_chan, "failed to pull %d msgs starting with"=0A 				" msg %" U64_ELL "d fr=
om partition %d, "=0A 				"channel=3D%d, ret=3D%d\n", nmsgs,=0A@@ -2054,8 +=
2021,6 @@ xpc_pull_remote_msg(struct xpc_channel *=0A 			return NULL;=0A 		=
}=0A =0A-		mb();		/* >>> this may not be needed, we're not sure */=0A-=0A 	=
	ch->next_msg_to_pull +=3D nmsgs;=0A 	}=0A =0A@@ -2078,14 +2043,13 @@ xpc_g=
et_deliverable_msg(struct xpc_chann=0A 	s64 get;=0A =0A 	do {=0A-		if ((vol=
atile u32)ch->flags & XPC_C_DISCONNECTING) {=0A+		if (ch->flags & XPC_C_DIS=
CONNECTING)=0A 			break;=0A-		}=0A =0A-		get =3D (volatile s64)ch->w_local_=
GP.get;=0A-		if (get =3D=3D (volatile s64)ch->w_remote_GP.put) {=0A+		get =
=3D ch->w_local_GP.get;=0A+		rmb();	/* guarantee that .get loads before .pu=
t */=0A+		if (get =3D=3D ch->w_remote_GP.put)=0A 			break;=0A-		}=0A =0A 		=
/* There are messages waiting to be pulled and delivered.=0A 		 * We need t=
o try to secure one for ourselves. We'll do this=0A@@ -2125,7 +2089,8 @@ xp=
c_deliver_msg(struct xpc_channel *ch)=0A {=0A 	struct xpc_msg *msg;=0A =0A-=
	if ((msg =3D xpc_get_deliverable_msg(ch)) !=3D NULL) {=0A+	msg =3D xpc_get=
_deliverable_msg(ch);=0A+	if (msg !=3D NULL) {=0A =0A 		/*=0A 		 * This ref=
 is taken to protect the payload itself from being=0A@@ -2171,17 +2136,15 @=
@ xpc_acknowledge_msgs(struct xpc_channel =0A 	while (1) {=0A =0A 		while (=
1) {=0A-			if (get =3D=3D (volatile s64)ch->w_local_GP.get) {=0A+			if (get=
 =3D=3D ch->w_local_GP.get)=0A 				break;=0A-			}=0A =0A 			msg =3D (struct=
 xpc_msg *)((u64)ch->remote_msgqueue +=0A 						 (get % ch->remote_nentries=
) *=0A 						 ch->msg_size);=0A =0A-			if (!(msg->flags & XPC_M_DONE)) {=0A=
+			if (!(msg->flags & XPC_M_DONE))=0A 				break;=0A-			}=0A =0A 			msg_fla=
gs |=3D msg->flags;=0A 			get++;=0A@@ -2195,7 +2158,7 @@ xpc_acknowledge_ms=
gs(struct xpc_channel =0A 		if (cmpxchg_rel(&ch->local_GP->get, initial_get=
, get) !=3D=0A 		    initial_get) {=0A 			/* someone else beat us to it */=
=0A-			DBUG_ON((volatile s64)ch->local_GP->get <=3D initial_get);=0A+			DBU=
G_ON(ch->local_GP->get <=3D initial_get);=0A 			break;=0A 		}=0A =0A@@ -221=
4,9 +2177,8 @@ xpc_acknowledge_msgs(struct xpc_channel =0A 		initial_get =
=3D get;=0A 	}=0A =0A-	if (send_IPI) {=0A+	if (send_IPI)=0A 		xpc_IPI_send_=
msgrequest(ch);=0A-	}=0A }=0A =0A /*=0A@@ -2270,9 +2232,8 @@ xpc_initiate_r=
eceived(short partid, int =0A 	 * been delivered.=0A 	 */=0A 	get =3D ch->l=
ocal_GP->get;=0A-	if (get =3D=3D msg_number) {=0A+	if (get =3D=3D msg_numbe=
r)=0A 		xpc_acknowledge_msgs(ch, get, msg->flags);=0A-	}=0A =0A 	/* the cal=
l to xpc_msgqueue_ref() was done by xpc_deliver_msg()  */=0A 	xpc_msgqueue_=
deref(ch);=0AIndex: linux-2.6/drivers/misc/xp/xpc.h=0A=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A--- linux-2.6.orig/drivers/misc/xp/xpc.h	2=
008-03-25 07:10:15.693148179 -0500=0A+++ linux-2.6/drivers/misc/xp/xpc.h	20=
08-03-25 07:10:17.809412207 -0500=0A@@ -109,16 +109,16 @@ struct xpc_rsvd_p=
age {=0A 	u8 SAL_partid;		/* SAL: partition ID */=0A 	u8 version;=0A 	u8 pa=
d[6];=0A-	volatile u64 vars_pa;	/* physical address of struct xpc_vars */=
=0A+	u64 vars_pa;		/* physical address of struct xpc_vars */=0A 	struct tim=
espec stamp;	/* time when reserved page was setup by XPC */=0A 	u64 pad2[9]=
;		/* align to last u64 in cacheline */=0A 	u64 SAL_nasids_size;	/* SAL: si=
ze of each nasid mask in bytes */=0A };=0A =0A-#define XPC_RP_VERSION _XPC_=
VERSION(2,0)	/* version 2.0 of the reserved page */=0A+#define XPC_RP_VERSI=
ON _XPC_VERSION(2, 0) /* version 2.0 of the reserved page */=0A =0A #define=
 XPC_SUPPORTS_RP_STAMP(_version) \=0A-			(_version >=3D _XPC_VERSION(1,1))=
=0A+			(_version >=3D _XPC_VERSION(1, 1))=0A =0A /*=0A  * compare stamps - =
the return value is:=0A@@ -132,9 +132,10 @@ xpc_compare_stamps(struct times=
pec *stam=0A {=0A 	int ret;=0A =0A-	if ((ret =3D stamp1->tv_sec - stamp2->t=
v_sec) =3D=3D 0) {=0A+	ret =3D stamp1->tv_sec - stamp2->tv_sec;=0A+	if (ret=
 =3D=3D 0)=0A 		ret =3D stamp1->tv_nsec - stamp2->tv_nsec;=0A-	}=0A+=0A 	re=
turn ret;=0A }=0A =0A@@ -166,10 +167,10 @@ struct xpc_vars {=0A 	u64 heartb=
eating_to_mask[BITS_TO_LONGS(XP_MAX_NPARTITIONS)];=0A };=0A =0A-#define XPC=
_V_VERSION _XPC_VERSION(4,0)	/* version 4.0 of the cross vars */=0A+#define=
 XPC_V_VERSION _XPC_VERSION(4, 0)    /* version 4.0 of the cross vars */=0A=
 =0A #define XPC_SUPPORTS_DISENGAGE_REQUEST(_version) \=0A-			(_version >=
=3D _XPC_VERSION(3,1))=0A+			(_version >=3D _XPC_VERSION(3, 1))=0A =0A stat=
ic inline int=0A xpc_hb_allowed(short partid, struct xpc_vars *vars)=0A@@ -=
267,7 +268,7 @@ xpc_number_of_amos(int npartitions)=0A  * occupies half a c=
acheline.=0A  */=0A struct xpc_vars_part {=0A-	volatile u64 magic;=0A+	u64 =
magic;=0A =0A 	u64 openclose_args_pa;	/* physical address of open and close=
 args */=0A 	u64 GPs_pa;		/* physical address of Get/Put values */=0A@@ -29=
0,8 +291,8 @@ struct xpc_vars_part {=0A  * MAGIC2 indicates that this parti=
tion has pulled the remote partititions=0A  * per partition variables that =
pertain to this partition.=0A  */=0A-#define XPC_VP_MAGIC1	0x00535241564350=
58L	/* 'XPCVARS\0'L (little endian) */=0A-#define XPC_VP_MAGIC2	0x007372617=
6435058L	/* 'XPCvars\0'L (little endian) */=0A+#define XPC_VP_MAGIC1	0x0053=
524156435058L   /* 'XPCVARS\0'L (little endian) */=0A+#define XPC_VP_MAGIC2=
	0x0073726176435058L   /* 'XPCvars\0'L (little endian) */=0A =0A /* the res=
erved page sizes and offsets */=0A =0A@@ -301,9 +302,10 @@ struct xpc_vars_=
part {=0A #define XPC_RP_PART_NASIDS(_rp) (u64 *)((u8 *)(_rp) + XPC_RP_HEAD=
ER_SIZE)=0A #define XPC_RP_MACH_NASIDS(_rp) (XPC_RP_PART_NASIDS(_rp) + \=0A=
 				 xp_nasid_mask_words())=0A-#define XPC_RP_VARS(_rp)	(struct xpc_vars *=
)(XPC_RP_MACH_NASIDS(_rp) + \=0A-				 xp_nasid_mask_words())=0A-#define XPC=
_RP_VARS_PART(_rp)	(struct xpc_vars_part *)((u8 *)XPC_RP_VARS(_rp) + XPC_RP=
_VARS_SIZE)=0A+#define XPC_RP_VARS(_rp)	((struct xpc_vars *)(XPC_RP_MACH_NA=
SIDS(_rp) + \=0A+				xp_nasid_mask_words()))=0A+#define XPC_RP_VARS_PART(_r=
p)	((struct xpc_vars_part *) \=0A+				((u8 *)XPC_RP_VARS(_rp) + XPC_RP_VARS=
_SIZE))=0A =0A /*=0A  * Functions registered by add_timer() or called by ke=
rnel_thread() only=0A@@ -322,8 +324,8 @@ struct xpc_vars_part {=0A  * Defin=
e a Get/Put value pair (pointers) used with a message queue.=0A  */=0A stru=
ct xpc_gp {=0A-	volatile s64 get;	/* Get value */=0A-	volatile s64 put;	/* =
Put value */=0A+	s64 get;		/* Get value */=0A+	s64 put;		/* Put value */=0A=
 };=0A =0A #define XPC_GP_SIZE \=0A@@ -360,7 +362,7 @@ struct xpc_openclose=
_args {=0A  * and consumed by the intended recipient.=0A  */=0A struct xpc_=
notify {=0A-	volatile u8 type;	/* type of notification */=0A+	u8 type;		/* =
type of notification */=0A =0A 	/* the following two fields are only used i=
f type =3D=3D XPC_N_CALL */=0A 	xpc_notify_func func;	/* user's notify func=
tion */=0A@@ -466,10 +468,10 @@ struct xpc_channel {=0A 	void *local_msgque=
ue_base;	/* base address of kmalloc'd space */=0A 	struct xpc_msg *local_ms=
gqueue;	/* local message queue */=0A 	void *remote_msgqueue_base;	/* base a=
ddress of kmalloc'd space */=0A-	struct xpc_msg *remote_msgqueue;	/* cached=
 copy of remote partition's */=0A-	/* local message queue */=0A+	struct xpc=
_msg *remote_msgqueue; /* cached copy of remote partition's */=0A+					 /* =
local message queue */=0A 	u64 remote_msgqueue_pa;	/* phys addr of remote p=
artition's */=0A-	/* local message queue */=0A+				/* local message queue *=
/=0A =0A 	atomic_t references;	/* #of external references to queues */=0A =
=0A@@ -477,21 +479,21 @@ struct xpc_channel {=0A 	wait_queue_head_t msg_all=
ocate_wq;	/* msg allocation wait queue */=0A =0A 	u8 delayed_IPI_flags;	/* =
IPI flags received, but delayed */=0A-	/* action until channel disconnected=
 */=0A+				/* action until channel disconnected */=0A =0A 	/* queue of msg =
senders who want to be notified when msg received */=0A =0A 	atomic_t n_to_=
notify;	/* #of msg senders to notify */=0A-	struct xpc_notify *notify_queue=
;	/* notify queue for messages sent */=0A+	struct xpc_notify *notify_queue;=
    /* notify queue for messages sent */=0A =0A 	xpc_channel_func func;	/* =
user's channel function */=0A 	void *key;		/* pointer to user's key */=0A =
=0A 	struct mutex msg_to_pull_mutex;	/* next msg to pull serialization */=
=0A-	struct completion wdisconnect_wait;	/* wait for channel disconnect */=
=0A+	struct completion wdisconnect_wait;    /* wait for channel disconnect =
*/=0A =0A-	struct xpc_openclose_args *local_openclose_args;	/* args passed =
on */=0A-	/* opening or closing of channel */=0A+	struct xpc_openclose_args=
 *local_openclose_args;    /* args passed on */=0A+					     /* opening or =
closing of channel */=0A =0A 	/* various flavors of local and remote Get/Pu=
t values */=0A =0A@@ -519,28 +521,28 @@ struct xpc_channel {=0A =0A #define=
	XPC_C_ROPENREPLY	0x00000002	/* remote open channel reply */=0A #define	XPC=
_C_OPENREPLY		0x00000004	/* local open channel reply */=0A-#define	XPC_C_RO=
PENREQUEST	0x00000008	/* remote open channel request */=0A+#define	XPC_C_RO=
PENREQUEST	0x00000008     /* remote open channel request */=0A #define	XPC_=
C_OPENREQUEST	0x00000010	/* local open channel request */=0A =0A-#define	XP=
C_C_SETUP		0x00000020	/* channel's msgqueues are alloc'd */=0A-#define	XPC_=
C_CONNECTEDCALLOUT	0x00000040	/* connected callout initiated */=0A+#define	=
XPC_C_SETUP		0x00000020 /* channel's msgqueues are alloc'd */=0A+#define	XP=
C_C_CONNECTEDCALLOUT	0x00000040     /* connected callout initiated */=0A #d=
efine	XPC_C_CONNECTEDCALLOUT_MADE \=0A-				0x00000080	/* connected callout =
completed */=0A+				0x00000080     /* connected callout completed */=0A #de=
fine	XPC_C_CONNECTED		0x00000100	/* local channel is connected */=0A #defin=
e	XPC_C_CONNECTING	0x00000200	/* channel is being connected */=0A =0A #defi=
ne	XPC_C_RCLOSEREPLY	0x00000400	/* remote close channel reply */=0A #define=
	XPC_C_CLOSEREPLY	0x00000800	/* local close channel reply */=0A-#define	XPC=
_C_RCLOSEREQUEST	0x00001000	/* remote close channel request */=0A-#define	X=
PC_C_CLOSEREQUEST	0x00002000	/* local close channel request */=0A+#define	X=
PC_C_RCLOSEREQUEST	0x00001000    /* remote close channel request */=0A+#def=
ine	XPC_C_CLOSEREQUEST	0x00002000     /* local close channel request */=0A =
=0A #define	XPC_C_DISCONNECTED	0x00004000	/* channel is disconnected */=0A-=
#define	XPC_C_DISCONNECTING	0x00008000	/* channel is being disconnected */=
=0A+#define	XPC_C_DISCONNECTING	0x00008000   /* channel is being disconnect=
ed */=0A #define	XPC_C_DISCONNECTINGCALLOUT \=0A-				0x00010000	/* disconne=
cting callout initiated */=0A+				0x00010000 /* disconnecting callout initi=
ated */=0A #define	XPC_C_DISCONNECTINGCALLOUT_MADE \=0A-				0x00020000	/* d=
isconnecting callout completed */=0A-#define	XPC_C_WDISCONNECT	0x00040000	/=
* waiting for channel disconnect */=0A+				0x00020000 /* disconnecting call=
out completed */=0A+#define	XPC_C_WDISCONNECT	0x00040000  /* waiting for ch=
annel disconnect */=0A =0A /*=0A  * Manages channels on a partition basis. =
There is one of these structures=0A@@ -554,7 +556,7 @@ struct xpc_partition=
 {=0A 	u8 remote_rp_version;	/* version# of partition's rsvd pg */=0A 	shor=
t remote_npartitions;	/* value of XPC_NPARTITIONS */=0A 	u32 flags;		/* gen=
eral flags */=0A-	struct timespec remote_rp_stamp;	/* time when rsvd pg was=
 initialized */=0A+	struct timespec remote_rp_stamp; /* time when rsvd pg w=
as initialized */=0A 	u64 remote_rp_pa;	/* phys addr of partition's rsvd pg=
 */=0A 	u64 remote_vars_pa;	/* phys addr of partition's vars */=0A 	u64 rem=
ote_vars_part_pa;	/* phys addr of partition's vars part */=0A@@ -564,7 +566=
,7 @@ struct xpc_partition {=0A 	int remote_act_phys_cpuid;	/* active part'=
s act/deact phys cpuid */=0A 	u32 act_IRQ_rcvd;	/* IRQs since activation */=
=0A 	spinlock_t lock;	/* protect updating of act_state and */=0A-	/* the ge=
neral flags */=0A+				/* the general flags */=0A 	u8 act_state;		/* from XP=
C HB viewpoint */=0A 	u8 remote_vars_version;	/* version# of partition's va=
rs */=0A 	enum xp_retval reason;	/* reason partition is deactivating */=0A@=
@ -576,7 +578,7 @@ struct xpc_partition {=0A =0A 	/* XPC infrastructure ref=
erencing and teardown control */=0A =0A-	volatile u8 setup_state;	/* infras=
tructure setup state */=0A+	u8 setup_state;		/* infrastructure setup state =
*/=0A 	wait_queue_head_t teardown_wq;	/* kthread waiting to teardown infra =
*/=0A 	atomic_t references;	/* #of references to infrastructure */=0A =0A@@=
 -588,25 +590,25 @@ struct xpc_partition {=0A 	 */=0A =0A 	u8 nchannels;		/=
* #of defined channels supported */=0A-	atomic_t nchannels_active;	/* #of c=
hannels that are not DISCONNECTED */=0A-	atomic_t nchannels_engaged;	/* #of=
 channels engaged with remote part */=0A+	atomic_t nchannels_active;  /* #o=
f channels that are not DISCONNECTED */=0A+	atomic_t nchannels_engaged;  /*=
 #of channels engaged with remote part */=0A 	struct xpc_channel *channels;=
	/* array of channel structures */=0A =0A 	void *local_GPs_base;	/* base ad=
dress of kmalloc'd space */=0A 	struct xpc_gp *local_GPs;	/* local Get/Put =
values */=0A 	void *remote_GPs_base;	/* base address of kmalloc'd space */=
=0A-	struct xpc_gp *remote_GPs;	/* copy of remote partition's local Get/Put=
 */=0A-	/* values */=0A+	struct xpc_gp *remote_GPs;/* copy of remote partit=
ion's local Get/Put */=0A+				  /* values */=0A 	u64 remote_GPs_pa;	/* phys=
 address of remote partition's local */=0A-	/* Get/Put values */=0A+				/* =
Get/Put values */=0A =0A 	/* fields used to pass args when opening or closi=
ng a channel */=0A =0A-	void *local_openclose_args_base;	/* base address of=
 kmalloc'd space */=0A-	struct xpc_openclose_args *local_openclose_args;	/*=
 local's args */=0A-	void *remote_openclose_args_base;	/* base address of k=
malloc'd space */=0A-	struct xpc_openclose_args *remote_openclose_args;	/* =
copy of remote's */=0A-	/* args */=0A+	void *local_openclose_args_base;   /=
* base address of kmalloc'd space */=0A+	struct xpc_openclose_args *local_o=
penclose_args;      /* local's args */=0A+	void *remote_openclose_args_base=
;  /* base address of kmalloc'd space */=0A+	struct xpc_openclose_args *rem=
ote_openclose_args; /* copy of remote's */=0A+							  /* args */=0A 	u64 r=
emote_openclose_args_pa;	/* phys addr of remote's args */=0A =0A 	/* IPI se=
nding, receiving and handling related fields */=0A@@ -631,7 +633,7 @@ struc=
t xpc_partition {=0A =0A /* struct xpc_partition flags */=0A =0A-#define	XP=
C_P_RAMOSREGISTERED	0x00000001	/* remote AMOs were registered */=0A+#define=
	XPC_P_RAMOSREGISTERED	0x00000001    /* remote AMOs were registered */=0A =
=0A /* struct xpc_partition act_state values (for XPC HB) */=0A =0A@@ -725,=
9 +727,8 @@ extern void xpc_teardown_infrastructure(=0A static inline void=
=0A xpc_wakeup_channel_mgr(struct xpc_partition *part)=0A {=0A-	if (atomic_=
inc_return(&part->channel_mgr_requests) =3D=3D 1) {=0A+	if (atomic_inc_retu=
rn(&part->channel_mgr_requests) =3D=3D 1)=0A 		wake_up(&part->channel_mgr_w=
q);=0A-	}=0A }=0A =0A /*=0A@@ -746,9 +747,8 @@ xpc_msgqueue_deref(struct xp=
c_channel *c=0A 	s32 refs =3D atomic_dec_return(&ch->references);=0A =0A 	D=
BUG_ON(refs < 0);=0A-	if (refs =3D=3D 0) {=0A+	if (refs =3D=3D 0)=0A 		xpc_=
wakeup_channel_mgr(&xpc_partitions[ch->partid]);=0A-	}=0A }=0A =0A #define =
XPC_DISCONNECT_CHANNEL(_ch, _reason, _irqflgs) \=0A@@ -764,9 +764,8 @@ xpc_=
part_deref(struct xpc_partition *par=0A 	s32 refs =3D atomic_dec_return(&pa=
rt->references);=0A =0A 	DBUG_ON(refs < 0);=0A-	if (refs =3D=3D 0 && part->=
setup_state =3D=3D XPC_P_SS_WTEARDOWN) {=0A+	if (refs =3D=3D 0 && part->set=
up_state =3D=3D XPC_P_SS_WTEARDOWN)=0A 		wake_up(&part->teardown_wq);=0A-	}=
=0A }=0A =0A static inline int=0A@@ -776,9 +775,9 @@ xpc_part_ref(struct xp=
c_partition *part)=0A =0A 	atomic_inc(&part->references);=0A 	setup =3D (pa=
rt->setup_state =3D=3D XPC_P_SS_SETUP);=0A-	if (!setup) {=0A+	if (!setup)=
=0A 		xpc_part_deref(part);=0A-	}=0A+=0A 	return setup;=0A }=0A =0A@@ -955,=
7 +954,7 @@ xpc_activate_IRQ_send(u64 amos_page_pa, =0A 					BIT_MASK(from_=
nasid / 2),=0A 					remote_amo, to_nasid,=0A 					to_phys_cpuid, SGI_XPC_AC=
TIVATE);=0A-	BUG_ON(!remote_amo && ret !=3D xpSuccess);	/* should never hap=
pen */=0A+	BUG_ON(!remote_amo && ret !=3D xpSuccess);      /* should never =
happen */=0A }=0A =0A static inline void=0A@@ -1150,9 +1149,8 @@ xpc_check_=
for_channel_activity(struct xp=0A =0A 	ret =3D xp_get_amo(part->local_IPI_a=
mo_va, XP_AMO_CLEAR, &IPI_amo);=0A 	BUG_ON(ret !=3D xpSuccess);	/* should n=
ever happen */=0A-	if (IPI_amo =3D=3D 0) {=0A+	if (IPI_amo =3D=3D 0)=0A 		r=
eturn;=0A-	}=0A =0A 	spin_lock_irqsave(&part->IPI_lock, irq_flags);=0A 	par=
t->local_IPI_amo |=3D IPI_amo;=0AIndex: linux-2.6/drivers/misc/xp/xp_sn2.c=
=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A--- linux-2.6.orig=
/drivers/misc/xp/xp_sn2.c	2008-03-25 07:10:15.693148179 -0500=0A+++ linux-2=
=2E6/drivers/misc/xp/xp_sn2.c	2008-03-25 07:10:17.829414703 -0500=0A@@ -22,=
8 +22,6 @@=0A #include <asm/sn/sn_sal.h>=0A #include "xp.h"=0A =0A-extern s=
truct device *xp;=0A-=0A /*=0A  * Register a nofault code region which perf=
orms a cross-partition PIO read.=0A  * If the PIO read times out, the MCA h=
andler will consume the error and=0A@@ -187,10 +185,10 @@ xp_set_amo_sn2(u6=
4 *amo_va, int op, u64 =0A 		 * it until the heartbeat times out.=0A 		 */=
=0A 		if (xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(amo_va),=0A-				=
			   xp_nofault_PIOR_target))=0A-		    !=3D 0)=0A+							xp_nofault_PIOR_t=
arget))=0A+		    !=3D 0) {=0A 			ret =3D xpPioReadError;=0A-=0A+		}=0A 		lo=
cal_irq_restore(irq_flags);=0A 	}=0A =0A@@ -226,10 +224,10 @@ xp_set_amo_wi=
th_interrupt_sn2(u64 *amo_v=0A 		 * it until the heartbeat times out.=0A 		=
 */=0A 		if (xp_nofault_PIOR((u64 *)GLOBAL_MMR_ADDR(NASID_GET(amo_va),=0A-	=
						   xp_nofault_PIOR_target))=0A-		    !=3D 0)=0A+							xp_nofault_PIO=
R_target))=0A+		    !=3D 0) {=0A 			ret =3D xpPioReadError;=0A-=0A+		}=0A 	=
	local_irq_restore(irq_flags);=0A 	}=0A =0A@@ -323,10 +321,10 @@ xp_change_=
memprotect_shub_wars_1_1_sn2(i=0A 			/* save current protection values */=
=0A 			xpc_prot_vec[node] =3D=0A 			    (u64)HUB_L((u64 *)GLOBAL_MMR_ADDR(n=
asid,=0A-							      SH1_MD_DQLP_MMR_DIR_PRIVEC0));=0A+						  SH1_MD_DQLP=
_MMR_DIR_PRIVEC0));=0A 			/* open up everything */=0A 			HUB_S((u64 *)GLOBA=
L_MMR_ADDR(nasid,=0A-						     SH1_MD_DQLP_MMR_DIR_PRIVEC0),=0A+						   S=
H1_MD_DQLP_MMR_DIR_PRIVEC0),=0A 			      -1UL);=0A 			HUB_S((u64 *)=0A 			 =
     GLOBAL_MMR_ADDR(nasid,=0A@@ -338,15 +336,16 @@ xp_change_memprotect_sh=
ub_wars_1_1_sn2(i=0A 			nasid =3D cnodeid_to_nasid(node);=0A 			/* restore =
original protection values */=0A 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid,=0A-=
						     SH1_MD_DQLP_MMR_DIR_PRIVEC0),=0A+						   SH1_MD_DQLP_MMR_DIR_PR=
IVEC0),=0A 			      xpc_prot_vec[node]);=0A 			HUB_S((u64 *)=0A 			      GL=
OBAL_MMR_ADDR(nasid,=0A 					      SH1_MD_DQRP_MMR_DIR_PRIVEC0),=0A 			    =
  xpc_prot_vec[node]);=0A 		}=0A-	} else=0A+	} else {=0A 		BUG();=0A+	}=0A =
}=0A =0A /* SH_IPI_ACCESS shub register value on startup */=0AIndex: linux-=
2.6/drivers/misc/xp/xp_main.c=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=0A--- linux-2.6.orig/drivers/misc/xp/xp_main.c	2008-03-25 07:10:1=
5.697148678 -0500=0A+++ linux-2.6/drivers/misc/xp/xp_main.c	2008-03-25 07:1=
0:17.845416699 -0500=0A@@ -38,38 +38,58 @@ struct device *xp =3D &xp_dbg_su=
bname;=0A u64 xp_nofault_PIOR_target;=0A =0A short xp_partition_id;=0A+EXPO=
RT_SYMBOL_GPL(xp_partition_id);=0A u8 xp_region_size;=0A+EXPORT_SYMBOL_GPL(=
xp_region_size);=0A unsigned long xp_rtc_cycles_per_second;=0A+EXPORT_SYMBO=
L_GPL(xp_rtc_cycles_per_second);=0A =0A enum xp_retval (*xp_remote_memcpy) =
(void *dst, const void *src, size_t len);=0A+EXPORT_SYMBOL_GPL(xp_remote_me=
mcpy);=0A =0A enum xp_retval (*xp_register_remote_amos) (u64 paddr, size_t =
len);=0A+EXPORT_SYMBOL_GPL(xp_register_remote_amos);=0A enum xp_retval (*xp=
_unregister_remote_amos) (u64 paddr, size_t len);=0A+EXPORT_SYMBOL_GPL(xp_u=
nregister_remote_amos);=0A =0A int xp_sizeof_nasid_mask;=0A+EXPORT_SYMBOL_G=
PL(xp_sizeof_nasid_mask);=0A int xp_sizeof_amo;=0A+EXPORT_SYMBOL_GPL(xp_siz=
eof_amo);=0A =0A u64 *(*xp_alloc_amos) (int n_amos);=0A+EXPORT_SYMBOL_GPL(x=
p_alloc_amos);=0A void (*xp_free_amos) (u64 *amos_page, int n_amos);=0A+EXP=
ORT_SYMBOL_GPL(xp_free_amos);=0A =0A enum xp_retval (*xp_set_amo) (u64 *amo=
_va, int op, u64 operand, int remote);=0A+EXPORT_SYMBOL_GPL(xp_set_amo);=0A=
 enum xp_retval (*xp_set_amo_with_interrupt) (u64 *amo_va, int op, u64 oper=
and,=0A 					     int remote, int nasid,=0A 					     int phys_cpuid, int v=
ector);=0A+EXPORT_SYMBOL_GPL(xp_set_amo_with_interrupt);=0A =0A enum xp_ret=
val (*xp_get_amo) (u64 *amo_va, int op, u64 *amo_value_addr);=0A+EXPORT_SYM=
BOL_GPL(xp_get_amo);=0A =0A enum xp_retval (*xp_get_partition_rsvd_page_pa)=
 (u64 buf, u64 *cookie,=0A 						 u64 *paddr, size_t *len);=0A+EXPORT_SYMBO=
L_GPL(xp_get_partition_rsvd_page_pa);=0A =0A enum xp_retval (*xp_change_mem=
protect) (u64 paddr, size_t len, int request,=0A 					u64 *nasid_array);=0A=
+EXPORT_SYMBOL_GPL(xp_change_memprotect);=0A void (*xp_change_memprotect_sh=
ub_wars_1_1) (int request);=0A+EXPORT_SYMBOL_GPL(xp_change_memprotect_shub_=
wars_1_1);=0A void (*xp_allow_IPI_ops) (void);=0A+EXPORT_SYMBOL_GPL(xp_allo=
w_IPI_ops);=0A void (*xp_disallow_IPI_ops) (void);=0A+EXPORT_SYMBOL_GPL(xp_=
disallow_IPI_ops);=0A =0A int (*xp_cpu_to_nasid) (int cpuid);=0A+EXPORT_SYM=
BOL_GPL(xp_cpu_to_nasid);=0A int (*xp_node_to_nasid) (int nid);=0A+EXPORT_S=
YMBOL_GPL(xp_node_to_nasid);=0A =0A /*=0A  * Initialize the XPC interface t=
o indicate that XPC isn't loaded.=0A@@ -90,6 +110,7 @@ struct xpc_interface=
 xpc_interface =3D {=0A 	(void (*)(short, int, void *))xpc_notloaded,=0A 	(=
enum xp_retval(*)(short, void *))xpc_notloaded=0A };=0A+EXPORT_SYMBOL_GPL(x=
pc_interface);=0A =0A /*=0A  * XPC calls this when it (the XPC module) has =
been loaded.=0A@@ -112,6 +133,7 @@ xpc_set_interface(void (*connect) (int),=
=0A 	xpc_interface.received =3D received;=0A 	xpc_interface.partid_to_nasid=
s =3D partid_to_nasids;=0A }=0A+EXPORT_SYMBOL_GPL(xpc_set_interface);=0A =
=0A /*=0A  * XPC calls this when it (the XPC module) is being unloaded.=0A@=
@ -133,12 +155,14 @@ xpc_clear_interface(void)=0A 	xpc_interface.partid_to_=
nasids =3D (enum xp_retval(*)(short, void *))=0A 	    xpc_notloaded;=0A }=
=0A+EXPORT_SYMBOL_GPL(xpc_clear_interface);=0A =0A /*=0A  * xpc_registratio=
ns[] keeps track of xpc_connect()'s done by the kernel-level=0A  * users of=
 XPC.=0A  */=0A struct xpc_registration xpc_registrations[XPC_NCHANNELS];=
=0A+EXPORT_SYMBOL_GPL(xpc_registrations);=0A =0A /*=0A  * Register for auto=
matic establishment of a channel connection whenever=0A@@ -177,9 +201,8 @@ =
xpc_connect(int ch_number, xpc_channel_f=0A =0A 	registration =3D &xpc_regi=
strations[ch_number];=0A =0A-	if (mutex_lock_interruptible(&registration->m=
utex) !=3D 0) {=0A+	if (mutex_lock_interruptible(&registration->mutex) !=3D=
 0)=0A 		return xpInterrupted;=0A-	}=0A =0A 	/* if XPC_CHANNEL_REGISTERED(c=
h_number) */=0A 	if (registration->func !=3D NULL) {=0A@@ -201,6 +224,7 @@ =
xpc_connect(int ch_number, xpc_channel_f=0A =0A 	return xpSuccess;=0A }=0A+=
EXPORT_SYMBOL_GPL(xpc_connect);=0A =0A /*=0A  * Remove the registration for=
 automatic connection of the specified channel=0A@@ -251,9 +275,7 @@ xpc_di=
sconnect(int ch_number)=0A =0A 	return;=0A }=0A-=0A-extern enum xp_retval x=
p_init_sn2(void);=0A-extern enum xp_retval xp_init_uv(void);=0A+EXPORT_SYMB=
OL_GPL(xpc_disconnect);=0A =0A int __init=0A xp_init(void)=0A@@ -268,23 +29=
0,18 @@ xp_init(void)=0A 	else=0A 		ret =3D xpUnsupported;=0A =0A-	if (ret =
!=3D xpSuccess) {=0A+	if (ret !=3D xpSuccess)=0A 		return -ENODEV;=0A-	}=0A=
 =0A 	/* initialize the connection registration mutex */=0A-	for (ch_number=
 =3D 0; ch_number < XPC_NCHANNELS; ch_number++) {=0A+	for (ch_number =3D 0;=
 ch_number < XPC_NCHANNELS; ch_number++)=0A 		mutex_init(&xpc_registrations=
[ch_number].mutex);=0A-	}=0A =0A 	return 0;=0A }=0A =0A module_init(xp_init=
);=0A =0A-extern void xp_exit_sn2(void);=0A-extern void xp_exit_uv(void);=
=0A-=0A void __exit=0A xp_exit(void)=0A {=0A@@ -299,30 +316,3 @@ module_exi=
t(xp_exit);=0A MODULE_AUTHOR("Silicon Graphics, Inc.");=0A MODULE_DESCRIPTI=
ON("Cross Partition (XP) base");=0A MODULE_LICENSE("GPL");=0A-=0A-EXPORT_SY=
MBOL(xp_partition_id);=0A-EXPORT_SYMBOL(xp_region_size);=0A-EXPORT_SYMBOL(x=
p_rtc_cycles_per_second);=0A-EXPORT_SYMBOL(xp_remote_memcpy);=0A-EXPORT_SYM=
BOL(xp_register_remote_amos);=0A-EXPORT_SYMBOL(xp_unregister_remote_amos);=
=0A-EXPORT_SYMBOL(xp_sizeof_nasid_mask);=0A-EXPORT_SYMBOL(xp_sizeof_amo);=
=0A-EXPORT_SYMBOL(xp_alloc_amos);=0A-EXPORT_SYMBOL(xp_free_amos);=0A-EXPORT=
_SYMBOL(xp_set_amo);=0A-EXPORT_SYMBOL(xp_set_amo_with_interrupt);=0A-EXPORT=
_SYMBOL(xp_get_amo);=0A-EXPORT_SYMBOL(xp_get_partition_rsvd_page_pa);=0A-EX=
PORT_SYMBOL(xp_change_memprotect);=0A-EXPORT_SYMBOL(xp_change_memprotect_sh=
ub_wars_1_1);=0A-EXPORT_SYMBOL(xp_allow_IPI_ops);=0A-EXPORT_SYMBOL(xp_disal=
low_IPI_ops);=0A-EXPORT_SYMBOL(xp_cpu_to_nasid);=0A-EXPORT_SYMBOL(xp_node_t=
o_nasid);=0A-EXPORT_SYMBOL(xpc_registrations);=0A-EXPORT_SYMBOL(xpc_interfa=
ce);=0A-EXPORT_SYMBOL(xpc_clear_interface);=0A-EXPORT_SYMBOL(xpc_set_interf=
ace);=0A-EXPORT_SYMBOL(xpc_connect);=0A-EXPORT_SYMBOL(xpc_disconnect);=0AIn=
dex: linux-2.6/drivers/misc/xp/xp_uv.c=0A=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=0A--- linux-2.6.orig/drivers/misc/xp/xp_uv.c	2008-03-25 =
07:10:15.697148678 -0500=0A+++ linux-2.6/drivers/misc/xp/xp_uv.c	2008-03-25=
 07:10:17.861418696 -0500=0A@@ -18,8 +18,6 @@=0A #include <linux/device.h>=
=0A #include "xp.h"=0A =0A-extern struct device *xp;=0A-=0A static enum xp_=
retval=0A xp_register_nofault_code_uv(void)=0A {=0A
