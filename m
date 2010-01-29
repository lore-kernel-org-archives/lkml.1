Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720Ab0A2JBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0A2JBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280Ab0A2JBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:01:10 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:64149 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab0A2JBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:01:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=mYyruuHaAYfAMMZN5yIHuoSZk58TU5pIMj/pGsHGzK5N2D7jjRBVRycHPZmpB5+Yjy
         Za7h7SlxwVauhwHnXuAY4AiJDCxTBbpjLi51wJDJ4SNySFJJWNgh5rId3Ml7sQJhakgl
         nalgJSlE3CYXK4bk5wSR6CdG6CVk7foMYQ+qk=
Date: Fri, 29 Jan 2010 12:00:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: bug list: dereferencing first then checking
Message-ID: <20100129090049.GA5547@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These bugs are when code dereferences a variable and then checks that it is not null.
The new thing is that I wrote a shell script to try remove the false positives caused
by macros.  There are still some false positives because smatch is bad at handling 
loops and knowing when a container got redefined.

Sometimes the fixes are not obvious.

This is the output of: /path/to/smatch_scripts/filter_kernel_deref_check.sh warns.txt

regards,
dan carpenter

arch/x86/kernel/apic/io_apic.c +3234 'desc_new': if (desc_new)
kernel/trace/trace_events_filter.c +1400 'call': if (!call)
fs/afs/security.c +202 'xpermits': if (xpermits)
fs/btrfs/inode.c +5561 'old_inode': old_inode && S_ISREG(old_inode->i_mode)) {
fs/btrfs/free-space-cache.c +569 'info': if (info && info->bitmap) {
fs/cifs/file.c +1035 'file->f_path.dentry': if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
fs/cifs/file.c +1152 'file->f_path.dentry': if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
fs/coda/inode.c +204 'vc': if (vc)
fs/configfs/dir.c +1050 'origin': BUG_ON(!origin || !sd);
fs/dlm/lock.c +733 'lkb': if (!lkb)
fs/ecryptfs/crypto.c +347 'crypt_stat': BUG_ON(!crypt_stat || !crypt_stat->tfm
fs/efs/inode.c +299 'bh': if (bh) brelse(bh);
fs/efs/inode.c +304 'bh': if (bh) brelse(bh);
fs/ext4/move_extent.c +691 'dext': if (!dext) {
fs/fscache/page.c +712 'page': if (page) {
fs/gfs2/bmap.c +656 'new': BUG_ON(!new);
fs/nfs/nfs4proc.c +4445 'clp': BUG_ON(clp == NULL);
fs/ntfs/attrib.c +350 'ni': BUG_ON(!ni);
fs/ntfs/attrib.c +473 'ni': BUG_ON(!ni);
fs/ntfs/mft.c +1990 'ctx': if (ctx)
fs/ocfs2/aops.c +282 'page': mlog_entry("(0x%p, %lu)\n", file, (page ? page->index : 0));
fs/ocfs2/aops.c +282 'page': mlog_entry("(0x%p, %lu)\n", file, (page ? page->index : 0));
fs/ocfs2/aops.c +282 'page': mlog_entry("(0x%p, %lu)\n", file, (page ? page->index : 0));
fs/ocfs2/dlmglue.c +1524 'inode': BUG_ON(!inode);
fs/ocfs2/dlmglue.c +1572 'inode': BUG_ON(!inode);
fs/ocfs2/dlmglue.c +1625 'inode': BUG_ON(!inode);
fs/ocfs2/dlmglue.c +1653 'inode': BUG_ON(!inode);
fs/ocfs2/dlmglue.c +2252 'inode': BUG_ON(!inode);
fs/ocfs2/journal.c +353 'osb': BUG_ON(!osb || !osb->journal->j_journal);
fs/ocfs2/namei.c +1238 'newfe_bh': mlog(0, "aha rename over existing... new_blkno=%llu "
fs/ocfs2/namei.c +1238 'newfe_bh': mlog(0, "aha rename over existing... new_blkno=%llu "
fs/ocfs2/namei.c +1238 'newfe_bh': mlog(0, "aha rename over existing... new_blkno=%llu "
fs/ocfs2/dlm/dlmrecovery.c +1773 'lock': if (lock)
fs/proc/kcore.c +493 'm': if (m == NULL) {
fs/reiserfs/lbalance.c +895 'bi': if (bi && bi->tb)
fs/reiserfs/ibalance.c +298 'src': RFALSE(dest == NULL || src == NULL,
fs/ubifs/io.c +704 'wbuf': ubifs_assert(wbuf && lnum >= 0 && lnum < c->leb_cnt && offs >= 0);
fs/ubifs/tnc.c +1654 'wbuf': ubifs_assert(wbuf && lnum >= 0 && lnum < c->leb_cnt && offs >= 0);
fs/ubifs/tnc.c +1900 'znode->parent': if (!znode->parent || znode->iip)
fs/ubifs/find.c +314 'lp': else if (idx_lp && !lp)
fs/xfs/xfs_dir2_leaf.c +1565 'dbp': else if (db != mp->m_dirdatablk && dbp != NULL) {
fs/xfs/xfs_dir2_node.c +1140 'args': ASSERT(args != NULL);
fs/xfs/xfs_log_recover.c +143 'bp': ASSERT(bp);
security/smack/smack_lsm.c +2322 'opt_dentry': if (opt_dentry == NULL) {
drivers/atm/fore200e.c +1512 'vcc': ASSERT(vcc);
drivers/atm/fore200e.c +1573 'vcc': ASSERT(vcc);
drivers/block/aoe/aoecmd.c +196 '*t': if (t >= &d->targets[NTARGETS] || !*t)
drivers/char/ip2/ip2main.c +1637 'tty': if ( !tty || (tty->termios->c_cflag & HUPCL) ) {
drivers/char/pcmcia/synclink_cs.c +1100 'tty': if (tty)
drivers/char/pcmcia/synclink_cs.c +1110 'tty': if (tty)
drivers/char/mxser.c +2196 'tty': if (port->xmit_cnt < WAKEUP_CHARS && tty)
drivers/char/synclink.c +1372 'info->port.tty': if (info->port.tty)
drivers/char/synclink.c +1382 'info->port.tty': if (info->port.tty)
drivers/char/synclink.c +2034 'tty': if (!tty || !info->xmit_buf)
drivers/char/synclink.c +2124 'tty': if (!tty || !info->xmit_buf)
drivers/gpu/drm/nouveau/nouveau_object.c +891 'chan': if (!chan || !gpuobj_ret || *gpuobj_ret != NULL)
drivers/gpu/drm/nouveau/nouveau_sgdma.c +61 'nvbe': if (nvbe && nvbe->pages) {
drivers/gpu/drm/nouveau/nouveau_connector.c +91 'connector': if (!connector)
drivers/gpu/drm/nouveau/nv50_crtc.c +306 'crtc': if (!crtc)
drivers/gpu/drm/radeon/atombios_crtc.c +476 'encoder': if (!encoder)
drivers/gpu/drm/radeon/r600_blit.c +619 'dev_priv->blit_vb': if (!dev_priv->blit_vb)
drivers/gpu/drm/radeon/r600_blit.c +707 'dev_priv->blit_vb': if (!dev_priv->blit_vb)
drivers/gpu/drm/radeon/r600_blit.c +785 'dev_priv->blit_vb': if (!dev_priv->blit_vb)
drivers/gpu/drm/drm_lock.c +81 'master->lock.hw_lock': if (!master->lock.hw_lock) {
drivers/gpu/drm/drm_memory.c +80 'agpmem': if (!agpmem)
drivers/gpu/drm/drm_vm.c +140 'agpmem': if (!agpmem)
drivers/infiniband/hw/mlx4/cq.c +400 'cq->resize_buf': if (cq->resize_buf) {
drivers/isdn/hardware/eicon/message.c +4954 'plci': if(esc_cr[0] && plci)
drivers/isdn/hisax/l3dss1.c +2215 'pc': if (pc) dss1_release_l3_process(pc);
drivers/isdn/hisax/l3dss1.c +2220 'pc': if (pc)
drivers/isdn/hisax/l3ni1.c +2071 'pc': if (pc) ni1_release_l3_process(pc);
drivers/isdn/hisax/l3ni1.c +2076 'pc': if (pc)
drivers/isdn/hysdn/hysdn_net.c +193 'lp': if (!lp)
drivers/md/raid5.c +5120 'conf': if (conf) {
drivers/media/dvb/dvb-usb/anysee.c +482 'd': if (d)
drivers/media/dvb/dvb-usb/opera1.c +486 'fw': if (fw) {
drivers/media/dvb/frontends/stv0900_core.c +1357 'state->internal': if (state->internal == NULL) {
drivers/media/video/s2255drv.c +2605 'dev': if (dev) {
drivers/media/video/cx18/cx18-dvb.c +256 'stream': if (!stream)
drivers/media/video/cx18/cx18-dvb.c +288 'stream': if (stream) {
drivers/media/video/cx231xx/cx231xx-core.c +99 'dev': if (dev)
drivers/media/video/cx231xx/cx231xx-core.c +115 'dev': if (dev)
drivers/media/video/em28xx/em28xx-core.c +1173 'dev': if (dev)
drivers/media/video/em28xx/em28xx-core.c +1189 'dev': if (dev)
drivers/media/video/pvrusb2/pvrusb2-ctrl.c +516 'maskptr': if (maskptr) *maskptr = ~0;
drivers/media/video/pvrusb2/pvrusb2-ctrl.c +525 'maskptr': if (maskptr) *maskptr = 1;
drivers/media/video/pvrusb2/pvrusb2-ctrl.c +534 'maskptr': if (maskptr) *maskptr = ~0;
drivers/media/video/pvrusb2/pvrusb2-io.c +476 'sp': if (sp && sp->callback_func) {
drivers/media/video/pwc/pwc-ctrl.c +314 'pChoose': if (pChoose == NULL || pChoose->alternate == 0)
drivers/media/video/saa7164/saa7164-buffer.c +139 'port': if ((buf == 0) || (port == 0))
drivers/media/video/usbvideo/ibmcam.c +406 'uvd': assert(uvd != NULL);
drivers/media/video/usbvideo/quickcam_messenger.c +699 'uvd': if ((uvd == NULL) || (!uvd->streaming) || (uvd->dev == NULL))
drivers/message/fusion/mptbase.c +593 'reply': if (reply) {
drivers/message/i2o/i2o_block.c +724 'dev->i2o_dev': if (unlikely(!dev->i2o_dev)) {
drivers/message/i2o/i2o_scsi.c +535 'i2o_dev': if (unlikely(!i2o_dev)) {
drivers/mtd/chips/cfi_cmdset_0002.c +497 'mtd': if(mtd) {
drivers/mtd/chips/cfi_cmdset_0001.c +618 'mtd': if(mtd) {
drivers/mtd/devices/m25p80.c +466 'retlen': if (retlen)
drivers/mtd/devices/m25p80.c +784 'plat_id': if (plat_id)
drivers/net/can/usb/ems_usb.c +876 'skb': if (skb)
drivers/net/hamradio/yam.c +871 'dev': if (!dev || !yp->bitrate)
drivers/net/irda/nsc-ircc.c +1262 'self': IRDA_ASSERT(self != NULL, return 0;);
drivers/net/pcmcia/xirc2ps_cs.c +1558 'dev': pr_debug("%s: do_reset(%p,%d)\n", dev? dev->name:"eth?", dev, full);
drivers/net/qlge/qlge_main.c +1887 'net_rsp': net_rsp != NULL) {
drivers/net/tokenring/tms380tr.c +1355 'fw_entry': if (fw_entry)
drivers/net/tokenring/tms380tr.c +1361 'fw_entry': if (fw_entry)
drivers/net/wireless/at76c50x-usb.c +1533 'urb': if (urb)
drivers/net/wireless/rndis_wlan.c +2815 'priv': if (priv && priv->wpa_ie_len)
drivers/net/wireless/mac80211_hwsim.c +482 'data->channel': data->channel || !data2->channel ||
drivers/net/wireless/b43/main.c +3883 'dev': if (!dev || b43_status(dev) < B43_STAT_STARTED)
drivers/net/wireless/ipw2x00/ipw2200.c +8516 'rxb->skb': if (rxb->skb != NULL) {
drivers/net/wireless/ipw2x00/libipw_rx.c +803 'skb': if (skb) {
drivers/net/wireless/iwmc3200wifi/rx.c +797 'bss': if (!bss) {
drivers/net/wireless/libertas/if_usb.c +361 'priv': if (priv) {
drivers/net/wireless/wl12xx/wl1271_main.c +835 'wl': if (wl == NULL)
drivers/net/ppp_generic.c +1395 'pch->chan': if (pch->chan == NULL) {
drivers/net/ppp_synctty.c +598 'skb': if (skb && ap->flags & SC_LOG_OUTPKT)
drivers/pcmcia/pcmcia_ioctl.c +749 'link': if (link == NULL)
drivers/scsi/aacraid/aachba.c +1531 'fibptr': BUG_ON(fibptr == NULL);
drivers/scsi/aacraid/commsup.c +1736 'dev->queues': else if (!dev->queues)
drivers/scsi/bfa/bfa_fcxp.c +633 'fcxp': bfa_assert(fcxp != NULL);
drivers/scsi/cxgb3i/cxgb3i_pdu.c +464 'c3cn': if (c3cn) {
drivers/scsi/lpfc/lpfc_sli.c +4532 'pmbox': if (pmbox == NULL) {
drivers/scsi/lpfc/lpfc_els.c +2765 'ndlp': if (ndlp && NLP_CHK_NODE_ACT(ndlp) && delay) {
drivers/scsi/lpfc/lpfc_scsi.c +2234 'cmd->device': lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
drivers/scsi/megaraid/megaraid_mm.c +256 'adapter': if (!adapter) {
drivers/scsi/megaraid/megaraid_mm.c +754 'adapter': if (adapter) {
drivers/scsi/megaraid/megaraid_sas.c +3349 'instance->producer': if (instance->producer)
drivers/scsi/megaraid/megaraid_sas.c +3352 'instance->consumer': if (instance->consumer)
drivers/scsi/mvsas/mv_sas.c +1363 'mvi_dev': if (mvi_dev) {
drivers/scsi/pm8001/pm8001_sas.c +891 'pm8001_dev': if (pm8001_dev) {
drivers/scsi/qla2xxx/qla_os.c +2125 'vha': if (vha && vha->fc_vport)
drivers/scsi/qla2xxx/qla_init.c +3528 'fcport': if (fcport && fcport->drport &&
drivers/scsi/ncr53c8xx.c +4799 'np->ccb': if (np->ccb)
drivers/scsi/ncr53c8xx.c +5642 'tp': if ((!tp) || (!lp) || !sdev)
drivers/scsi/ncr53c8xx.c +5642 'sdev': if ((!tp) || (!lp) || !sdev)
drivers/scsi/ips.c +2798 'scb->scsi_cmd': if (scb->scsi_cmd) {
drivers/scsi/ips.c +2810 'scb->scsi_cmd': if (scb->scsi_cmd)
drivers/scsi/ips.c +3292 'scb->scsi_cmd': if (scb->scsi_cmd) {
drivers/scsi/ips.c +3300 'scb->scsi_cmd': if (scb->scsi_cmd) {
drivers/staging/arlan/arlan-proc.c +625 'ctl': if (ctl)
drivers/staging/comedi/drivers/pcmuio.c +471 'dev->private': if (devpriv && devpriv->sprivs)
drivers/staging/comedi/drivers/quatech_daqp_cs.c +1084 'dev': if (dev)
drivers/staging/cx25821/cx25821-video.c +969 'fh': if (fh) {
drivers/staging/cx25821/cx25821-audups11.c +349 'fh': if (fh) {
drivers/staging/hv/storvsc_drv.c +399 'scmnd': ASSERT(scmnd);
drivers/staging/hv/ChannelMgmt.c +644 'msgInfo': if (msgInfo) {
drivers/staging/line6/toneport.c +242 'toneport': if (toneport != NULL) {
drivers/staging/pohmelfs/config.c +305 'g': if (g)
drivers/staging/pohmelfs/config.c +315 'g': if (g) {
drivers/staging/pohmelfs/config.c +357 'g': if (g) {
drivers/staging/pohmelfs/dir.c +700 'inode': BUG_ON(!inode);
drivers/staging/rt2860/common/rtmp_init.c +3418 'pAd': if (pAd && (Status != NDIS_STATUS_SUCCESS)) {
drivers/staging/rt2870/common/../../rt2860/common/rtmp_init.c +3418 'pAd': if (pAd && (Status != NDIS_STATUS_SUCCESS)) {
drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c +771 'skb': if (skb) {
drivers/staging/rtl8192e/r8192E_core.c +3564 'skb': if(skb){
drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c +598 'sub_skb': if (sub_skb) {
drivers/staging/rtl8192e/ieee80211/rtl819x_BAProc.c +117 'ieee': if (pBA == NULL||ieee == NULL)
drivers/staging/rtl8192su/r8192U_core.c +1645 'skb': if(skb != NULL) {
drivers/staging/rtl8192su/r8192U_core.c +2635 'priv': if (priv == NULL)
drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c +546 'sub_skb': if (sub_skb) {
drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c +117 'ieee': if (pBA == NULL||ieee == NULL)
drivers/staging/rtl8192u/r8192U_core.c +1515 'skb': if(skb != NULL) {
drivers/staging/rtl8192u/r8192U_core.c +2411 'priv': if (priv == NULL)
drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c +590 'sub_skb': if (sub_skb) {
drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c +117 'ieee': if (pBA == NULL||ieee == NULL)
drivers/staging/serqt_usb2/serqt_usb2.c +366 'serial': if (!serial) {
drivers/staging/slicoss/slicoss.c +492 'adapter': ASSERT(adapter);
drivers/staging/slicoss/slicoss.c +571 'curr_card': ASSERT(curr_card);
drivers/staging/slicoss/slicoss.c +2551 'adapter': if ((adapter) && (adapter->state == ADAPT_UP) &&
drivers/staging/vt6656/main_usb.c +856 'pTxContext': if (pTxContext)
drivers/usb/host/ehci-dbg.c +616 'p.qh': if (p.qh) {
drivers/usb/host/ehci-sched.c +1002 'dev->tt': think_time = dev->tt ? dev->tt->think_time : 0;
drivers/usb/serial/io_ti.c +2140 'tty': if (tty)
drivers/usb/gadget/u_serial.c +399 'port->port_usb': if (!port->port_usb)
drivers/usb/gadget/u_serial.c +451 'port->port_usb': if (!port->port_usb)
drivers/usb/gadget/u_serial.c +399 'port->port_usb': if (!port->port_usb)
drivers/usb/gadget/u_serial.c +451 'port->port_usb': if (!port->port_usb)
drivers/usb/gadget/u_serial.c +399 'port->port_usb': if (!port->port_usb)
drivers/usb/gadget/u_serial.c +451 'port->port_usb': if (!port->port_usb)
sound/pci/ali5451/ali5451.c +880 'pvoice->substream': if (pvoice->pcm && pvoice->substream) {
net/9p/trans_rdma.c +247 'c': if (c)
net/dcb/dcbnl.c +1126 'skb': u32 pid = skb ? NETLINK_CB(skb).pid : 0;
net/decnet/dn_route.c +627 'dev': int)flags, (dev) ? dev->name : "???", len, skb->len,
net/ipv4/cipso_ipv4.c +480 'doi_def': if (doi_def == NULL || doi_def->doi == CIPSO_V4_DOI_UNKNOWN)
net/ipv6/proc.c +262 'idev': if (!idev || !idev->stats.proc_dir_entry)
net/irda/irlap_event.c +1458 'info': IRDA_ASSERT(info != NULL, return -1;);
net/irda/af_irda.c +596 'self->ias_result': if (self->ias_result)
net/irda/ircomm/ircomm_tty.c +499 'tty': if (!tty)
net/irda/ircomm/ircomm_tty.c +1010 'tty': if (!tty)
net/netfilter/nf_conntrack_netlink.c +1486 'exp': NLA_PUT_BE32(skb, CTA_EXPECT_ID, htonl((unsigned long)exp));
net/packet/af_packet.c +818 'skb': BUG_ON(skb == NULL);
net/sched/sch_api.c +348 's': if (!s || tsize != s->tsize || (!tab && tsize > 0))
net/sched/act_api.c +969 'skb': u32 pid = skb ? NETLINK_CB(skb).pid : 0;
net/sched/cls_tcindex.c +343 'arg': pr_debug("tcindex_change(tp %p,handle 0x%08x,tca %p,arg %p),opt %p,"
net/sctp/sm_statefuns.c +1275 'new_addr': if (!found && new_addr) {
net/sctp/sm_make_chunk.c +472 'chunk': if (chunk)
net/sctp/outqueue.c +332 'chunk': SCTP_DEBUG_PRINTK("outqueueing (%p, %p[%s])\n",
net/sctp/outqueue.c +332 'chunk->chunk_hdr': SCTP_DEBUG_PRINTK("outqueueing (%p, %p[%s])\n",
net/sunrpc/xprt.c +204 'task': if (task == NULL)
net/sunrpc/xprt.c +209 'req': if (req) {
net/sunrpc/xprt.c +220 'req': if (req && req->rq_ntrans)
net/sunrpc/cache.c +363 'current_detail': while (current_detail == NULL ||
net/wireless/scan.c +527 'wiphy': if (WARN_ON(!mgmt || !wiphy ||
net/xfrm/xfrm_policy.c +2254 'dst->xfrm': while (dst->xfrm);
lib/radix-tree.c +588 'node': if (node == NULL)
