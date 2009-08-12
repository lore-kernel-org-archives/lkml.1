Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZHLRKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZHLRKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZHLRKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:10:16 -0400
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:28101 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753991AbZHLRKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:10:13 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: sVI4EA8VM1mTiSaKW6c9MHilbRW3UaswqNDpPSSD9iqncykRJybYULW9HQQbx4YoET9HgHgmc0T856YVn4vdxmlEzzPrYu.g6q9aTV_7M2THBrdZ..rchFm4vJSbK8YoQQjD2VzaKjNKqAHVXZi.0RLD6HPc.9LCOCM_WLSp44VEq_4sM12ofYsXYloJ7sqEq02_3GfN4i.RGMy8M2b55e5EjjdqpMG1KiRVHJRfuKqmHRHLBj9CM8Q7BGOTw8hhgMFlAqLlsyHGZPTTpH3BJ69IYTpQPtkKkzWR1WnEGhrhGFCfG4mGC4P8dJoMkRe1ervPflfyVQ8s02MzWrNZT1jSuacLmowF7Thk
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A82F70C.2060406@schaufler-ca.com>
Date: Wed, 12 Aug 2009 10:08:28 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][RFC] security: constify seq_operations
References: <alpine.LRH.2.00.0908112337450.21218@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0908112337450.21218@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> I think it'd be a good idea to constify more of the various operations 
> structs in the kernel -- our coverage of this is spotty.
>
> The patch below should provide coverage for all of the eligible 
> seq_operations structs in the kernel.  It's derived from the grsecurity 
> patch (which I was reading and noticed how many of these we're missing).
>
> It's possible something's been missed, or that there are problems in code 
> which I can't test.  Please review/comment/test.
>
> If it looks ok, I suggest pushing this via -mm.
>
> Note that there are quite a few other similar ops to be constified, such 
> as file_operations, so if anyone would like to pitch in, please do so.
>
> ---
>
> Subject: [PATCH 1/1] security: constify seq_operations
>
> Make all seq_operations structs const, to help mitigate
> against revectoring user-triggerable function pointers.
>
> This is derived from the grsecurity patch, although generated
> from scratch because it's simpler than extracting the changes
> from there.
>
> Signed-off-by: James Morris <jmorris@namei.org>
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

For the Smack parts. Looks OK.


> ---
>  arch/mn10300/kernel/setup.c                  |    2 +-
>  arch/powerpc/kernel/setup-common.c           |    2 +-
>  arch/powerpc/platforms/pseries/hvCall_inst.c |    2 +-
>  arch/x86/mm/pat.c                            |    2 +-
>  drivers/block/cciss.c                        |    2 +-
>  drivers/char/misc.c                          |    2 +-
>  drivers/char/tpm/tpm_bios.c                  |    4 ++--
>  drivers/isdn/capi/kcapi_proc.c               |   10 +++++-----
>  drivers/scsi/sg.c                            |    6 +++---
>  drivers/staging/rtl8192su/ieee80211/proc.c   |    2 +-
>  fs/afs/proc.c                                |    8 ++++----
>  fs/dlm/debug_fs.c                            |   12 ++++++------
>  fs/ext4/mballoc.c                            |    4 ++--
>  fs/jbd2/journal.c                            |    4 ++--
>  fs/nfs/client.c                              |    4 ++--
>  fs/nfsd/export.c                             |    2 +-
>  fs/ocfs2/cluster/netdebug.c                  |    4 ++--
>  fs/ocfs2/dlm/dlmdebug.c                      |    2 +-
>  fs/proc/nommu.c                              |    2 +-
>  include/linux/nfsd/nfsd.h                    |    2 +-
>  ipc/util.c                                   |    2 +-
>  kernel/cgroup.c                              |    2 +-
>  kernel/kprobes.c                             |    2 +-
>  kernel/lockdep_proc.c                        |    2 +-
>  kernel/trace/ftrace.c                        |    4 ++--
>  kernel/trace/trace.c                         |    4 ++--
>  net/ipv6/ip6mr.c                             |    4 ++--
>  net/key/af_key.c                             |    2 +-
>  security/integrity/ima/ima_fs.c              |    4 ++--
>  security/smack/smackfs.c                     |    6 +++---
>  30 files changed, 55 insertions(+), 55 deletions(-)
>
> diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
> index 79890ed..3f24c29 100644
> --- a/arch/mn10300/kernel/setup.c
> +++ b/arch/mn10300/kernel/setup.c
> @@ -285,7 +285,7 @@ static void c_stop(struct seq_file *m, void *v)
>  {
>  }
>  
> -struct seq_operations cpuinfo_op = {
> +const struct seq_operations cpuinfo_op = {
>  	.start	= c_start,
>  	.next	= c_next,
>  	.stop	= c_stop,
> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
> index 02fed27..1d5570a 100644
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -328,7 +328,7 @@ static void c_stop(struct seq_file *m, void *v)
>  {
>  }
>  
> -struct seq_operations cpuinfo_op = {
> +const struct seq_operations cpuinfo_op = {
>  	.start =c_start,
>  	.next =	c_next,
>  	.stop =	c_stop,
> diff --git a/arch/powerpc/platforms/pseries/hvCall_inst.c b/arch/powerpc/platforms/pseries/hvCall_inst.c
> index eae51ef..3631a4f 100644
> --- a/arch/powerpc/platforms/pseries/hvCall_inst.c
> +++ b/arch/powerpc/platforms/pseries/hvCall_inst.c
> @@ -71,7 +71,7 @@ static int hc_show(struct seq_file *m, void *p)
>  	return 0;
>  }
>  
> -static struct seq_operations hcall_inst_seq_ops = {
> +static const struct seq_operations hcall_inst_seq_ops = {
>          .start = hc_start,
>          .next  = hc_next,
>          .stop  = hc_stop,
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index e6718bb..e2900a3 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -826,7 +826,7 @@ static int memtype_seq_show(struct seq_file *seq, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations memtype_seq_ops = {
> +static const struct seq_operations memtype_seq_ops = {
>  	.start = memtype_seq_start,
>  	.next  = memtype_seq_next,
>  	.stop  = memtype_seq_stop,
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index a52cc7f..7404f83 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -363,7 +363,7 @@ static void cciss_seq_stop(struct seq_file *seq, void *v)
>  	h->busy_configuring = 0;
>  }
>  
> -static struct seq_operations cciss_seq_ops = {
> +static const struct seq_operations cciss_seq_ops = {
>  	.start = cciss_seq_start,
>  	.show  = cciss_seq_show,
>  	.next  = cciss_seq_next,
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> index 62c99fa..9eaf8c4 100644
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -91,7 +91,7 @@ static int misc_seq_show(struct seq_file *seq, void *v)
>  }
>  
>  
> -static struct seq_operations misc_seq_ops = {
> +static const struct seq_operations misc_seq_ops = {
>  	.start = misc_seq_start,
>  	.next  = misc_seq_next,
>  	.stop  = misc_seq_stop,
> diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
> index 0c2f55a..bf2170f 100644
> --- a/drivers/char/tpm/tpm_bios.c
> +++ b/drivers/char/tpm/tpm_bios.c
> @@ -343,14 +343,14 @@ static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations tpm_ascii_b_measurments_seqops = {
> +static const struct seq_operations tpm_ascii_b_measurments_seqops = {
>  	.start = tpm_bios_measurements_start,
>  	.next = tpm_bios_measurements_next,
>  	.stop = tpm_bios_measurements_stop,
>  	.show = tpm_ascii_bios_measurements_show,
>  };
>  
> -static struct seq_operations tpm_binary_b_measurments_seqops = {
> +static const struct seq_operations tpm_binary_b_measurments_seqops = {
>  	.start = tpm_bios_measurements_start,
>  	.next = tpm_bios_measurements_next,
>  	.stop = tpm_bios_measurements_stop,
> diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
> index 50ed778..09d4db7 100644
> --- a/drivers/isdn/capi/kcapi_proc.c
> +++ b/drivers/isdn/capi/kcapi_proc.c
> @@ -89,14 +89,14 @@ static int contrstats_show(struct seq_file *seq, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations seq_controller_ops = {
> +static const struct seq_operations seq_controller_ops = {
>  	.start	= controller_start,
>  	.next	= controller_next,
>  	.stop	= controller_stop,
>  	.show	= controller_show,
>  };
>  
> -static struct seq_operations seq_contrstats_ops = {
> +static const struct seq_operations seq_contrstats_ops = {
>  	.start	= controller_start,
>  	.next	= controller_next,
>  	.stop	= controller_stop,
> @@ -194,14 +194,14 @@ applstats_show(struct seq_file *seq, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations seq_applications_ops = {
> +static const struct seq_operations seq_applications_ops = {
>  	.start	= applications_start,
>  	.next	= applications_next,
>  	.stop	= applications_stop,
>  	.show	= applications_show,
>  };
>  
> -static struct seq_operations seq_applstats_ops = {
> +static const struct seq_operations seq_applstats_ops = {
>  	.start	= applications_start,
>  	.next	= applications_next,
>  	.stop	= applications_stop,
> @@ -264,7 +264,7 @@ static int capi_driver_show(struct seq_file *seq, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations seq_capi_driver_ops = {
> +static const struct seq_operations seq_capi_driver_ops = {
>  	.start	= capi_driver_start,
>  	.next	= capi_driver_next,
>  	.stop	= capi_driver_stop,
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 9230402..7eee714 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2233,7 +2233,7 @@ static struct file_operations dev_fops = {
>  	.open = sg_proc_open_dev,
>  	.release = seq_release,
>  };
> -static struct seq_operations dev_seq_ops = {
> +static const struct seq_operations dev_seq_ops = {
>  	.start = dev_seq_start,
>  	.next  = dev_seq_next,
>  	.stop  = dev_seq_stop,
> @@ -2246,7 +2246,7 @@ static struct file_operations devstrs_fops = {
>  	.open = sg_proc_open_devstrs,
>  	.release = seq_release,
>  };
> -static struct seq_operations devstrs_seq_ops = {
> +static const struct seq_operations devstrs_seq_ops = {
>  	.start = dev_seq_start,
>  	.next  = dev_seq_next,
>  	.stop  = dev_seq_stop,
> @@ -2259,7 +2259,7 @@ static struct file_operations debug_fops = {
>  	.open = sg_proc_open_debug,
>  	.release = seq_release,
>  };
> -static struct seq_operations debug_seq_ops = {
> +static const struct seq_operations debug_seq_ops = {
>  	.start = dev_seq_start,
>  	.next  = dev_seq_next,
>  	.stop  = dev_seq_stop,
> diff --git a/drivers/staging/rtl8192su/ieee80211/proc.c b/drivers/staging/rtl8192su/ieee80211/proc.c
> index 4f3f9ed..df96ad5 100644
> --- a/drivers/staging/rtl8192su/ieee80211/proc.c
> +++ b/drivers/staging/rtl8192su/ieee80211/proc.c
> @@ -87,7 +87,7 @@ static int c_show(struct seq_file *m, void *p)
>  	return 0;
>  }
>  
> -static struct seq_operations crypto_seq_ops = {
> +static const struct seq_operations crypto_seq_ops = {
>  	.start		= c_start,
>  	.next		= c_next,
>  	.stop		= c_stop,
> diff --git a/fs/afs/proc.c b/fs/afs/proc.c
> index 8630615..852739d 100644
> --- a/fs/afs/proc.c
> +++ b/fs/afs/proc.c
> @@ -28,7 +28,7 @@ static int afs_proc_cells_show(struct seq_file *m, void *v);
>  static ssize_t afs_proc_cells_write(struct file *file, const char __user *buf,
>  				    size_t size, loff_t *_pos);
>  
> -static struct seq_operations afs_proc_cells_ops = {
> +static const struct seq_operations afs_proc_cells_ops = {
>  	.start	= afs_proc_cells_start,
>  	.next	= afs_proc_cells_next,
>  	.stop	= afs_proc_cells_stop,
> @@ -70,7 +70,7 @@ static void *afs_proc_cell_volumes_next(struct seq_file *p, void *v,
>  static void afs_proc_cell_volumes_stop(struct seq_file *p, void *v);
>  static int afs_proc_cell_volumes_show(struct seq_file *m, void *v);
>  
> -static struct seq_operations afs_proc_cell_volumes_ops = {
> +static const struct seq_operations afs_proc_cell_volumes_ops = {
>  	.start	= afs_proc_cell_volumes_start,
>  	.next	= afs_proc_cell_volumes_next,
>  	.stop	= afs_proc_cell_volumes_stop,
> @@ -95,7 +95,7 @@ static void *afs_proc_cell_vlservers_next(struct seq_file *p, void *v,
>  static void afs_proc_cell_vlservers_stop(struct seq_file *p, void *v);
>  static int afs_proc_cell_vlservers_show(struct seq_file *m, void *v);
>  
> -static struct seq_operations afs_proc_cell_vlservers_ops = {
> +static const struct seq_operations afs_proc_cell_vlservers_ops = {
>  	.start	= afs_proc_cell_vlservers_start,
>  	.next	= afs_proc_cell_vlservers_next,
>  	.stop	= afs_proc_cell_vlservers_stop,
> @@ -119,7 +119,7 @@ static void *afs_proc_cell_servers_next(struct seq_file *p, void *v,
>  static void afs_proc_cell_servers_stop(struct seq_file *p, void *v);
>  static int afs_proc_cell_servers_show(struct seq_file *m, void *v);
>  
> -static struct seq_operations afs_proc_cell_servers_ops = {
> +static const struct seq_operations afs_proc_cell_servers_ops = {
>  	.start	= afs_proc_cell_servers_start,
>  	.next	= afs_proc_cell_servers_next,
>  	.stop	= afs_proc_cell_servers_stop,
> diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
> index 1d1d274..1c8bb8c 100644
> --- a/fs/dlm/debug_fs.c
> +++ b/fs/dlm/debug_fs.c
> @@ -386,9 +386,9 @@ static int table_seq_show(struct seq_file *seq, void *iter_ptr)
>  	return rv;
>  }
>  
> -static struct seq_operations format1_seq_ops;
> -static struct seq_operations format2_seq_ops;
> -static struct seq_operations format3_seq_ops;
> +static const struct seq_operations format1_seq_ops;
> +static const struct seq_operations format2_seq_ops;
> +static const struct seq_operations format3_seq_ops;
>  
>  static void *table_seq_start(struct seq_file *seq, loff_t *pos)
>  {
> @@ -534,21 +534,21 @@ static void table_seq_stop(struct seq_file *seq, void *iter_ptr)
>  	}
>  }
>  
> -static struct seq_operations format1_seq_ops = {
> +static const struct seq_operations format1_seq_ops = {
>  	.start = table_seq_start,
>  	.next  = table_seq_next,
>  	.stop  = table_seq_stop,
>  	.show  = table_seq_show,
>  };
>  
> -static struct seq_operations format2_seq_ops = {
> +static const struct seq_operations format2_seq_ops = {
>  	.start = table_seq_start,
>  	.next  = table_seq_next,
>  	.stop  = table_seq_stop,
>  	.show  = table_seq_show,
>  };
>  
> -static struct seq_operations format3_seq_ops = {
> +static const struct seq_operations format3_seq_ops = {
>  	.start = table_seq_start,
>  	.next  = table_seq_next,
>  	.stop  = table_seq_stop,
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index cd25846..a891a06 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2205,7 +2205,7 @@ static void ext4_mb_seq_history_stop(struct seq_file *seq, void *v)
>  {
>  }
>  
> -static struct seq_operations ext4_mb_seq_history_ops = {
> +static const struct seq_operations ext4_mb_seq_history_ops = {
>  	.start  = ext4_mb_seq_history_start,
>  	.next   = ext4_mb_seq_history_next,
>  	.stop   = ext4_mb_seq_history_stop,
> @@ -2366,7 +2366,7 @@ static void ext4_mb_seq_groups_stop(struct seq_file *seq, void *v)
>  {
>  }
>  
> -static struct seq_operations ext4_mb_seq_groups_ops = {
> +static const struct seq_operations ext4_mb_seq_groups_ops = {
>  	.start  = ext4_mb_seq_groups_start,
>  	.next   = ext4_mb_seq_groups_next,
>  	.stop   = ext4_mb_seq_groups_stop,
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index e378cb3..02b1092 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -768,7 +768,7 @@ static void jbd2_seq_history_stop(struct seq_file *seq, void *v)
>  {
>  }
>  
> -static struct seq_operations jbd2_seq_history_ops = {
> +static const struct seq_operations jbd2_seq_history_ops = {
>  	.start  = jbd2_seq_history_start,
>  	.next   = jbd2_seq_history_next,
>  	.stop   = jbd2_seq_history_stop,
> @@ -872,7 +872,7 @@ static void jbd2_seq_info_stop(struct seq_file *seq, void *v)
>  {
>  }
>  
> -static struct seq_operations jbd2_seq_info_ops = {
> +static const struct seq_operations jbd2_seq_info_ops = {
>  	.start  = jbd2_seq_info_start,
>  	.next   = jbd2_seq_info_next,
>  	.stop   = jbd2_seq_info_stop,
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index 8d25ccb..238d850 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -1533,7 +1533,7 @@ static void *nfs_server_list_next(struct seq_file *p, void *v, loff_t *pos);
>  static void nfs_server_list_stop(struct seq_file *p, void *v);
>  static int nfs_server_list_show(struct seq_file *m, void *v);
>  
> -static struct seq_operations nfs_server_list_ops = {
> +static const struct seq_operations nfs_server_list_ops = {
>  	.start	= nfs_server_list_start,
>  	.next	= nfs_server_list_next,
>  	.stop	= nfs_server_list_stop,
> @@ -1554,7 +1554,7 @@ static void *nfs_volume_list_next(struct seq_file *p, void *v, loff_t *pos);
>  static void nfs_volume_list_stop(struct seq_file *p, void *v);
>  static int nfs_volume_list_show(struct seq_file *m, void *v);
>  
> -static struct seq_operations nfs_volume_list_ops = {
> +static const struct seq_operations nfs_volume_list_ops = {
>  	.start	= nfs_volume_list_start,
>  	.next	= nfs_volume_list_next,
>  	.stop	= nfs_volume_list_stop,
> diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
> index b92a276..a5e516b 100644
> --- a/fs/nfsd/export.c
> +++ b/fs/nfsd/export.c
> @@ -1505,7 +1505,7 @@ static int e_show(struct seq_file *m, void *p)
>  	return svc_export_show(m, &svc_export_cache, cp);
>  }
>  
> -struct seq_operations nfs_exports_op = {
> +const struct seq_operations nfs_exports_op = {
>  	.start	= e_start,
>  	.next	= e_next,
>  	.stop	= e_stop,
> diff --git a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
> index f842487..cfb2be7 100644
> --- a/fs/ocfs2/cluster/netdebug.c
> +++ b/fs/ocfs2/cluster/netdebug.c
> @@ -163,7 +163,7 @@ static void nst_seq_stop(struct seq_file *seq, void *v)
>  {
>  }
>  
> -static struct seq_operations nst_seq_ops = {
> +static const struct seq_operations nst_seq_ops = {
>  	.start = nst_seq_start,
>  	.next = nst_seq_next,
>  	.stop = nst_seq_stop,
> @@ -344,7 +344,7 @@ static void sc_seq_stop(struct seq_file *seq, void *v)
>  {
>  }
>  
> -static struct seq_operations sc_seq_ops = {
> +static const struct seq_operations sc_seq_ops = {
>  	.start = sc_seq_start,
>  	.next = sc_seq_next,
>  	.stop = sc_seq_stop,
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index df52f70..c5c8812 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -683,7 +683,7 @@ static int lockres_seq_show(struct seq_file *s, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations debug_lockres_ops = {
> +static const struct seq_operations debug_lockres_ops = {
>  	.start =	lockres_seq_start,
>  	.stop =		lockres_seq_stop,
>  	.next =		lockres_seq_next,
> diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
> index 7e14d1a..9fe7d7e 100644
> --- a/fs/proc/nommu.c
> +++ b/fs/proc/nommu.c
> @@ -109,7 +109,7 @@ static void *nommu_region_list_next(struct seq_file *m, void *v, loff_t *pos)
>  	return rb_next((struct rb_node *) v);
>  }
>  
> -static struct seq_operations proc_nommu_region_list_seqop = {
> +static const struct seq_operations proc_nommu_region_list_seqop = {
>  	.start	= nommu_region_list_start,
>  	.next	= nommu_region_list_next,
>  	.stop	= nommu_region_list_stop,
> diff --git a/include/linux/nfsd/nfsd.h b/include/linux/nfsd/nfsd.h
> index 2b49d67..99a0b07 100644
> --- a/include/linux/nfsd/nfsd.h
> +++ b/include/linux/nfsd/nfsd.h
> @@ -57,7 +57,7 @@ extern u32			nfsd_supported_minorversion;
>  extern struct mutex		nfsd_mutex;
>  extern struct svc_serv		*nfsd_serv;
>  
> -extern struct seq_operations nfs_exports_op;
> +extern const struct seq_operations nfs_exports_op;
>  
>  /*
>   * Function prototypes.
> diff --git a/ipc/util.c b/ipc/util.c
> index b8e4ba9..79ce84e 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -942,7 +942,7 @@ static int sysvipc_proc_show(struct seq_file *s, void *it)
>  	return iface->show(s, it);
>  }
>  
> -static struct seq_operations sysvipc_proc_seqops = {
> +static const struct seq_operations sysvipc_proc_seqops = {
>  	.start = sysvipc_proc_start,
>  	.stop  = sysvipc_proc_stop,
>  	.next  = sysvipc_proc_next,
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index b6eadfe..f96c026 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2313,7 +2313,7 @@ static int cgroup_tasks_show(struct seq_file *s, void *v)
>  	return seq_printf(s, "%d\n", *(int *)v);
>  }
>  
> -static struct seq_operations cgroup_tasks_seq_operations = {
> +static const struct seq_operations cgroup_tasks_seq_operations = {
>  	.start = cgroup_tasks_start,
>  	.stop = cgroup_tasks_stop,
>  	.next = cgroup_tasks_next,
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 0540948..013736c 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1329,7 +1329,7 @@ static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations kprobes_seq_ops = {
> +static const struct seq_operations kprobes_seq_ops = {
>  	.start = kprobe_seq_start,
>  	.next  = kprobe_seq_next,
>  	.stop  = kprobe_seq_stop,
> diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
> index e94caa6..0700c1d 100644
> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c
> @@ -670,7 +670,7 @@ static int ls_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations lockstat_ops = {
> +static const struct seq_operations lockstat_ops = {
>  	.start	= ls_start,
>  	.next	= ls_next,
>  	.stop	= ls_stop,
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 1e1d23c..4b07920 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1567,7 +1567,7 @@ static int t_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations show_ftrace_seq_ops = {
> +static const struct seq_operations show_ftrace_seq_ops = {
>  	.start = t_start,
>  	.next = t_next,
>  	.stop = t_stop,
> @@ -2560,7 +2560,7 @@ static int g_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations ftrace_graph_seq_ops = {
> +static const struct seq_operations ftrace_graph_seq_ops = {
>  	.start = g_start,
>  	.next = g_next,
>  	.stop = g_stop,
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index c22b40f..2eb8ee0 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1885,7 +1885,7 @@ static int s_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations tracer_seq_ops = {
> +static const struct seq_operations tracer_seq_ops = {
>  	.start		= s_start,
>  	.next		= s_next,
>  	.stop		= s_stop,
> @@ -2097,7 +2097,7 @@ static int t_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations show_traces_seq_ops = {
> +static const struct seq_operations show_traces_seq_ops = {
>  	.start		= t_start,
>  	.next		= t_next,
>  	.stop		= t_stop,
> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index c769f15..e17588b 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
> @@ -204,7 +204,7 @@ static int ip6mr_vif_seq_show(struct seq_file *seq, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations ip6mr_vif_seq_ops = {
> +static const struct seq_operations ip6mr_vif_seq_ops = {
>  	.start = ip6mr_vif_seq_start,
>  	.next  = ip6mr_vif_seq_next,
>  	.stop  = ip6mr_vif_seq_stop,
> @@ -328,7 +328,7 @@ static int ipmr_mfc_seq_show(struct seq_file *seq, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations ipmr_mfc_seq_ops = {
> +static const struct seq_operations ipmr_mfc_seq_ops = {
>  	.start = ipmr_mfc_seq_start,
>  	.next  = ipmr_mfc_seq_next,
>  	.stop  = ipmr_mfc_seq_stop,
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index dba9abd..7b1e99b 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -3705,7 +3705,7 @@ static void pfkey_seq_stop(struct seq_file *f, void *v)
>  	read_unlock(&pfkey_table_lock);
>  }
>  
> -static struct seq_operations pfkey_seq_ops = {
> +static const struct seq_operations pfkey_seq_ops = {
>  	.start	= pfkey_seq_start,
>  	.next	= pfkey_seq_next,
>  	.stop	= pfkey_seq_stop,
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index 6bfc7ea..8e9777b 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -146,7 +146,7 @@ static int ima_measurements_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations ima_measurments_seqops = {
> +static const struct seq_operations ima_measurments_seqops = {
>  	.start = ima_measurements_start,
>  	.next = ima_measurements_next,
>  	.stop = ima_measurements_stop,
> @@ -221,7 +221,7 @@ static int ima_ascii_measurements_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> -static struct seq_operations ima_ascii_measurements_seqops = {
> +static const struct seq_operations ima_ascii_measurements_seqops = {
>  	.start = ima_measurements_start,
>  	.next = ima_measurements_next,
>  	.stop = ima_measurements_stop,
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index f83a809..aeead75 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -187,7 +187,7 @@ static void load_seq_stop(struct seq_file *s, void *v)
>  	/* No-op */
>  }
>  
> -static struct seq_operations load_seq_ops = {
> +static const struct seq_operations load_seq_ops = {
>  	.start = load_seq_start,
>  	.next  = load_seq_next,
>  	.show  = load_seq_show,
> @@ -503,7 +503,7 @@ static void cipso_seq_stop(struct seq_file *s, void *v)
>  	/* No-op */
>  }
>  
> -static struct seq_operations cipso_seq_ops = {
> +static const struct seq_operations cipso_seq_ops = {
>  	.start = cipso_seq_start,
>  	.stop  = cipso_seq_stop,
>  	.next  = cipso_seq_next,
> @@ -697,7 +697,7 @@ static void netlbladdr_seq_stop(struct seq_file *s, void *v)
>  	/* No-op */
>  }
>  
> -static struct seq_operations netlbladdr_seq_ops = {
> +static const struct seq_operations netlbladdr_seq_ops = {
>  	.start = netlbladdr_seq_start,
>  	.stop  = netlbladdr_seq_stop,
>  	.next  = netlbladdr_seq_next,
>   

