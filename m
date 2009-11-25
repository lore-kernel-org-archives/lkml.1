Return-Path: <linux-kernel-owner+w=401wt.eu-S934705AbZKYNJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbZKYNJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934697AbZKYNJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:09:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934695AbZKYNJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:09:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [rfc] "fair" rw spinlocks
Date: Wed, 25 Nov 2009 14:09:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20091123145409.GA29627@wotan.suse.de> <20091125065412.GD17484@wotan.suse.de> <20091125084804.GE29096@one.firstfloor.org>
In-Reply-To: <20091125084804.GE29096@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251409.04573.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19AeBOOb3po1IBUsTPKTBAbTU8KcFsWvljML3S
 b6ENtkijUyURfEzrGoKM13/PmeNZb4rVu6Ywp56kX4x1DBXfOA
 WfgoqtnCWF3f8BZ2wOjmQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009, Andi Kleen wrote:
> > No that's what I meant, the new type would be non nestable.
> 
> Okay.  Unfortunately it's still quite a lot of work.
> 
> %git/linux-2.6> gid rwlock_t | wc -l
> 221
> 
> Just tasklist_lock alone would be tough I guess, on level with one of your
> nasty VFS locks that protect a thousand different things without any
> comments.

You missed all the static DEFINE_RWLOCK instances, which are another
130 or so. Fortunately many of them are in the obscure category.
Looking only at the files used in a x86 defconfig build, less than
80 remain, mostly networking related.

	Arnd <><

arch/x86/kernel/amd_iommu.c:static DEFINE_RWLOCK(amd_iommu_devtable_lock);
drivers/md/dm.c:	rwlock_t map_lock;
drivers/md/dm-region-hash.c:	rwlock_t hash_lock;
drivers/scsi/sg.c:	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
drivers/scsi/sg.c:static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
fs/binfmt_misc.c:static DEFINE_RWLOCK(entries_lock);
fs/exec.c:static DEFINE_RWLOCK(binfmt_lock);
fs/fcntl.c:static DEFINE_RWLOCK(fasync_lock);
fs/filesystems.c:static DEFINE_RWLOCK(file_systems_lock);
fs/proc/kcore.c:static DEFINE_RWLOCK(kclist_lock);
include/linux/atalk.h:extern rwlock_t atalk_interfaces_lock;
include/linux/atalk.h:extern rwlock_t atalk_routes_lock;
include/linux/atalk.h:extern rwlock_t atalk_sockets_lock;
include/linux/atmdev.h:extern rwlock_t vcc_sklist_lock;
include/linux/fs.h:	rwlock_t lock;          /* protects pid, uid, euid fields */
include/linux/fs_struct.h:	rwlock_t lock;
include/linux/inetdevice.h:	rwlock_t		mc_list_lock;
include/linux/leds.h:	rwlock_t	  leddev_list_lock;
include/linux/netdevice.h:extern rwlock_t				dev_base_lock;		/* Device list lock */
include/linux/sched.h:extern rwlock_t tasklist_lock;
include/linux/sunrpc/cache.h:	rwlock_t		hash_lock;
include/linux/vmalloc.h:extern rwlock_t vmlist_lock;
include/net/act_api.h:	rwlock_t		*lock;
include/net/bluetooth/bluetooth.h:	rwlock_t          lock;
include/net/if_inet6.h:	rwlock_t		lock;
include/net/if_inet6.h:	rwlock_t		mc_lock;
include/net/if_inet6.h:	rwlock_t		sflock;
include/net/inet_frag.h:	rwlock_t		lock;
include/net/ip6_fib.h:	rwlock_t		tb6_lock;
include/net/ip.h:extern rwlock_t ip_ra_lock;
include/net/ipv6.h:extern rwlock_t ip6_ra_lock;
include/net/ip_vs.h:	rwlock_t		sched_lock;    /* lock sched_data */
include/net/llc.h:extern rwlock_t llc_sap_list_lock;
include/net/llc.h:		rwlock_t	  lock;
include/net/neighbour.h:	rwlock_t		lock;
include/net/neighbour.h:	rwlock_t		lock;
include/net/netns/packet.h:	rwlock_t		sklist_lock;
include/net/raw.h:	rwlock_t lock;
include/net/request_sock.h:	rwlock_t		syn_wait_lock;
include/net/sock.h:	rwlock_t		sk_callback_lock;
include/net/sock.h:	rwlock_t		sk_dst_lock;
include/net/xfrm.h:	rwlock_t		lock;
include/sound/core.h:	rwlock_t ctl_files_rwlock;	/* ctl_files list lock */
include/sound/pcm.h:extern rwlock_t snd_pcm_link_rwlock;
kernel/cgroup.c:static DEFINE_RWLOCK(css_set_lock);
kernel/exec_domain.c:static DEFINE_RWLOCK(exec_domains_lock);
kernel/fork.c:__cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
kernel/resource.c:static DEFINE_RWLOCK(resource_lock);
mm/vmalloc.c:DEFINE_RWLOCK(vmlist_lock);
net/core/dev.c:DEFINE_RWLOCK(dev_base_lock);
net/core/gen_estimator.c:static DEFINE_RWLOCK(est_lock);
net/core/neighbour.c:static DEFINE_RWLOCK(neigh_tbl_lock);
net/core/sock.c:static DEFINE_RWLOCK(proto_list_lock);
net/ipv4/fib_hash.c:static DEFINE_RWLOCK(fib_hash_lock);
net/ipv4/inetpeer.c:static DEFINE_RWLOCK(peer_pool_lock);
net/ipv4/ipmr.c:static DEFINE_RWLOCK(mrt_lock);
net/ipv4/ip_sockglue.c:DEFINE_RWLOCK(ip_ra_lock);
net/ipv6/addrconf.c:static DEFINE_RWLOCK(addrconf_hash_lock);
net/ipv6/anycast.c:static DEFINE_RWLOCK(ipv6_sk_ac_lock);
net/ipv6/ip6_fib.c:static DEFINE_RWLOCK(fib6_walker_lock);
net/ipv6/ip6_flowlabel.c:static DEFINE_RWLOCK(ip6_fl_lock);
net/ipv6/ip6_flowlabel.c:static DEFINE_RWLOCK(ip6_sk_fl_lock);
net/ipv6/ipv6_sockglue.c:DEFINE_RWLOCK(ip6_ra_lock);
net/ipv6/mcast.c:static DEFINE_RWLOCK(ipv6_sk_mc_lock);
net/llc/llc_core.c:DEFINE_RWLOCK(llc_sap_list_lock);
net/netfilter/nfnetlink_log.c:static DEFINE_RWLOCK(instances_lock);
net/netlink/af_netlink.c:static DEFINE_RWLOCK(nl_table_lock);
net/sched/act_api.c:static DEFINE_RWLOCK(act_mod_lock);
net/sched/cls_api.c:static DEFINE_RWLOCK(cls_mod_lock);
net/sched/ematch.c:static DEFINE_RWLOCK(ematch_mod_lock);
net/sched/sch_api.c:static DEFINE_RWLOCK(qdisc_mod_lock);
net/xfrm/xfrm_policy.c:static DEFINE_RWLOCK(xfrm_policy_afinfo_lock);
net/xfrm/xfrm_policy.c:static DEFINE_RWLOCK(xfrm_policy_lock);
net/xfrm/xfrm_state.c:static DEFINE_RWLOCK(xfrm_km_lock);
net/xfrm/xfrm_state.c:static DEFINE_RWLOCK(xfrm_state_afinfo_lock);
security/keys/keyring.c:static DEFINE_RWLOCK(keyring_name_lock);
security/selinux/ss/services.c:static DEFINE_RWLOCK(policy_rwlock);
sound/core/pcm_native.c:DEFINE_RWLOCK(snd_pcm_link_rwlock);
sound/core/seq/seq_clientmgr.h:	rwlock_t ports_lock;
sound/core/seq/seq_ports.h:	rwlock_t list_lock;
