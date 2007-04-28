Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXD1FSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXD1FSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXD1FSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:18:22 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754681AbXD1FST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:18:19 -0400
Date: Fri, 27 Apr 2007 22:18:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-Id: <20070427221803.2a117c23.akpm@linux-foundation.org>
In-Reply-To: <20070428030805.GA13331@redhat.com>
References: <20070423141123.GA21174@skybase>
	<20070423104534.51bac974.akpm@linux-foundation.org>
	<20070425112133.4ae86399.randy.dunlap@oracle.com>
	<20070425143011.57247c1d.akpm@linux-foundation.org>
	<20070425172447.1576c399.akpm@linux-foundation.org>
	<20070426003911.GA19383@redhat.com>
	<4630109F.6090002@oracle.com>
	<20070425200207.77a2721a.akpm@linux-foundation.org>
	<20070428030805.GA13331@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 23:08:05 -0400 Dave Jones <davej@redhat.com> wrote:

> You can find the script at http://www.codemonkey.org.uk/projects/checkpatch/

hm.

box:/usr/src/25> ~/checkpatch.pl patches/slub-core.patch
Checking patches/slub-core.patch:  signoffs = 30        
Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
1588:+  VM_BUG_ON(!irqs_disabled());
1834:+  BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
2538:+  BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
2544:+  BUG_ON(!page);
2546:+  BUG_ON(!n);
2736:+          BUG_ON(err);
2762:+  BUG_ON(flags & SLUB_UNIMPLEMENTED);
2777:+          BUG_ON(flags & (SLAB_RED_ZONE | SLAB_POISON |
2779:+          BUG_ON(ctor || dtor);
3054:+  BUG_ON(index < 0);
3118:+  BUG_ON(!page);
3120:+  BUG_ON(!s);
4062:+  BUG_ON(!name);
4083:+  BUG_ON(p > name + ID_STR_LENGTH - 1);
4188:+          BUG_ON(err);

15 warnings


surely we can do better than that ;)


box:/usr/src/25> ~/checkpatch.pl patches/git-ieee1394.patch 
Checking patches/git-ieee1394.patch:  signoffs = 291
Do not add new typedefs.
5239:+typedef int (*descriptor_callback_t)(struct context *ctx,
7254:+typedef void (*scsi_done_fn_t) (struct scsi_cmnd *);
8668:+typedef void (*fw_node_callback_t) (struct fw_card * card,
10077:+typedef void (*fw_packet_callback_t) (struct fw_packet *packet,
10080:+typedef void (*fw_transaction_callback_t)(struct fw_card *card, int rcode,
10085:+typedef void (*fw_address_callback_t)(struct fw_card *card,
10093:+typedef void (*fw_bus_reset_callback_t)(struct fw_card *handle,
10245:+typedef void (*fw_iso_callback_t) (struct fw_iso_context *context,

Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
4342:+  BUG_ON(j >= ARRAY_SIZE(group->attrs));
9868:+  BUG_ON(retval < 0);
9872:+  BUG_ON(retval < 0);
9876:+  BUG_ON(retval < 0);
9878:+  BUG_ON(retval < 0);
10952:+ BUG_ON(!kv || !associate || kv->key.id == CSR1212_KV_ID_DESCRIPTOR ||
10983:+ BUG_ON(!kv || !dir || dir->key.type != CSR1212_KV_TYPE_DIRECTORY);
11396:+ BUG_ON(!csr || !csr->ops || !csr->ops->allocate_addr_range ||
11750:+ BUG_ON(!csr);
11802:+                 BUG_ON(csr->max_rom < 1);
12106:+ BUG_ON(!csr || !kv || csr->max_rom < 1);
12248:+ BUG_ON(!csr || !csr->ops || !csr->ops->bus_read);
14541:+         BUG_ON(max_payload < 512 - ETHER1394_GASP_OVERHEAD);
14567:+         BUG_ON(max_payload < 512 - ETHER1394_GASP_OVERHEAD);
15213:+         BUG_ON(!list_empty(&packet->driver_list) ||

23 warnings

ok.

box:/usr/src/25> ~/checkpatch.pl patches/git-net.patch     
Checking patches/git-net.patch:  signoffs = 831
Do not add new typedefs.
18871:+typedef unsigned int sk_buff_data_t;
18873:+typedef unsigned char *sk_buff_data_t;
20686:+typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *, void *);
20687:+typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);

Incorrect type usage for kernel code. Use __u32 etc.
21854:+uint32_t __attribute__((weak)) __div64_32(uint64_t *n, uint32_t base)
21865:+ uint32_t high, d;

Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
11084:+         BUG_ON(ip_hdr(skb)->protocol != IPPROTO_TCP);
21600:+ BUG_ON(!wiphy);
21633:+ BUG_ON(!wdev);
25577:+                         BUG_ON(r->ctarget != NULL);
26832:+ BUG_ON(msgindex < 0 || msgindex >= RTM_NR_MSGTYPES);
26882:+ BUG_ON(protocol < 0 || protocol >= NPROTO);
26936:+ BUG_ON(protocol < 0 || protocol >= NPROTO);
26959:+ BUG_ON(protocol < 0 || protocol >= NPROTO);
27772:+ BUG_ON(len);
30411:+         BUG_ON(hctx->ccid3hctx_p && !hctx->ccid3hctx_x_calc);
30626:+ BUG_ON(hctx == NULL);
32199:+ BUG_ON(ptr == NULL);
32217:+ BUG_ON(ptr == NULL);
58250:+ BUILD_BUG_ON(sizeof(struct illinois) > ICSK_CA_PRIV_SIZE);
61747:+ BUG_ON(sizeof(struct yeah) > ICSK_CA_PRIV_SIZE);
63079:+ BUG_ON(pad < 0);
69953:+ BUG_ON(sk == NULL);
69962:+ BUG_ON(self == NULL);
70883:+ BUG_ON(destroy == NULL);
80348:+ BUG_ON(!wiphy);

Don't init statics to 0/NULL:
61061:+static int port __read_mostly = 0;
70417:+static int hashbin_lock_depth = 0;

28 warnings

Bad David.


git-ocfs2.patch: couple fo new typedefs, zillions of BUG_ONs

box:/usr/src/25> ~/checkpatch.pl patches/git-libata-all.patch 
Checking patches/git-libata-all.patch:  signoffs = 167
Do not add new typedefs.
14867:+typedef int (*ata_prereset_fn_t)(struct ata_port *ap, unsigned long deadline);
14868:+typedef int (*ata_reset_fn_t)(struct ata_port *ap, unsigned int *classes,

Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
5426:+  BUG_ON(!legacy_dr);

Don't init statics to 0/NULL:
2861:+static int ata_ignore_hpa = 0;



box:/usr/src/25> ~/checkpatch.pl patches/git-ia64.patch      
Checking patches/git-ia64.patch:  signoffs = 38
Do not add new typedefs.
875:+typedef unsigned long u64;
876:+typedef unsigned int  u32;
878:+typedef union err_type_info_u {
890:+typedef union err_struct_info_u {
930:+typedef union err_data_buffer_u {
954:+typedef union capabilities_u {
1009:+typedef struct resources_s {
1443:+typedef struct {

box:/usr/src/25> ~/checkpatch.pl patches/git-scsi-misc.patch 
Checking patches/git-scsi-misc.patch:  signoffs = 165
Incorrect type usage for kernel code. Use __u32 etc.
7802:+                  uint32_t len;
7803:+                  uint32_t sense_len;

Don't init statics to 0/NULL:
4782:+static unsigned int ipr_transop_timeout = 0;

c'mon, this is scsi - it's full of low-hanging fruit.


box:/usr/src/25> ~/checkpatch.pl patches/git-mtd.patch      
Checking patches/git-mtd.patch:  signoffs = 89
kmalloc return shouldn't be cast.
2085:+  msp_flash = (struct mtd_info **)kmalloc(
2087:+  msp_parts = (struct mtd_partition **)kmalloc(
2089:+  msp_maps = (struct map_info *)kmalloc(
2107:+          msp_parts[i] = (struct mtd_partition *)kmalloc(

Incorrect type usage for kernel code. Use __u32 etc.
4690:+uint32_t jffs2_truncate_fragtree(struct jffs2_sb_info *c, struct rb_root *list, uint32_t size)
5255:+  uint32_t highest_version;
5256:+  uint32_t latest_mctime;
5257:+  uint32_t mctime_ver;
5285:+uint32_t jffs2_truncate_fragtree (struct jffs2_sb_info *c, struct rb_root *list, uint32_t size);
5491:+  uint32_t crc, ofs, len;
5632:+static struct jffs2_tmp_dnode_info *jffs2_lookup_tn(struct rb_root *tn_root, uint32_t offset)
5680:+  uint32_t fn_end = tn->fn->ofs + tn->fn->size;
5908:+  uint32_t high_ver = 0;
6420:+  uint32_t crc, new_size;
6616:+                  uint32_t empty_start, scan_end;
6620:+                  scan_end = min_t(uint32_t, EMPTY_SCAN_SIZE(c->sector_size)/8, buf_len);
6628:+                          if (unlikely(*(uint32_t *)(&buf[inbuf_ofs]) != 0xffffffff)) {
6680:+  uint32_t crc, ino = je32_to_cpu(ri->ino);
	
Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
5494:+  BUG_ON(tn->csize == 0);
5611:+  BUG_ON(ref_obsolete(tn->fn->raw));
5859:+  BUG_ON(node->rb_right);
	
Don't init statics to 0/NULL:
1309:+static int nr_devices = 0;
2769:+static char *badblocks = NULL;
2770:+static char *weakblocks = NULL;
2771:+static char *weakpages = NULL;
2772:+static unsigned int bitflips = 0;
2773:+static char *gravepages = NULL;
2774:+static unsigned int rptwear = 0;
2775:+static unsigned int overridesize = 0;
2877:+static unsigned long *erase_block_wear = NULL;
2878:+static unsigned int wear_eb_count = 0;
2879:+static unsigned long total_wear = 0;
2880:+static unsigned int rptwear_cnt = 0;
	
33 warnings

That's more like it.  MTD is a whole world of 120-column lines and type
innovations.


box:/usr/src/25> ~/checkpatch.pl patches/git-powerpc.patch
Checking patches/git-powerpc.patch:  signoffs = 427       
kmalloc return shouldn't be cast.
10969:+ char *out = (char*)kmalloc(count + 1, GFP_KERNEL);

Use 'inline' instead of '__inline__'26644:+static __inline__ void atomic_scrub(void *va, u32 size)

Do not add new typedefs.
7336:+typedef struct bd_info {

Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
13629:+ BUG_ON(linear_map_hash_slots[lmi] & 0x80);
13641:+ BUG_ON(!(linear_map_hash_slots[lmi] & 0x80));
13880:+         BUG_ON(pte_val(*pg) & (_PAGE_PRESENT | _PAGE_HASHPTE));
13922:+ BUG_ON(PageHighMem(page));
15543:+ BUG_ON(mpic == NULL);
16671:+         BUG_ON(!tmp_np);
17745:+ BUG_ON(spu_coredump_calls != calls);
17887:+ BUG_ON(!list_empty(&ctx->rq));
19057:+         BUG_ON(list_empty(rq));
24237:+ BUG_ON(intsize != 2);
24271:+ BUG_ON(! device_is_compatible(node, "ibm,uic"));
24335:+ BUG_ON(!np); /* uic_init_tree() assumes there's a UIC as the
24383:+ BUG_ON(! primary_uic);

16 warnings

box:/usr/src/25> ~/checkpatch.pl patches/git-input.patch      
Checking patches/git-input.patch:  signoffs = 85
Incorrect type usage for kernel code. Use __u32 etc.
4164:+  uint32_t mask;
4185:+  uint32_t status;

Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
3504:+  BUG_ON(kbd == NULL);
3540:+  BUG_ON(kbd == NULL);
5595:+  BUG_ON(ptr == NULL);
5632:+  BUG_ON(ptr == NULL);
7873:+  BUG_ON(mlc->ddi >= 6);
8106:+  BUG_ON(down_trylock(&mlc->isem));
8142:+          BUG_ON(node->object.func == NULL);
8345:+  BUG_ON(map == NULL);
8353:+  BUG_ON(mlc == NULL);
8373:+  BUG_ON(drv == NULL);
8408:+  BUG_ON(map == NULL);
8415:+  BUG_ON(mlc == NULL);
8431:+  BUG_ON(map == NULL);
8438:+  BUG_ON(mlc == NULL);
8463:+  BUG_ON(mlc == NULL);
8511:+  BUG_ON(mlc == NULL);
9700:+  BUG_ON(down_trylock(&mlc->isem));
9701:+  BUG_ON(down_trylock(&mlc->osem));
9762:+  BUG_ON(down_trylock(&mlc->osem));
9781:+  BUG_ON(down_trylock(&mlc->csem));
9829:+  BUG_ON(mlc->opacket & HIL_CTRL_APE);

Don't init statics to 0/NULL:
11053:+static unsigned int channel_mask = 0xFFFF;

24 warnings


box:/usr/src/25> ~/checkpatch.pl patches/git-e1000.patch        
Checking patches/git-e1000.patch:  signoffs = 44
Do not add new typedefs.
21237:+typedef enum {
33390:+typedef enum {
36694:+typedef enum {
36701:+typedef enum {

4 warnings


box:/usr/src/25> ~/checkpatch.pl patches/git-alsa.patch 
Checking patches/git-alsa.patch:  signoffs = 297
0 warnings

whoa.

box:/usr/src/25> ~/checkpatch.pl patches/git-infiniband.patch 
Checking patches/git-infiniband.patch:  signoffs = 113
Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
8143:+  BUG_ON(mlx4_ib_alloc_db_from_pgdir(pgdir, db, order));
12629:+ BUG_ON(cmd->free_head < 0);
16580:+         BUG_ON(index < dev->caps.num_mgms);
16665:+                 BUG_ON(amgm_index_to_free < dev->caps.num_mgms);
16681:+         BUG_ON(index < dev->caps.num_mgms);

Don't init statics to 0/NULL:
10333:+         path->static_rate = 0;
15461:+static int msi_x = 0;
16113:+ static int mlx4_version_printed = 0;

8 warnings



box:/usr/src/25> ~/checkpatch.pl patches/git-wireless.patch        
Checking patches/git-wireless.patch:  signoffs = 2009
kmalloc return shouldn't be cast.
62076:+ a16 = (zd_addr_t *)kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),

Do not add new typedefs.
50317:+typedef void (debug_access_t)(struct rt2x00_dev *rt2x00dev,
64586:+typedef u16 __nocast zd_addr_t;
76135:+typedef enum { ALG_NONE, ALG_WEP, ALG_TKIP, ALG_CCMP, ALG_NULL }
76195:+typedef enum {
87265:+typedef enum {
87366:+typedef ieee80211_txrx_result (*ieee80211_tx_handler)
87369:+typedef ieee80211_txrx_result (*ieee80211_rx_handler)
87925:+typedef enum {
92694:+typedef enum { ParseOK = 0, ParseUnknown = 1, ParseFailed = -1 } ParseRes;
102286:+typedef int (*iw_compat_handler)(struct cfg80211_registered_device *drv,

Use WARN_ON & Recovery code rather than BUG() and BUG_ON()
23286:+ BUILD_BUG_ON(BCM43xx_SEC_KEYSIZE < ETH_ALEN);
33026:+ BUILD_BUG_ON(BCM43xx_TAB_ROTOR_SIZE != ARRAY_SIZE(bcm43xx_tab_rotor));
33027:+ BUILD_BUG_ON(BCM43xx_TAB_RETARD_SIZE != ARRAY_SIZE(bcm43xx_tab_retard));
33028:+ BUILD_BUG_ON(BCM43xx_TAB_FINEFREQA_SIZE != ARRAY_SIZE(bcm43xx_tab_finefreqa));
33029:+ BUILD_BUG_ON(BCM43xx_TAB_FINEFREQG_SIZE != ARRAY_SIZE(bcm43xx_tab_finefreqg));
33030:+ BUILD_BUG_ON(BCM43xx_TAB_NOISEA2_SIZE != ARRAY_SIZE(bcm43xx_tab_noisea2));
33031:+ BUILD_BUG_ON(BCM43xx_TAB_NOISEA3_SIZE != ARRAY_SIZE(bcm43xx_tab_noisea3));
33032:+ BUILD_BUG_ON(BCM43xx_TAB_NOISEG1_SIZE != ARRAY_SIZE(bcm43xx_tab_noiseg1));
33033:+ BUILD_BUG_ON(BCM43xx_TAB_NOISEG2_SIZE != ARRAY_SIZE(bcm43xx_tab_noiseg2));
33034:+ BUILD_BUG_ON(BCM43xx_TAB_NOISESCALEG_SIZE != ARRAY_SIZE(bcm43xx_tab_noisescaleg1));
33035:+ BUILD_BUG_ON(BCM43xx_TAB_NOISESCALEG_SIZE != ARRAY_SIZE(bcm43xx_tab_noisescaleg2));
33036:+ BUILD_BUG_ON(BCM43xx_TAB_NOISESCALEG_SIZE != ARRAY_SIZE(bcm43xx_tab_noisescaleg3));
33037:+ BUILD_BUG_ON(BCM43xx_TAB_SIGMASQR_SIZE != ARRAY_SIZE(bcm43xx_tab_sigmasqr1));
33038:+ BUILD_BUG_ON(BCM43xx_TAB_SIGMASQR_SIZE != ARRAY_SIZE(bcm43xx_tab_sigmasqr2));
49080:+ BUILD_BUG_ON(!(__mask) ||               \
49090:+ BUILD_BUG_ON(!(__mask) ||               \
70106:+ BUILD_BUG_ON(SSB_PCICORE_BCAST_ADDR != SSB_CHIPCO_BCAST_ADDR);
70107:+ BUILD_BUG_ON(SSB_PCICORE_BCAST_DATA != SSB_CHIPCO_BCAST_DATA);
74967:+ BUILD_BUG_ON(index >= SSB_EXTIF_NR_GPIOOUT);    \
74971:+ BUILD_BUG_ON(index >= SSB_EXTIF_NR_GPIOOUT);    \
76919:+ BUG_ON(!wiphy);
76952:+ BUG_ON(!wdev);
86065:+ BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
86769:+ BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
86927:+ BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) > sizeof(skb->cb));
88357:+ BUG_ON(dev == local->apdev);
99612:+ BUG_ON(IS_ERR(drv));
99875:+ BUG_ON(!wiphy);

Don't init statics to 0/NULL:
48899:+static int rt2x00_debug_level = 0;
88421:+static int ieee80211_regdom = 0x10; /* FCC */
88431:+static int ieee80211_japan_5ghz /* = 0 */;
94013:+         static unsigned long last_tsf_debug = 0;

43 warnings



A good start, thanks.  The BUG_ON() thing might be unpopular, but I think it's
for the best.  It should skip BUILD_BUG_ON though.


