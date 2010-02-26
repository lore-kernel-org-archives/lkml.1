Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573Ab0BZLSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:18:34 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34022 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934166Ab0BZLSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VgUmwQzw+emwbBBp1kVQs7oUXUb+tEoQNH84fgG3oTkBdOsYxTxB9Ee+ogMRqIFLFS
         fDZmLfXHgFl5xA4pMypgofAnqWoaPA1ECh6EWtUsGoxjlFks9H5S4CXqz3JrHSzBevpg
         IKBxJe5lVJB3d0zfECbJMntrI2x4Bd6hRAhB8=
MIME-Version: 1.0
In-Reply-To: <2d460de71002260242o50952e51sa9aee59d2b7bbe2e@mail.gmail.com>
References: <2d460de71002260242o50952e51sa9aee59d2b7bbe2e@mail.gmail.com>
Date: Fri, 26 Feb 2010 12:18:29 +0100
Message-ID: <2d460de71002260318v28bf542w960051d09c990781@mail.gmail.com>
Subject: Re: New thread: page allocation failure with E1000 (seems to be 
	reproducible)
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: e1000-devel@lists.sf.net, linux-kernel@vger.kernel.org
Cc: Andrew Pochinsky <avp@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other information that might help:

For some reason, the e1000e module was _not_ loaded. Tbh, I am not sure
why that was the case, unless e1000e is unrelated to this issue. FWIW, I
loaded it, just now.

# for i in /sys/class/net/bond0/bonding/*; do echo -n "$i : "; cat $i; done
/sys/class/net/bond0/bonding/active_slave :
/sys/class/net/bond0/bonding/ad_actor_key : 17
/sys/class/net/bond0/bonding/ad_aggregator : 1
/sys/class/net/bond0/bonding/ad_num_ports : 4
/sys/class/net/bond0/bonding/ad_partner_key : 2
/sys/class/net/bond0/bonding/ad_partner_mac : 00:d0:05:42:cc:00
/sys/class/net/bond0/bonding/ad_select : stable 0
/sys/class/net/bond0/bonding/arp_interval : 0
/sys/class/net/bond0/bonding/arp_ip_target :
/sys/class/net/bond0/bonding/arp_validate : none 0
/sys/class/net/bond0/bonding/downdelay : 0
/sys/class/net/bond0/bonding/fail_over_mac : none 0
/sys/class/net/bond0/bonding/lacp_rate : slow 0
/sys/class/net/bond0/bonding/miimon : 100
/sys/class/net/bond0/bonding/mii_status : up
/sys/class/net/bond0/bonding/mode : 802.3ad 4
/sys/class/net/bond0/bonding/num_grat_arp : 1
/sys/class/net/bond0/bonding/num_unsol_na : 1
/sys/class/net/bond0/bonding/primary :
/sys/class/net/bond0/bonding/slaves : eth0 eth1 eth2 eth3
/sys/class/net/bond0/bonding/updelay : 0
/sys/class/net/bond0/bonding/use_carrier : 1
/sys/class/net/bond0/bonding/xmit_hash_policy : layer2 0
# lsmod
Module                  Size  Used by
xfs                   432237  1
xt_tcpudp               2287  3
nf_conntrack_ipv4       9499  1
nf_defrag_ipv4          1139  1 nf_conntrack_ipv4
xt_state                1303  1
nf_conntrack           46185  2 nf_conntrack_ipv4,xt_state
iptable_filter          1410  1
ip_tables              13568  1 iptable_filter
x_tables               12754  3 xt_tcpudp,xt_state,ip_tables
sr_mod                 12410  0
nfsd                  256208  13
exportfs                3026  2 xfs,nfsd
nfs                   235903  1
lockd                  56807  2 nfsd,nfs
nfs_acl                 2031  2 nfsd,nfs
auth_rpcgss            35099  2 nfsd,nfs
sunrpc                160030  15 nfsd,nfs,lockd,nfs_acl,auth_rpcgss
bonding                73564  0
ipv6                  246253  17 bonding
dm_round_robin          2180  1
dm_multipath           12280  2 dm_round_robin
dm_mod                 51912  7 dm_multipath
mptctl                 22874  0
loop                   11447  0
ide_cd_mod             23941  0
cdrom                  28535  2 sr_mod,ide_cd_mod
usb_storage            38297  0
ata_generic             2983  0
joydev                  8411  0
usbhid                 30812  0
hid                    65077  1 usbhid
ohci_hcd               18892  0
snd_pcm                59856  0
snd_timer              15550  1 snd_pcm
qla2xxx               208195  4
snd                    42867  2 snd_pcm,snd_timer
soundcore               4767  1 snd
amd74xx                 4476  0
i2c_amd8111             3541  0
snd_page_alloc          5993  1 snd_pcm
thermal                11658  0
serio_raw               3832  0
i2c_amd756              4129  0
psmouse                35197  0
i2c_core               15232  2 i2c_amd8111,i2c_amd756
k8temp                  3123  0
ide_pci_generic         2788  0
ide_core               76100  3 ide_cd_mod,amd74xx,ide_pci_generic
amd_rng                 1437  0
rng_core                2974  1 amd_rng
button                  4666  0
processor              29236  0
thermal_sys            12150  2 thermal,processor
shpchp                 26308  0
pci_hotplug            22140  1 shpchp
pcspkr                  1699  0
evdev                   7304  0
#



Thanks,
Richard
