Return-Path: <linux-kernel-owner+w=401wt.eu-S1762908AbYBUUZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762908AbYBUUZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbYBUUZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:25:26 -0500
Received: from ag-out-0708.google.com ([72.14.246.249]:47417 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbYBUUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:25:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c+kobaOY7ZWu07YUNNy+UOpP5sETxsJYjDZy2nsO6gLkGCFWSCB02Kakaa8iwdJEvmsaGCdJKrRomIPCKaixD5XtG0KL7s7Ioa1/+fOA5Bp56UMcqZCQ3GAJuhk7fowVmBxnZDZfS65Q4kvR8Lid1LSi4g/CC3Hv4MYyvfUEBC0=
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1203624563.26341.15.camel@johannes.berg>
References: <1203503909.17534.14.camel@johannes.berg>
	 <20080220195913.GE21139@uranus.ravnborg.org>
	 <1203597776.20331.5.camel@johannes.berg>
	 <20080221200620.GA29352@uranus.ravnborg.org>
	 <1203624563.26341.15.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 12:25:35 -0800
Message-Id: <1203625535.20345.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 21:09 +0100, Johannes Berg wrote:
> > > In any case, I would love to have __CHECK_ENDIAN__ enabled by default at
> > > least on the wireless code (just caught another bug with it...)
> > 
> > I should then add support for something like:
> > 
> > checkflags-y := -D__CHECK_ENDIAN__
> > 
> > to match the style of the rest.
> > 
> > I do not like all the buried in assumption about the
> > global variables.
> 
> That might be good. I retract my patch for now then.
> 
> > But I would prefer that someone would spend a few days looking into the
> > warnings generated with sparse.
> 
> I did spend a bit of time running it on all the tree, but wireless,
> where I do most work, is clean. 

Clean, or did you specifically mean bitwise-clean?

drivers/net/wireless/ipw2100.c:2837:7: warning: symbol 'i' shadows an earlier one
drivers/net/wireless/ipw2100.c:2760:9: originally declared here
drivers/net/wireless/ipw2100.c:7873:15: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2100.c:187:12: originally declared here
drivers/net/wireless/ipw2100.c:7937:11: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2100.c:187:12: originally declared here
drivers/net/wireless/ipw2100.c:7985:11: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2100.c:187:12: originally declared here
drivers/net/wireless/ipw2100.c:8253:13: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2100.c:8253:13: originally declared here
drivers/net/wireless/ipw2100.c:8253:13: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2100.c:8253:13: originally declared here
drivers/net/wireless/ipw2100.c:8253:13: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2100.c:8253:13: originally declared here
drivers/net/wireless/ipw2100.c:1929:15: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:1929:15:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:1929:15:    got int *<noident>
drivers/net/wireless/ipw2100.c:1937:69: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:1937:69:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:1937:69:    got int *<noident>
drivers/net/wireless/ipw2100.c:1945:60: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:1945:60:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:1945:60:    got int *<noident>
drivers/net/wireless/ipw2100.c:1952:65: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:1952:65:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:1952:65:    got int *<noident>
drivers/net/wireless/ipw2100.c:4071:66: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:4071:66:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:4071:66:    got int *<noident>
drivers/net/wireless/ipw2100.c:4078:15: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:4078:15:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:4078:15:    got int *<noident>
drivers/net/wireless/ipw2100.c:4084:60: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:4084:60:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:4084:60:    got int *<noident>
drivers/net/wireless/ipw2100.c:5275:6: warning: symbol 'ipw2100_queues_initialize' was not declared. Should it be static?
drivers/net/wireless/ipw2100.c:5282:6: warning: symbol 'ipw2100_queues_free' was not declared. Should it be static?
drivers/net/wireless/ipw2100.c:5289:5: warning: symbol 'ipw2100_queues_allocate' was not declared. Should it be static?
drivers/net/wireless/ipw2100.c:7146:66: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:7146:66:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:7146:66:    got int *<noident>
drivers/net/wireless/ipw2100.c:8322:20: warning: incorrect type in argument 4 (different signedness)
drivers/net/wireless/ipw2100.c:8322:20:    expected unsigned int [usertype] *len
drivers/net/wireless/ipw2100.c:8322:20:    got int *<noident>
drivers/net/wireless/ipw2200.c:833:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:877:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:921:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:966:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:1002:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:1037:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:1806:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:4253:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4253:12: originally declared here
drivers/net/wireless/ipw2200.c:6211:7: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:6327:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:6793:5: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2200.c:88:12: originally declared here
drivers/net/wireless/ipw2200.c:7888:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:8662:5: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:9665:6: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2200.c:88:12: originally declared here
drivers/net/wireless/ipw2200.c:9723:6: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2200.c:88:12: originally declared here
drivers/net/wireless/ipw2200.c:9829:6: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2200.c:88:12: originally declared here
drivers/net/wireless/ipw2200.c:10325:7: warning: symbol 'remaining_bytes' shadows an earlier one
drivers/net/wireless/ipw2200.c:10193:6: originally declared here
drivers/net/wireless/strip.c:490:16: error: bad constant expression
drivers/net/wireless/arlan-main.c:969:48: warning: incorrect type in initializer (different address spaces)
drivers/net/wireless/arlan-main.c:969:48:    expected struct arlan_shmem volatile [noderef] <asn:2>*arlan
drivers/net/wireless/arlan-main.c:969:48:    got struct arlan_shmem *<noident>
drivers/net/wireless/arlan-main.c:1088:11: warning: incorrect type in assignment (different address spaces)
drivers/net/wireless/arlan-main.c:1088:11:    expected struct arlan_shmem [noderef] <asn:2>*card
drivers/net/wireless/arlan-main.c:1088:11:    got void *<noident>
drivers/net/wireless/arlan-main.c:1776:19: warning: symbol 'arlan_probe' was not declared. Should it be static?
drivers/net/wireless/rtl8180_dev.c:138:42: warning: Using plain integer as NULL pointer
drivers/net/wireless/rtl8187_dev.c:116:41: warning: Using plain integer as NULL pointer
drivers/net/wireless/orinoco.c:3232:2: warning: context imbalance in 'orinoco_ioctl_getnick' - unexpected unlock
drivers/net/wireless/airo.c:3800:8: warning: symbol 'i' shadows an earlier one
drivers/net/wireless/airo.c:3711:6: originally declared here
drivers/net/wireless/airo.c:3807:8: warning: symbol 'i' shadows an earlier one
drivers/net/wireless/airo.c:3711:6: originally declared here
drivers/net/wireless/airo.c:3821:7: warning: symbol 'i' shadows an earlier one
drivers/net/wireless/airo.c:3711:6: originally declared here
drivers/net/wireless/airo.c:2092:14: warning: incorrect type in initializer (different signedness)
drivers/net/wireless/airo.c:2092:14:    expected unsigned int [usertype] *fids
drivers/net/wireless/airo.c:2092:14:    got int *<noident>
drivers/net/wireless/airo.c:2116:14: warning: incorrect type in initializer (different signedness)
drivers/net/wireless/airo.c:2116:14:    expected unsigned int [usertype] *fids
drivers/net/wireless/airo.c:2116:14:    got int *<noident>
drivers/net/wireless/airo.c:2157:14: warning: incorrect type in initializer (different signedness)
drivers/net/wireless/airo.c:2157:14:    expected unsigned int [usertype] *fids
drivers/net/wireless/airo.c:2157:14:    got int *<noident>
drivers/net/wireless/airo.c:2181:14: warning: incorrect type in initializer (different signedness)
drivers/net/wireless/airo.c:2181:14:    expected unsigned int [usertype] *fids
drivers/net/wireless/airo.c:2181:14:    got int *<noident>
drivers/net/wireless/airo.c:3612:6: warning: symbol 'mpi_receive_802_11' was not declared. Should it be static?
drivers/net/wireless/atmel.c:3174:6: warning: symbol 'atmel_join_bss' was not declared. Should it be static?
drivers/net/wireless/ath5k/base.c:1682:1: warning: context imbalance in 'ath5k_tasklet_rx' - different lock contexts for basic block
drivers/net/wireless/ath5k/hw.c:3764:10: warning: cast truncates bits from constant value (ffffffea becomes 0)
drivers/net/wireless/b43legacy/phy.c:1298:31: warning: potentially expensive pointer subtraction
drivers/net/wireless/b43legacy/phy.c:1298:31: warning: potentially expensive pointer subtraction
drivers/net/wireless/b43legacy/phy.c:1298:31: warning: potentially expensive pointer subtraction
drivers/net/wireless/b43legacy/pio.c:140:16: warning: potentially expensive pointer subtraction
drivers/net/wireless/bcm43xx/bcm43xx_main.c:3232:2: warning: context imbalance in 'bcm43xx_periodic_work_handler' - different lock contexts for basic block
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1470:31: warning: potentially expensive pointer subtraction
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1470:31: warning: potentially expensive pointer subtraction
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:1470:31: warning: potentially expensive pointer subtraction
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:94:6: warning: context imbalance in 'bcm43xx_raw_phy_lock' - different lock contexts for basic block
drivers/net/wireless/bcm43xx/bcm43xx_phy.c:120:4: warning: context imbalance in 'bcm43xx_raw_phy_unlock' - unexpected unlock
drivers/net/wireless/bcm43xx/bcm43xx_leds.c:38:20: warning: potentially expensive pointer subtraction
drivers/net/wireless/bcm43xx/bcm43xx_leds.c:77:20: warning: potentially expensive pointer subtraction
drivers/net/wireless/bcm43xx/bcm43xx_pio.c:140:16: warning: potentially expensive pointer subtraction
drivers/net/wireless/hostap/hostap_80211_rx.c:128:34: warning: symbol 'hdr' shadows an earlier one
drivers/net/wireless/hostap/hostap_80211_rx.c:67:29: originally declared here
drivers/net/wireless/hostap/hostap_80211_rx.c:150:32: warning: symbol 'hdr' shadows an earlier one
drivers/net/wireless/hostap/hostap_80211_rx.c:67:29: originally declared here
drivers/net/wireless/hostap/hostap_ap.c:1903:18: warning: cast truncates bits from constant value (ffff3fff becomes 3fff)
drivers/net/wireless/hostap/hostap_main.c:597:5: warning: symbol 'hostap_80211_header_parse' was not declared. Should it be static?
drivers/net/wireless/hostap/hostap_hw.c:2838:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/hostap/hostap_hw.c:64:12: originally declared here
drivers/net/wireless/hostap/hostap_cs.c:583:3: warning: symbol 'ret' shadows an earlier one
drivers/net/wireless/hostap/hostap_cs.c:552:6: originally declared here
drivers/net/wireless/hostap/hostap_cs.c:585:3: warning: symbol 'ret' shadows an earlier one
drivers/net/wireless/hostap/hostap_cs.c:552:6: originally declared here
drivers/net/wireless/hostap/hostap_cs.c:665:3: warning: symbol 'ret' shadows an earlier one
drivers/net/wireless/hostap/hostap_cs.c:552:6: originally declared here
drivers/net/wireless/hostap/hostap_hw.c:2838:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/hostap/hostap_hw.c:64:12: originally declared here
drivers/net/wireless/hostap/hostap_hw.c:2838:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/hostap/hostap_hw.c:64:12: originally declared here
drivers/net/wireless/prism54/isl_ioctl.c:2052:20: warning: incorrect type in assignment (different address spaces)
drivers/net/wireless/prism54/isl_ioctl.c:2052:20:    expected void [noderef] <asn:1>*pointer
drivers/net/wireless/prism54/isl_ioctl.c:2052:20:    got char *[assigned] memptr
drivers/net/wireless/prism54/isl_ioctl.c:2071:20: warning: incorrect type in assignment (different address spaces)
drivers/net/wireless/prism54/isl_ioctl.c:2071:20:    expected void [noderef] <asn:1>*pointer
drivers/net/wireless/prism54/isl_ioctl.c:2071:20:    got char *[assigned] memptr
drivers/net/wireless/prism54/isl_ioctl.c:2993:25: warning: incorrect type in argument 2 (different signedness)
drivers/net/wireless/prism54/isl_ioctl.c:2993:25:    expected int enum oid_num_t *<noident>
drivers/net/wireless/prism54/isl_ioctl.c:2993:25:    got unsigned int *<noident>
drivers/net/wireless/prism54/islpci_hotplug.c:97:1: warning: symbol 'prism54_probe' was not declared. Should it be static?
drivers/net/wireless/prism54/islpci_hotplug.c:220:1: warning: symbol 'prism54_remove' was not declared. Should it be static?
drivers/net/wireless/prism54/islpci_hotplug.c:263:1: warning: symbol 'prism54_suspend' was not declared. Should it be static?
drivers/net/wireless/prism54/islpci_hotplug.c:286:1: warning: symbol 'prism54_resume' was not declared. Should it be static?
drivers/net/wireless/prism54/oid_mgt.c:424:15: warning: symbol '_data' shadows an earlier one
include/asm-generic/sections.h:7:13: originally declared here
drivers/net/wireless/prism54/oid_mgt.c:712:35: warning: incorrect type in argument 2 (different signedness)
drivers/net/wireless/prism54/oid_mgt.c:712:35:    expected int enum oid_num_t *l
drivers/net/wireless/prism54/oid_mgt.c:712:35:    got unsigned int *<noident>
drivers/net/wireless/rt2x00/rt2x00mac.c:217:13: warning: Using plain integer as NULL pointer
drivers/net/wireless/zd1211rw/zd_mac.c:363:40: warning: Using plain integer as NULL pointer
drivers/net/wireless/zd1211rw/zd_mac.c:392:42: warning: Using plain integer as NULL pointer
drivers/net/wireless/zd1211rw/zd_mac.c:606:42: warning: Using plain integer as NULL pointer
drivers/net/wireless/ray_cs.c:831:5: warning: symbol 'ray_dev_init' was not declared. Should it be static?
drivers/net/wireless/rndis_wlan.c:282:64: warning: symbol 'wpa_alg' was not declared. Should it be static?
drivers/net/wireless/rndis_wlan.c:284:2: warning: symbol 'wpa_cipher' was not declared. Should it be static?
drivers/net/wireless/rndis_wlan.c:286:22: warning: symbol 'wpa_key_mgmt' was not declared. Should it be static?
drivers/net/wireless/p54common.c:352:42: warning: Using plain integer as NULL pointer


