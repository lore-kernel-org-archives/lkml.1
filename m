Return-Path: <linux-kernel-owner+w=401wt.eu-S1752698AbYL3JLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbYL3JLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 04:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYL3JL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 04:11:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52582 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYL3JLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 04:11:17 -0500
Message-ID: <4959E57C.6040401@cn.fujitsu.com>
Date: Tue, 30 Dec 2008 17:10:20 +0800
From: Ren Mingxin <renmx@cn.fujitsu.com>
Organization: FNST
User-Agent: Thunderbird 2.0a1 (Windows/20060724)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] standardise macro for module init & exit
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel source code, I found the module_init and
module_exit macros were used a little nonstandardly
(sometimes ending with semicolon but sometimes with
none).
I removed the last semicolon when the module_init and
module_exit macros are defined, so we have to add
semicolon on the neck of macro using line.
In this way, we can avoid macro using error, and improve
standardization, readability and so on.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
  arch/ia64/ia32/binfmt_elf32.c           |    2 +-
  arch/ia64/kvm/vmm.c                     |    4 ++--
  arch/ia64/sn/kernel/mca.c               |    2 +-
  arch/powerpc/kvm/booke_host.c           |    4 ++--
  arch/s390/hypfs/inode.c                 |    4 ++--
  arch/x86/kernel/msr.c                   |    2 +-
  arch/x86/kvm/svm.c                      |    4 ++--
  arch/x86/kvm/vmx.c                      |    4 ++--
  drivers/block/ataflop.c                 |    4 ++--
  drivers/block/cpqarray.c                |    4 ++--
  drivers/block/floppy.c                  |    2 +-
  drivers/block/paride/aten.c             |    4 ++--
  drivers/block/paride/bpck.c             |    4 ++--
  drivers/block/paride/bpck6.c            |    4 ++--
  drivers/block/paride/comm.c             |    4 ++--
  drivers/block/paride/dstr.c             |    4 ++--
  drivers/block/paride/epat.c             |    4 ++--
  drivers/block/paride/epia.c             |    4 ++--
  drivers/block/paride/fit2.c             |    4 ++--
  drivers/block/paride/fit3.c             |    4 ++--
  drivers/block/paride/friq.c             |    4 ++--
  drivers/block/paride/frpw.c             |    4 ++--
  drivers/block/paride/kbic.c             |    4 ++--
  drivers/block/paride/ktti.c             |    4 ++--
  drivers/block/paride/on20.c             |    4 ++--
  drivers/block/paride/on26.c             |    4 ++--
  drivers/block/paride/pcd.c              |    4 ++--
  drivers/block/paride/pd.c               |    4 ++--
  drivers/block/paride/pf.c               |    4 ++--
  drivers/block/paride/pg.c               |    4 ++--
  drivers/block/paride/pt.c               |    4 ++--
  drivers/block/swim3.c                   |    2 +-
  drivers/char/amiserial.c                |    4 ++--
  drivers/gpio/bt8xxgpio.c                |    4 ++--
  drivers/hwmon/adm1021.c                 |    4 ++--
  drivers/hwmon/coretemp.c                |    4 ++--
  drivers/hwmon/k8temp.c                  |    4 ++--
  drivers/i2c/busses/i2c-amd756.c         |    4 ++--
  drivers/md/dm-zero.c                    |    4 ++--
  drivers/md/md.c                         |    2 +-
  drivers/media/video/v4l2-dev.c          |    4 ++--
  drivers/mfd/htc-egpio.c                 |    2 +-
  drivers/net/arcnet/arc-rimi.c           |    4 ++--
  drivers/net/arcnet/com20020-isa.c       |    4 ++--
  drivers/net/arcnet/com20020-pci.c       |    4 ++--
  drivers/net/arcnet/com90io.c            |    4 ++--
  drivers/net/arm/at91_ether.c            |    4 ++--
  drivers/net/hp100.c                     |    4 ++--
  drivers/net/tulip/xircom_cb.c           |    4 ++--
  drivers/net/wireless/b43/main.c         |    4 ++--
  drivers/net/wireless/b43legacy/main.c   |    4 ++--
  drivers/parisc/led.c                    |    2 +-
  drivers/parport/parport_amiga.c         |    4 ++--
  drivers/parport/parport_atari.c         |    4 ++--
  drivers/parport/parport_ax88796.c       |    4 ++--
  drivers/parport/parport_mfc3.c          |    4 ++--
  drivers/parport/parport_pc.c            |    4 ++--
  drivers/parport/parport_sunbpp.c        |    4 ++--
  drivers/parport/procfs.c                |    4 ++--
  drivers/scsi/pcmcia/nsp_cs.c            |    4 ++--
  drivers/ssb/main.c                      |    2 +-
  drivers/uio/uio.c                       |    4 ++--
  fs/9p/v9fs.c                            |    4 ++--
  fs/adfs/super.c                         |    4 ++--
  fs/affs/super.c                         |    4 ++--
  fs/autofs4/init.c                       |    4 ++--
  fs/befs/linuxvfs.c                      |    4 ++--
  fs/bfs/inode.c                          |    4 ++--
  fs/cifs/cifsfs.c                        |    4 ++--
  fs/cramfs/inode.c                       |    4 ++--
  fs/devpts/inode.c                       |    4 ++--
  fs/dnotify.c                            |    2 +-
  fs/ecryptfs/main.c                      |    4 ++--
  fs/efs/super.c                          |    4 ++--
  fs/ext2/super.c                         |    4 ++--
  fs/ext3/super.c                         |    4 ++--
  fs/ext4/super.c                         |    4 ++--
  fs/fat/inode.c                          |    4 ++--
  fs/fat/namei_msdos.c                    |    4 ++--
  fs/fat/namei_vfat.c                     |    4 ++--
  fs/fcntl.c                              |    2 +-
  fs/hfs/super.c                          |    4 ++--
  fs/hfsplus/super.c                      |    4 ++--
  fs/hostfs/hostfs_kern.c                 |    4 ++--
  fs/hpfs/super.c                         |    4 ++--
  fs/hppfs/hppfs.c                        |    4 ++--
  fs/hugetlbfs/inode.c                    |    4 ++--
  fs/isofs/inode.c                        |    4 ++--
  fs/jfs/super.c                          |    4 ++--
  fs/mbcache.c                            |    4 ++--
  fs/minix/inode.c                        |    4 ++--
  fs/ncpfs/inode.c                        |    4 ++--
  fs/nfs/inode.c                          |    4 ++--
  fs/nfsd/nfsctl.c                        |    4 ++--
  fs/nls/nls_ascii.c                      |    4 ++--
  fs/nls/nls_cp1250.c                     |    4 ++--
  fs/nls/nls_cp1251.c                     |    4 ++--
  fs/nls/nls_cp1255.c                     |    4 ++--
  fs/nls/nls_cp437.c                      |    4 ++--
  fs/nls/nls_cp737.c                      |    4 ++--
  fs/nls/nls_cp775.c                      |    4 ++--
  fs/nls/nls_cp850.c                      |    4 ++--
  fs/nls/nls_cp852.c                      |    4 ++--
  fs/nls/nls_cp855.c                      |    4 ++--
  fs/nls/nls_cp857.c                      |    4 ++--
  fs/nls/nls_cp860.c                      |    4 ++--
  fs/nls/nls_cp861.c                      |    4 ++--
  fs/nls/nls_cp862.c                      |    4 ++--
  fs/nls/nls_cp863.c                      |    4 ++--
  fs/nls/nls_cp864.c                      |    4 ++--
  fs/nls/nls_cp865.c                      |    4 ++--
  fs/nls/nls_cp866.c                      |    4 ++--
  fs/nls/nls_cp869.c                      |    4 ++--
  fs/nls/nls_cp874.c                      |    4 ++--
  fs/nls/nls_cp932.c                      |    4 ++--
  fs/nls/nls_cp936.c                      |    4 ++--
  fs/nls/nls_cp949.c                      |    4 ++--
  fs/nls/nls_cp950.c                      |    4 ++--
  fs/nls/nls_euc-jp.c                     |    4 ++--
  fs/nls/nls_iso8859-1.c                  |    4 ++--
  fs/nls/nls_iso8859-13.c                 |    4 ++--
  fs/nls/nls_iso8859-14.c                 |    4 ++--
  fs/nls/nls_iso8859-15.c                 |    4 ++--
  fs/nls/nls_iso8859-2.c                  |    4 ++--
  fs/nls/nls_iso8859-3.c                  |    4 ++--
  fs/nls/nls_iso8859-4.c                  |    4 ++--
  fs/nls/nls_iso8859-5.c                  |    4 ++--
  fs/nls/nls_iso8859-6.c                  |    4 ++--
  fs/nls/nls_iso8859-7.c                  |    4 ++--
  fs/nls/nls_iso8859-9.c                  |    4 ++--
  fs/nls/nls_koi8-r.c                     |    4 ++--
  fs/nls/nls_koi8-ru.c                    |    4 ++--
  fs/nls/nls_koi8-u.c                     |    4 ++--
  fs/nls/nls_utf8.c                       |    4 ++--
  fs/ntfs/super.c                         |    4 ++--
  fs/ocfs2/cluster/nodemanager.c          |    4 ++--
  fs/ocfs2/dlm/dlmfs.c                    |    4 ++--
  fs/openpromfs/inode.c                   |    4 ++--
  fs/proc/vmcore.c                        |    2 +-
  fs/qnx4/inode.c                         |    4 ++--
  fs/ramfs/inode.c                        |    4 ++--
  fs/romfs/inode.c                        |    4 ++--
  fs/smbfs/inode.c                        |    4 ++--
  fs/sysv/super.c                         |    4 ++--
  fs/udf/super.c                          |    4 ++--
  fs/ufs/super.c                          |    4 ++--
  include/linux/init.h                    |    8 ++++----
  kernel/kexec.c                          |    4 ++--
  mm/page_alloc.c                         |    2 +-
  mm/shmem.c                              |    2 +-
  mm/tiny-shmem.c                         |    2 +-
  mm/vmscan.c                             |    2 +-
  mm/vmstat.c                             |    2 +-
  net/9p/mod.c                            |    4 ++--
  net/bridge/br.c                         |    4 ++--
  net/sched/cls_basic.c                   |    4 ++--
  net/sched/cls_fw.c                      |    4 ++--
  net/sched/cls_route.c                   |    4 ++--
  net/sched/cls_rsvp.h                    |    4 ++--
  net/sched/cls_tcindex.c                 |    4 ++--
  net/sched/cls_u32.c                     |    4 ++--
  net/sched/sch_atm.c                     |    4 ++--
  net/sched/sch_blackhole.c               |    4 ++--
  net/sched/sch_cbq.c                     |    4 ++--
  net/sched/sch_dsmark.c                  |    4 ++--
  net/sched/sch_gred.c                    |    4 ++--
  net/sched/sch_htb.c                     |    4 ++--
  net/sched/sch_ingress.c                 |    4 ++--
  net/sched/sch_multiq.c                  |    4 ++--
  net/sched/sch_netem.c                   |    4 ++--
  net/sched/sch_prio.c                    |    4 ++--
  net/sched/sch_red.c                     |    4 ++--
  net/sched/sch_sfq.c                     |    4 ++--
  net/sched/sch_tbf.c                     |    4 ++--
  net/sunrpc/auth_gss/auth_gss.c          |    4 ++--
  samples/kprobes/jprobe_example.c        |    4 ++--
  samples/kprobes/kprobe_example.c        |    4 ++--
  samples/kprobes/kretprobe_example.c     |    4 ++--
  samples/markers/marker-example.c        |    4 ++--
  samples/tracepoints/tracepoint-sample.c |    4 ++--
  sound/core/hwdep.c                      |    4 ++--
  sound/core/memalloc.c                   |    4 ++--
  sound/core/oss/mixer_oss.c              |    4 ++--
  sound/core/oss/pcm_oss.c                |    4 ++--
  sound/core/pcm.c                        |    4 ++--
  sound/core/rawmidi.c                    |    4 ++--
  sound/core/rtctimer.c                   |    4 ++--
  sound/core/seq/oss/seq_oss.c            |    4 ++--
  sound/core/seq/seq.c                    |    4 ++--
  sound/core/seq/seq_device.c             |    4 ++--
  sound/core/seq/seq_dummy.c              |    4 ++--
  sound/core/seq/seq_midi.c               |    4 ++--
  sound/core/seq/seq_midi_emul.c          |    4 ++--
  sound/core/seq/seq_midi_event.c         |    4 ++--
  sound/core/seq/seq_virmidi.c            |    4 ++--
  sound/core/sound.c                      |    4 ++--
  sound/core/timer.c                      |    4 ++--
  sound/drivers/dummy.c                   |    4 ++--
  sound/drivers/ml403-ac97cr.c            |    4 ++--
  sound/drivers/mpu401/mpu401.c           |    4 ++--
  sound/drivers/mpu401/mpu401_uart.c      |    4 ++--
  sound/drivers/mtpav.c                   |    4 ++--
  sound/drivers/opl3/opl3_lib.c           |    4 ++--
  sound/drivers/opl3/opl3_seq.c           |    4 ++--
  sound/drivers/opl4/opl4_lib.c           |    4 ++--
  sound/drivers/opl4/opl4_seq.c           |    4 ++--
  sound/drivers/serial-u16550.c           |    4 ++--
  sound/drivers/virmidi.c                 |    4 ++--
  sound/drivers/vx/vx_core.c              |    4 ++--
  sound/i2c/cs8427.c                      |    4 ++--
  sound/i2c/i2c.c                         |    4 ++--
  sound/i2c/other/ak4xxx-adda.c           |    4 ++--
  sound/i2c/other/tea575x-tuner.c         |    4 ++--
  sound/i2c/tea6330t.c                    |    4 ++--
  sound/isa/ad1816a/ad1816a.c             |    4 ++--
  sound/isa/als100.c                      |    4 ++--
  sound/isa/azt2320.c                     |    4 ++--
  sound/isa/cmi8330.c                     |    4 ++--
  sound/isa/cs423x/cs4236.c               |    4 ++--
  sound/isa/cs423x/cs4236_lib.c           |    4 ++--
  sound/isa/dt019x.c                      |    4 ++--
  sound/isa/es1688/es1688_lib.c           |    4 ++--
  sound/isa/es18xx.c                      |    4 ++--
  sound/isa/gus/gus_main.c                |    4 ++--
  sound/isa/gus/gusmax.c                  |    4 ++--
  sound/isa/gus/interwave.c               |    4 ++--
  sound/isa/opl3sa2.c                     |    4 ++--
  sound/isa/opti9xx/miro.c                |    4 ++--
  sound/isa/opti9xx/opti92x-ad1848.c      |    4 ++--
  sound/isa/sb/emu8000_synth.c            |    4 ++--
  sound/isa/sb/es968.c                    |    4 ++--
  sound/isa/sb/sb16.c                     |    4 ++--
  sound/isa/sb/sb16_csp.c                 |    4 ++--
  sound/isa/sb/sb16_main.c                |    4 ++--
  sound/isa/sb/sb8.c                      |    4 ++--
  sound/isa/sb/sb8_main.c                 |    4 ++--
  sound/isa/sb/sb_common.c                |    4 ++--
  sound/isa/sc6000.c                      |    4 ++--
  sound/isa/sgalaxy.c                     |    4 ++--
  sound/isa/wavefront/wavefront.c         |    4 ++--
  sound/mips/sgio2audio.c                 |    4 ++--
  sound/pci/ac97/ac97_codec.c             |    4 ++--
  sound/pci/ali5451/ali5451.c             |    4 ++--
  sound/pci/als300.c                      |    4 ++--
  sound/pci/als4000.c                     |    4 ++--
  sound/pci/atiixp.c                      |    4 ++--
  sound/pci/atiixp_modem.c                |    4 ++--
  sound/pci/au88x0/au88x0.c               |    4 ++--
  sound/pci/azt3328.c                     |    4 ++--
  sound/pci/bt87x.c                       |    4 ++--
  sound/pci/ca0106/ca0106_main.c          |    4 ++--
  sound/pci/cmipci.c                      |    4 ++--
  sound/pci/cs4281.c                      |    4 ++--
  sound/pci/cs46xx/cs46xx.c               |    4 ++--
  sound/pci/cs5530.c                      |    4 ++--
  sound/pci/cs5535audio/cs5535audio.c     |    4 ++--
  sound/pci/echoaudio/echoaudio.c         |    4 ++--
  sound/pci/emu10k1/emu10k1.c             |    4 ++--
  sound/pci/emu10k1/emu10k1_synth.c       |    4 ++--
  sound/pci/emu10k1/emu10k1x.c            |    4 ++--
  sound/pci/ens1370.c                     |    4 ++--
  sound/pci/es1938.c                      |    4 ++--
  sound/pci/es1968.c                      |    4 ++--
  sound/pci/fm801.c                       |    4 ++--
  sound/pci/hda/hda_intel.c               |    4 ++--
  sound/pci/hda/patch_analog.c            |    4 ++--
  sound/pci/hda/patch_atihdmi.c           |    4 ++--
  sound/pci/hda/patch_cmedia.c            |    4 ++--
  sound/pci/hda/patch_conexant.c          |    4 ++--
  sound/pci/hda/patch_intelhdmi.c         |    4 ++--
  sound/pci/hda/patch_nvhdmi.c            |    4 ++--
  sound/pci/hda/patch_realtek.c           |    4 ++--
  sound/pci/hda/patch_si3054.c            |    4 ++--
  sound/pci/hda/patch_sigmatel.c          |    4 ++--
  sound/pci/hda/patch_via.c               |    4 ++--
  sound/pci/ice1712/ak4xxx.c              |    4 ++--
  sound/pci/ice1712/ice1712.c             |    4 ++--
  sound/pci/ice1712/ice1724.c             |    4 ++--
  sound/pci/intel8x0.c                    |    4 ++--
  sound/pci/intel8x0m.c                   |    4 ++--
  sound/pci/korg1212/korg1212.c           |    4 ++--
  sound/pci/maestro3.c                    |    4 ++--
  sound/pci/mixart/mixart.c               |    4 ++--
  sound/pci/nm256/nm256.c                 |    4 ++--
  sound/pci/oxygen/hifier.c               |    4 ++--
  sound/pci/oxygen/oxygen.c               |    4 ++--
  sound/pci/oxygen/virtuoso.c             |    4 ++--
  sound/pci/pcxhr/pcxhr.c                 |    4 ++--
  sound/pci/rme32.c                       |    4 ++--
  sound/pci/rme96.c                       |    4 ++--
  sound/pci/rme9652/hdsp.c                |    4 ++--
  sound/pci/rme9652/hdspm.c               |    4 ++--
  sound/pci/rme9652/rme9652.c             |    4 ++--
  sound/pci/sonicvibes.c                  |    4 ++--
  sound/pci/trident/trident.c             |    4 ++--
  sound/pci/via82xx.c                     |    4 ++--
  sound/pci/via82xx_modem.c               |    4 ++--
  sound/pci/vx222/vx222.c                 |    4 ++--
  sound/pci/ymfpci/ymfpci.c               |    4 ++--
  sound/ppc/powermac.c                    |    4 ++--
  sound/synth/emux/emux.c                 |    4 ++--
  sound/synth/util_mem.c                  |    4 ++--
  sound/usb/caiaq/caiaq-device.c          |    4 ++--
  sound/usb/usx2y/us122l.c                |    4 ++--
  sound/usb/usx2y/usbusx2y.c              |    4 ++--
  305 files changed, 595 insertions(+), 595 deletions(-)

diff --git a/arch/ia64/ia32/binfmt_elf32.c b/arch/ia64/ia32/binfmt_elf32.c
index f92bdaa..90d5c15 100644
--- a/arch/ia64/ia32/binfmt_elf32.c
+++ b/arch/ia64/ia32/binfmt_elf32.c
@@ -242,4 +242,4 @@ static int __init check_elf32_binfmt(void)
      return 0;
  }

-module_init(check_elf32_binfmt)
+module_init(check_elf32_binfmt);
diff --git a/arch/ia64/kvm/vmm.c b/arch/ia64/kvm/vmm.c
index 2275bf4..d1ed880 100644
--- a/arch/ia64/kvm/vmm.c
+++ b/arch/ia64/kvm/vmm.c
@@ -62,5 +62,5 @@ void vmm_spin_unlock(spinlock_t *lock)
  {
      _vmm_raw_spin_unlock(lock);
  }
-module_init(kvm_vmm_init)
-module_exit(kvm_vmm_exit)
+module_init(kvm_vmm_init);
+module_exit(kvm_vmm_exit);
diff --git a/arch/ia64/sn/kernel/mca.c b/arch/ia64/sn/kernel/mca.c
index 27793f7..022f49b 100644
--- a/arch/ia64/sn/kernel/mca.c
+++ b/arch/ia64/sn/kernel/mca.c
@@ -143,4 +143,4 @@ static int __init sn_salinfo_init(void)
      return 0;
  }

-module_init(sn_salinfo_init)
+module_init(sn_salinfo_init);
diff --git a/arch/powerpc/kvm/booke_host.c b/arch/powerpc/kvm/booke_host.c
index b480341..2704590 100644
--- a/arch/powerpc/kvm/booke_host.c
+++ b/arch/powerpc/kvm/booke_host.c
@@ -79,5 +79,5 @@ static void __exit kvmppc_booke_exit(void)
      kvm_exit();
  }

-module_init(kvmppc_booke_init)
-module_exit(kvmppc_booke_exit)
+module_init(kvmppc_booke_init);
+module_exit(kvmppc_booke_exit);
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 9d4f8e6..9493f33 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -527,8 +527,8 @@ static void __exit hypfs_exit(void)
      kobject_put(s390_kobj);
  }

-module_init(hypfs_init)
-module_exit(hypfs_exit)
+module_init(hypfs_init);
+module_exit(hypfs_exit);

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Michael Holzheu <holzheu@de.ibm.com>");
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 82a7c7e..02c6656 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -244,7 +244,7 @@ static void __exit msr_exit(void)
  }

  module_init(msr_init);
-module_exit(msr_exit)
+module_exit(msr_exit);

  MODULE_AUTHOR("H. Peter Anvin <hpa@zytor.com>");
  MODULE_DESCRIPTION("x86 generic MSR driver");
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9c4ce65..b5c3ce6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1980,5 +1980,5 @@ static void __exit svm_exit(void)
      kvm_exit();
  }

-module_init(svm_init)
-module_exit(svm_exit)
+module_init(svm_init);
+module_exit(svm_exit);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a4018b0..4e4b104 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3599,5 +3599,5 @@ static void __exit vmx_exit(void)
      kvm_exit();
  }

-module_init(vmx_init)
-module_exit(vmx_exit)
+module_init(vmx_init);
+module_exit(vmx_exit);
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 69e1df7..5431db2 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2000,7 +2000,7 @@ static void __exit atari_floppy_exit(void)
      atari_stram_free( DMABuffer );
  }

-module_init(atari_floppy_init)
-module_exit(atari_floppy_exit)
+module_init(atari_floppy_init);
+module_exit(atari_floppy_exit);

  MODULE_LICENSE("GPL");
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 5d39df1..bcb8d02 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1804,5 +1804,5 @@ static void __exit cpqarray_exit(void)
      remove_proc_entry("driver/cpqarray", NULL);
  }

-module_init(cpqarray_init)
-module_exit(cpqarray_exit)
+module_init(cpqarray_init);
+module_exit(cpqarray_exit);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cf29cc4..c27378a 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4576,7 +4576,7 @@ MODULE_LICENSE("GPL");
  #else

  __setup("floppy=", floppy_setup);
-module_init(floppy_init)
+module_init(floppy_init);
  #endif

  MODULE_ALIAS_BLOCKDEV_MAJOR(FLOPPY_MAJOR);
diff --git a/drivers/block/paride/aten.c b/drivers/block/paride/aten.c
index 2695465..57a41bb 100644
--- a/drivers/block/paride/aten.c
+++ b/drivers/block/paride/aten.c
@@ -158,5 +158,5 @@ static void __exit aten_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(aten_init)
-module_exit(aten_exit)
+module_init(aten_init);
+module_exit(aten_exit);
diff --git a/drivers/block/paride/bpck.c b/drivers/block/paride/bpck.c
index 4f27e73..a6facc1 100644
--- a/drivers/block/paride/bpck.c
+++ b/drivers/block/paride/bpck.c
@@ -473,5 +473,5 @@ static void __exit bpck_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(bpck_init)
-module_exit(bpck_exit)
+module_init(bpck_init);
+module_exit(bpck_exit);
diff --git a/drivers/block/paride/bpck6.c b/drivers/block/paride/bpck6.c
index ad12452..557ecba 100644
--- a/drivers/block/paride/bpck6.c
+++ b/drivers/block/paride/bpck6.c
@@ -264,5 +264,5 @@ MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Micro Solutions Inc.");
  MODULE_DESCRIPTION("BACKPACK Protocol module, compatible with PARIDE");
  module_param(verbose, bool, 0644);
-module_init(bpck6_init)
-module_exit(bpck6_exit)
+module_init(bpck6_init);
+module_exit(bpck6_exit);
diff --git a/drivers/block/paride/comm.c b/drivers/block/paride/comm.c
index 9bcd354..62c0640 100644
--- a/drivers/block/paride/comm.c
+++ b/drivers/block/paride/comm.c
@@ -214,5 +214,5 @@ static void __exit comm_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(comm_init)
-module_exit(comm_exit)
+module_init(comm_init);
+module_exit(comm_exit);
diff --git a/drivers/block/paride/dstr.c b/drivers/block/paride/dstr.c
index accc5c7..993cf22 100644
--- a/drivers/block/paride/dstr.c
+++ b/drivers/block/paride/dstr.c
@@ -229,5 +229,5 @@ static void __exit dstr_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(dstr_init)
-module_exit(dstr_exit)
+module_init(dstr_init);
+module_exit(dstr_exit);
diff --git a/drivers/block/paride/epat.c b/drivers/block/paride/epat.c
index 1bcdff7..55bf19c 100644
--- a/drivers/block/paride/epat.c
+++ b/drivers/block/paride/epat.c
@@ -336,5 +336,5 @@ static void __exit epat_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(epat_init)
-module_exit(epat_exit)
+module_init(epat_init);
+module_exit(epat_exit);
diff --git a/drivers/block/paride/epia.c b/drivers/block/paride/epia.c
index fb0e782..ff688d1 100644
--- a/drivers/block/paride/epia.c
+++ b/drivers/block/paride/epia.c
@@ -312,5 +312,5 @@ static void __exit epia_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(epia_init)
-module_exit(epia_exit)
+module_init(epia_init);
+module_exit(epia_exit);
diff --git a/drivers/block/paride/fit2.c b/drivers/block/paride/fit2.c
index 3812837..e776971 100644
--- a/drivers/block/paride/fit2.c
+++ b/drivers/block/paride/fit2.c
@@ -147,5 +147,5 @@ static void __exit fit2_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(fit2_init)
-module_exit(fit2_exit)
+module_init(fit2_init);
+module_exit(fit2_exit);
diff --git a/drivers/block/paride/fit3.c b/drivers/block/paride/fit3.c
index 275d269..0db2abc 100644
--- a/drivers/block/paride/fit3.c
+++ b/drivers/block/paride/fit3.c
@@ -207,5 +207,5 @@ static void __exit fit3_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(fit3_init)
-module_exit(fit3_exit)
+module_init(fit3_init);
+module_exit(fit3_exit);
diff --git a/drivers/block/paride/friq.c b/drivers/block/paride/friq.c
index 4f2ba24..e18db33 100644
--- a/drivers/block/paride/friq.c
+++ b/drivers/block/paride/friq.c
@@ -272,5 +272,5 @@ static void __exit friq_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(friq_init)
-module_exit(friq_exit)
+module_init(friq_init);
+module_exit(friq_exit);
diff --git a/drivers/block/paride/frpw.c b/drivers/block/paride/frpw.c
index c3cde36..1eafa29 100644
--- a/drivers/block/paride/frpw.c
+++ b/drivers/block/paride/frpw.c
@@ -309,5 +309,5 @@ static void __exit frpw_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(frpw_init)
-module_exit(frpw_exit)
+module_init(frpw_init);
+module_exit(frpw_exit);
diff --git a/drivers/block/paride/kbic.c b/drivers/block/paride/kbic.c
index 35999c4..d19fb56 100644
--- a/drivers/block/paride/kbic.c
+++ b/drivers/block/paride/kbic.c
@@ -301,5 +301,5 @@ static void __exit kbic_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(kbic_init)
-module_exit(kbic_exit)
+module_init(kbic_init);
+module_exit(kbic_exit);
diff --git a/drivers/block/paride/ktti.c b/drivers/block/paride/ktti.c
index 117ab0e..cf3eb25 100644
--- a/drivers/block/paride/ktti.c
+++ b/drivers/block/paride/ktti.c
@@ -124,5 +124,5 @@ static void __exit ktti_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(ktti_init)
-module_exit(ktti_exit)
+module_init(ktti_init);
+module_exit(ktti_exit);
diff --git a/drivers/block/paride/on20.c b/drivers/block/paride/on20.c
index 0173697..a6cd9bd 100644
--- a/drivers/block/paride/on20.c
+++ b/drivers/block/paride/on20.c
@@ -149,5 +149,5 @@ static void __exit on20_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(on20_init)
-module_exit(on20_exit)
+module_init(on20_init);
+module_exit(on20_exit);
diff --git a/drivers/block/paride/on26.c b/drivers/block/paride/on26.c
index 95ba256..72db56c 100644
--- a/drivers/block/paride/on26.c
+++ b/drivers/block/paride/on26.c
@@ -315,5 +315,5 @@ static void __exit on26_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(on26_init)
-module_exit(on26_exit)
+module_init(on26_init);
+module_exit(on26_exit);
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index e91d4b4..074071a 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -967,5 +967,5 @@ static void __exit pcd_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(pcd_init)
-module_exit(pcd_exit)
+module_init(pcd_init);
+module_exit(pcd_exit);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 9299455..b407890 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -942,5 +942,5 @@ static void __exit pd_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(pd_init)
-module_exit(pd_exit)
+module_init(pd_init);
+module_exit(pd_exit);
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index bef3b99..4823925 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -988,5 +988,5 @@ static void __exit pf_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(pf_init)
-module_exit(pf_exit)
+module_init(pf_init);
+module_exit(pf_exit);
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index 9dfa271..f038d4e 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -718,5 +718,5 @@ static void __exit pg_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(pg_init)
-module_exit(pg_exit)
+module_init(pg_init);
+module_exit(pg_exit);
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 1e4006e..2e69a7e 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -1008,5 +1008,5 @@ static void __exit pt_exit(void)
  }

  MODULE_LICENSE("GPL");
-module_init(pt_init)
-module_exit(pt_exit)
+module_init(pt_init);
+module_exit(pt_exit);
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 6129653..685aadb 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1181,7 +1181,7 @@ int swim3_init(void)
      return 0;
  }

-module_init(swim3_init)
+module_init(swim3_init);

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Paul Mackerras");
diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index b97aebd..a50ed12 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -2067,8 +2067,8 @@ static __exit void rs_exit(void)
      release_mem_region(CUSTOM_PHYSADDR+0x30, 4);
  }

-module_init(rs_init)
-module_exit(rs_exit)
+module_init(rs_init);
+module_exit(rs_exit);


  #if defined(CONFIG_SERIAL_CONSOLE) && !defined(MODULE)
diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
index 7a11682..e0e529f 100644
--- a/drivers/gpio/bt8xxgpio.c
+++ b/drivers/gpio/bt8xxgpio.c
@@ -335,13 +335,13 @@ static int bt8xxgpio_init(void)
  {
      return pci_register_driver(&bt8xxgpio_pci_driver);
  }
-module_init(bt8xxgpio_init)
+module_init(bt8xxgpio_init);

  static void bt8xxgpio_exit(void)
  {
      pci_unregister_driver(&bt8xxgpio_pci_driver);
  }
-module_exit(bt8xxgpio_exit)
+module_exit(bt8xxgpio_exit);

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Michael Buesch");
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index b11e06f..19714c6 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -465,5 +465,5 @@ MODULE_LICENSE("GPL");
  module_param(read_only, bool, 0);
  MODULE_PARM_DESC(read_only, "Don't set any values, read only mode");

-module_init(sensors_adm1021_init)
-module_exit(sensors_adm1021_exit)
+module_init(sensors_adm1021_init);
+module_exit(sensors_adm1021_exit);
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 93c1722..704e3e3 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -475,5 +475,5 @@ MODULE_AUTHOR("Rudolf Marek <r.marek@assembler.cz>");
  MODULE_DESCRIPTION("Intel Core temperature monitor");
  MODULE_LICENSE("GPL");

-module_init(coretemp_init)
-module_exit(coretemp_exit)
+module_init(coretemp_init);
+module_exit(coretemp_exit);
diff --git a/drivers/hwmon/k8temp.c b/drivers/hwmon/k8temp.c
index bd2bde0..91d372b 100644
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -290,5 +290,5 @@ MODULE_AUTHOR("Rudolf Marek <r.marek@assembler.cz>");
  MODULE_DESCRIPTION("AMD K8 core temperature monitor");
  MODULE_LICENSE("GPL");

-module_init(k8temp_init)
-module_exit(k8temp_exit)
+module_init(k8temp_init);
+module_exit(k8temp_exit);
diff --git a/drivers/i2c/busses/i2c-amd756.c 
b/drivers/i2c/busses/i2c-amd756.c
index 424dad6..5109d09 100644
--- a/drivers/i2c/busses/i2c-amd756.c
+++ b/drivers/i2c/busses/i2c-amd756.c
@@ -426,5 +426,5 @@ MODULE_LICENSE("GPL");

  EXPORT_SYMBOL(amd756_smbus);

-module_init(amd756_init)
-module_exit(amd756_exit)
+module_init(amd756_init);
+module_exit(amd756_exit);
diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index cdbf126..02ec366 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -75,8 +75,8 @@ static void __exit dm_zero_exit(void)
          DMERR("unregister failed %d", r);
  }

-module_init(dm_zero_init)
-module_exit(dm_zero_exit)
+module_init(dm_zero_init);
+module_exit(dm_zero_exit);

  MODULE_AUTHOR("Christophe Saout <christophe@saout.de>");
  MODULE_DESCRIPTION(DM_NAME " dummy target returning zeros");
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1b1d326..fef1c0e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6398,7 +6398,7 @@ static __exit void md_exit(void)
  }

  subsys_initcall(md_init);
-module_exit(md_exit)
+module_exit(md_exit);

  static int get_ro(char *buffer, struct kernel_param *kp)
  {
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index ccd6566..5c9e082 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -412,8 +412,8 @@ static void __exit videodev_exit(void)
      unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
  }

-module_init(videodev_init)
-module_exit(videodev_exit)
+module_init(videodev_init);
+module_exit(videodev_exit);

  MODULE_AUTHOR("Alan Cox, Mauro Carvalho Chehab <mchehab@infradead.org>");
  MODULE_DESCRIPTION("Device registrar for Video4Linux drivers v2");
diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index 1a4d046..9191f63 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -436,7 +436,7 @@ static void __exit egpio_exit(void)

  /* start early for dependencies */
  subsys_initcall(egpio_init);
-module_exit(egpio_exit)
+module_exit(egpio_exit);

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Kevin O'Connor <kevin@koconnor.net>");
diff --git a/drivers/net/arcnet/arc-rimi.c b/drivers/net/arcnet/arc-rimi.c
index e3082a9..269746f 100644
--- a/drivers/net/arcnet/arc-rimi.c
+++ b/drivers/net/arcnet/arc-rimi.c
@@ -394,5 +394,5 @@ static int __init arcrimi_setup(char *s)
  __setup("arcrimi=", arcrimi_setup);
  #endif                /* MODULE */

-module_init(arc_rimi_init)
-module_exit(arc_rimi_exit)
+module_init(arc_rimi_init);
+module_exit(arc_rimi_exit);
diff --git a/drivers/net/arcnet/com20020-isa.c 
b/drivers/net/arcnet/com20020-isa.c
index ea53a94..3e78fe9 100644
--- a/drivers/net/arcnet/com20020-isa.c
+++ b/drivers/net/arcnet/com20020-isa.c
@@ -215,5 +215,5 @@ __setup("com20020=", com20020isa_setup);

  #endif                /* MODULE */

-module_init(com20020_init)
-module_exit(com20020_exit)
+module_init(com20020_init);
+module_exit(com20020_exit);
diff --git a/drivers/net/arcnet/com20020-pci.c 
b/drivers/net/arcnet/com20020-pci.c
index 8b51f63..f780411 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -189,5 +189,5 @@ static void __exit com20020pci_cleanup(void)
      pci_unregister_driver(&com20020pci_driver);
  }

-module_init(com20020pci_init)
-module_exit(com20020pci_cleanup)
+module_init(com20020pci_init);
+module_exit(com20020pci_cleanup);
diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
index 89de29b..3dfd040 100644
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -429,5 +429,5 @@ static void __exit com90io_exit(void)
      free_netdev(dev);
  }

-module_init(com90io_init)
-module_exit(com90io_exit)
+module_init(com90io_init);
+module_exit(com90io_exit);
diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
index 442938d..2aa50a0 100644
--- a/drivers/net/arm/at91_ether.c
+++ b/drivers/net/arm/at91_ether.c
@@ -1242,8 +1242,8 @@ static void __exit at91ether_exit(void)
      platform_driver_unregister(&at91ether_driver);
  }

-module_init(at91ether_init)
-module_exit(at91ether_exit)
+module_init(at91ether_init);
+module_exit(at91ether_exit);

  MODULE_LICENSE("GPL");
  MODULE_DESCRIPTION("AT91RM9200 EMAC Ethernet driver");
diff --git a/drivers/net/hp100.c b/drivers/net/hp100.c
index ebe7651..4f702b6 100644
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -3052,5 +3052,5 @@ static void __exit hp100_module_exit(void)
  #endif
  }

-module_init(hp100_module_init)
-module_exit(hp100_module_exit)
+module_init(hp100_module_init);
+module_exit(hp100_module_exit);
diff --git a/drivers/net/tulip/xircom_cb.c b/drivers/net/tulip/xircom_cb.c
index 13c8703..0275d1f 100644
--- a/drivers/net/tulip/xircom_cb.c
+++ b/drivers/net/tulip/xircom_cb.c
@@ -1259,6 +1259,6 @@ static void __exit xircom_exit(void)
      pci_unregister_driver(&xircom_ops);
  }

-module_init(xircom_init)
-module_exit(xircom_exit)
+module_init(xircom_init);
+module_exit(xircom_exit);

diff --git a/drivers/net/wireless/b43/main.c 
b/drivers/net/wireless/b43/main.c
index 7b31a32..091f303 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4859,5 +4859,5 @@ static void __exit b43_exit(void)
      b43_debugfs_exit();
  }

-module_init(b43_init)
-module_exit(b43_exit)
+module_init(b43_init);
+module_exit(b43_exit);
diff --git a/drivers/net/wireless/b43legacy/main.c 
b/drivers/net/wireless/b43legacy/main.c
index c1324e3..007bf6a 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -3957,5 +3957,5 @@ static void __exit b43legacy_exit(void)
      b43legacy_debugfs_exit();
  }

-module_init(b43legacy_init)
-module_exit(b43legacy_exit)
+module_init(b43legacy_init);
+module_exit(b43legacy_exit);
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 454b653..bb96871 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -759,5 +759,5 @@ static void __exit led_exit(void)
  }

  #ifdef CONFIG_PROC_FS
-module_init(led_create_procfs)
+module_init(led_create_procfs);
  #endif
diff --git a/drivers/parport/parport_amiga.c 
b/drivers/parport/parport_amiga.c
index 1586e1c..1bcccd1 100644
--- a/drivers/parport/parport_amiga.c
+++ b/drivers/parport/parport_amiga.c
@@ -282,5 +282,5 @@ MODULE_DESCRIPTION("Parport Driver for Amiga builtin 
Port");
  MODULE_SUPPORTED_DEVICE("Amiga builtin Parallel Port");
  MODULE_LICENSE("GPL");

-module_init(parport_amiga_init)
-module_exit(parport_amiga_exit)
+module_init(parport_amiga_init);
+module_exit(parport_amiga_exit);
diff --git a/drivers/parport/parport_atari.c 
b/drivers/parport/parport_atari.c
index ad4cdd2..44dc2b0 100644
--- a/drivers/parport/parport_atari.c
+++ b/drivers/parport/parport_atari.c
@@ -229,5 +229,5 @@ MODULE_DESCRIPTION("Parport Driver for Atari builtin 
Port");
  MODULE_SUPPORTED_DEVICE("Atari builtin Parallel Port");
  MODULE_LICENSE("GPL");

-module_init(parport_atari_init)
-module_exit(parport_atari_exit)
+module_init(parport_atari_init);
+module_exit(parport_atari_exit);
diff --git a/drivers/parport/parport_ax88796.c 
b/drivers/parport/parport_ax88796.c
index 6938d2e..10b5d6f 100644
--- a/drivers/parport/parport_ax88796.c
+++ b/drivers/parport/parport_ax88796.c
@@ -429,8 +429,8 @@ static void __exit parport_ax88796_exit(void)
      platform_driver_unregister(&axdrv);
  }

-module_init(parport_ax88796_init)
-module_exit(parport_ax88796_exit)
+module_init(parport_ax88796_init);
+module_exit(parport_ax88796_exit);

  MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
  MODULE_DESCRIPTION("AX88796 Parport parallel port driver");
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 6dec9ba..0db3259 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -401,5 +401,5 @@ MODULE_DESCRIPTION("Parport Driver for Multiface 3 
expansion cards Paralllel Por
  MODULE_SUPPORTED_DEVICE("Multiface 3 Parallel Port");
  MODULE_LICENSE("GPL");

-module_init(parport_mfc3_init)
-module_exit(parport_mfc3_exit)
+module_init(parport_mfc3_init);
+module_exit(parport_mfc3_exit);
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 96f3bdf..1d54d2d 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -3513,5 +3513,5 @@ static void __exit parport_pc_exit(void)
  MODULE_AUTHOR("Phil Blundell, Tim Waugh, others");
  MODULE_DESCRIPTION("PC-style parallel port driver");
  MODULE_LICENSE("GPL");
-module_init(parport_pc_init)
-module_exit(parport_pc_exit)
+module_init(parport_pc_init);
+module_exit(parport_pc_exit);
diff --git a/drivers/parport/parport_sunbpp.c 
b/drivers/parport/parport_sunbpp.c
index 065f229..99cd059 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -404,5 +404,5 @@ MODULE_SUPPORTED_DEVICE("Sparc Bidirectional 
Parallel Port");
  MODULE_VERSION("2.0");
  MODULE_LICENSE("GPL");

-module_init(parport_sunbpp_init)
-module_exit(parport_sunbpp_exit)
+module_init(parport_sunbpp_init);
+module_exit(parport_sunbpp_exit);
diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index 554e11f..8a8c9a5 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -611,5 +611,5 @@ static void __exit parport_default_proc_unregister 
(void)
  }
  #endif

-module_init(parport_default_proc_register)
-module_exit(parport_default_proc_unregister)
+module_init(parport_default_proc_register);
+module_exit(parport_default_proc_unregister);
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 11a61ea..260cb16 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1920,7 +1920,7 @@ static void __exit nsp_cs_exit(void)
  }


-module_init(nsp_cs_init)
-module_exit(nsp_cs_exit)
+module_init(nsp_cs_init);
+module_exit(nsp_cs_exit);

  /* end */
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 65a1ed9..e5f44a4 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1389,4 +1389,4 @@ static void __exit ssb_modexit(void)
      b43_pci_ssb_bridge_exit();
      bus_unregister(&ssb_bustype);
  }
-module_exit(ssb_modexit)
+module_exit(ssb_modexit);
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 2d2440c..e37ea48 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -774,6 +774,6 @@ static void __exit uio_exit(void)
  {
  }

-module_init(uio_init)
-module_exit(uio_exit)
+module_init(uio_init);
+module_exit(uio_exit);
  MODULE_LICENSE("GPL v2");
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 332b5ff..56affba 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -319,8 +319,8 @@ static void __exit exit_v9fs(void)
      unregister_filesystem(&v9fs_fs_type);
  }

-module_init(init_v9fs)
-module_exit(exit_v9fs)
+module_init(init_v9fs);
+module_exit(exit_v9fs);

  MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
  MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 7f83a46..88d50db 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -524,5 +524,5 @@ static void __exit exit_adfs_fs(void)
      destroy_inodecache();
  }

-module_init(init_adfs_fs)
-module_exit(exit_adfs_fs)
+module_init(init_adfs_fs);
+module_exit(exit_adfs_fs);
diff --git a/fs/affs/super.c b/fs/affs/super.c
index a19d64b..0c6f6f3 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -585,5 +585,5 @@ static void __exit exit_affs_fs(void)
  MODULE_DESCRIPTION("Amiga filesystem support for Linux");
  MODULE_LICENSE("GPL");

-module_init(init_affs_fs)
-module_exit(exit_affs_fs)
+module_init(init_affs_fs);
+module_exit(exit_affs_fs);
diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
index 9722e4b..419d026 100644
--- a/fs/autofs4/init.c
+++ b/fs/autofs4/init.c
@@ -46,6 +46,6 @@ static void __exit exit_autofs4_fs(void)
      unregister_filesystem(&autofs_fs_type);
  }

-module_init(init_autofs4_fs)
-module_exit(exit_autofs4_fs)
+module_init(init_autofs4_fs);
+module_exit(exit_autofs4_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index b6dfee3..62810b9 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -967,5 +967,5 @@ Macros that typecheck the init and exit functions,
  ensures that they are called at init and cleanup,
  and eliminates warnings about unused functions.
  */
-module_init(init_befs_fs)
-module_exit(exit_befs_fs)
+module_init(init_befs_fs);
+module_exit(exit_befs_fs);
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 0ed57b5..986340e 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -459,5 +459,5 @@ static void __exit exit_bfs_fs(void)
      destroy_inodecache();
  }

-module_init(init_bfs_fs)
-module_exit(exit_bfs_fs)
+module_init(init_bfs_fs);
+module_exit(exit_bfs_fs);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0005a19..045f49f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1214,5 +1214,5 @@ MODULE_DESCRIPTION
      ("VFS to access servers complying with the SNIA CIFS Specification "
       "e.g. Samba and Windows");
  MODULE_VERSION(CIFS_VERSION);
-module_init(init_cifs)
-module_exit(exit_cifs)
+module_init(init_cifs);
+module_exit(exit_cifs);
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index f40423e..fb80111 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -562,6 +562,6 @@ static void __exit exit_cramfs_fs(void)
      unregister_filesystem(&cramfs_fs_type);
  }

-module_init(init_cramfs_fs)
-module_exit(exit_cramfs_fs)
+module_init(init_cramfs_fs);
+module_exit(exit_cramfs_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 5d61b7c..f5625af 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -289,6 +289,6 @@ static void __exit exit_devpts_fs(void)
      mntput(devpts_mnt);
  }

-module_init(init_devpts_fs)
-module_exit(exit_devpts_fs)
+module_init(init_devpts_fs);
+module_exit(exit_devpts_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/dnotify.c b/fs/dnotify.c
index 676073b..73d8eea 100644
--- a/fs/dnotify.c
+++ b/fs/dnotify.c
@@ -191,4 +191,4 @@ static int __init dnotify_init(void)
      return 0;
  }

-module_init(dnotify_init)
+module_init(dnotify_init);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index fd63071..fc26fab 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -823,5 +823,5 @@ MODULE_DESCRIPTION("eCryptfs");

  MODULE_LICENSE("GPL");

-module_init(ecryptfs_init)
-module_exit(ecryptfs_exit)
+module_init(ecryptfs_init);
+module_exit(ecryptfs_exit);
diff --git a/fs/efs/super.c b/fs/efs/super.c
index 73b19cf..d07df21 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -140,8 +140,8 @@ static void __exit exit_efs_fs(void) {
      destroy_inodecache();
  }

-module_init(init_efs_fs)
-module_exit(exit_efs_fs)
+module_init(init_efs_fs);
+module_exit(exit_efs_fs);

  static efs_block_t efs_validate_vh(struct volume_header *vh) {
      int        i;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 647cd88..68862f5 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1430,5 +1430,5 @@ static void __exit exit_ext2_fs(void)
      exit_ext2_xattr();
  }

-module_init(init_ext2_fs)
-module_exit(exit_ext2_fs)
+module_init(init_ext2_fs);
+module_exit(exit_ext2_fs);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f6c94f2..896a7f9 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -3001,5 +3001,5 @@ static void __exit exit_ext3_fs(void)
  MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas 
Dilger, Theodore Ts'o and others");
  MODULE_DESCRIPTION("Second Extended Filesystem with journaling 
extensions");
  MODULE_LICENSE("GPL");
-module_init(init_ext3_fs)
-module_exit(exit_ext3_fs)
+module_init(init_ext3_fs);
+module_exit(exit_ext3_fs);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e4a241c..14e2ae7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3617,5 +3617,5 @@ static void __exit exit_ext4_fs(void)
  MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas 
Dilger, Theodore Ts'o and others");
  MODULE_DESCRIPTION("Fourth Extended Filesystem with extents");
  MODULE_LICENSE("GPL");
-module_init(init_ext4_fs)
-module_exit(exit_ext4_fs)
+module_init(init_ext4_fs);
+module_exit(exit_ext4_fs);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d937aaf..f3466fb 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -1523,7 +1523,7 @@ static void __exit exit_fat_fs(void)
      fat_destroy_inodecache();
  }

-module_init(init_fat_fs)
-module_exit(exit_fat_fs)
+module_init(init_fat_fs);
+module_exit(exit_fat_fs);

  MODULE_LICENSE("GPL");
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 7ba03a4..f59c572 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -702,5 +702,5 @@ MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Werner Almesberger");
  MODULE_DESCRIPTION("MS-DOS filesystem support");

-module_init(init_msdos_fs)
-module_exit(exit_msdos_fs)
+module_init(init_msdos_fs);
+module_exit(exit_msdos_fs);
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index bf326d4..1e0ee48 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1094,5 +1094,5 @@ MODULE_LICENSE("GPL");
  MODULE_DESCRIPTION("VFAT filesystem support");
  MODULE_AUTHOR("Gordon Chaffee");

-module_init(init_vfat_fs)
-module_exit(exit_vfat_fs)
+module_init(init_vfat_fs);
+module_exit(exit_vfat_fs);
diff --git a/fs/fcntl.c b/fs/fcntl.c
index cdc1419..f7fd85d 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -602,4 +602,4 @@ static int __init fasync_init(void)
      return 0;
  }

-module_init(fasync_init)
+module_init(fasync_init);
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index c8b5acf..cdfcd3e 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -460,5 +460,5 @@ static void __exit exit_hfs_fs(void)
      kmem_cache_destroy(hfs_inode_cachep);
  }

-module_init(init_hfs_fs)
-module_exit(exit_hfs_fs)
+module_init(init_hfs_fs);
+module_exit(exit_hfs_fs);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index eb74531..d2aef04 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -513,5 +513,5 @@ static void __exit exit_hfsplus_fs(void)
      kmem_cache_destroy(hfsplus_inode_cachep);
  }

-module_init(init_hfsplus_fs)
-module_exit(exit_hfsplus_fs)
+module_init(init_hfsplus_fs);
+module_exit(exit_hfsplus_fs);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 3a31451..85b3dec 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -1050,6 +1050,6 @@ static void __exit exit_hostfs(void)
      unregister_filesystem(&hostfs_type);
  }

-module_init(init_hostfs)
-module_exit(exit_hostfs)
+module_init(init_hostfs);
+module_exit(exit_hostfs);
  MODULE_LICENSE("GPL");
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 0d049b8..3334bae 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -702,6 +702,6 @@ static void __exit exit_hpfs_fs(void)
      destroy_inodecache();
  }

-module_init(init_hpfs_fs)
-module_exit(exit_hpfs_fs)
+module_init(init_hpfs_fs);
+module_exit(exit_hpfs_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index b278f7f..e92dcd8 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -761,6 +761,6 @@ static void __exit exit_hppfs(void)
      unregister_filesystem(&hppfs_type);
  }

-module_init(init_hppfs)
-module_exit(exit_hppfs)
+module_init(init_hppfs);
+module_exit(exit_hppfs);
  MODULE_LICENSE("GPL");
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7d479ce..a986f4c 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1046,7 +1046,7 @@ static void __exit exit_hugetlbfs_fs(void)
      bdi_destroy(&hugetlbfs_backing_dev_info);
  }

-module_init(init_hugetlbfs_fs)
-module_exit(exit_hugetlbfs_fs)
+module_init(init_hugetlbfs_fs);
+module_exit(exit_hugetlbfs_fs);

  MODULE_LICENSE("GPL");
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 3f8af0f..9bc1879 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1496,8 +1496,8 @@ static void __exit exit_iso9660_fs(void)
      destroy_inodecache();
  }

-module_init(init_iso9660_fs)
-module_exit(exit_iso9660_fs)
+module_init(init_iso9660_fs);
+module_exit(exit_iso9660_fs);
  MODULE_LICENSE("GPL");
  /* Actual filesystem name is iso9660, as requested in filesystems.c */
  MODULE_ALIAS("iso9660");
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 0dae345..a7579df 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -879,5 +879,5 @@ static void __exit exit_jfs_fs(void)
      kmem_cache_destroy(jfs_inode_cachep);
  }

-module_init(init_jfs_fs)
-module_exit(exit_jfs_fs)
+module_init(init_jfs_fs);
+module_exit(exit_jfs_fs);
diff --git a/fs/mbcache.c b/fs/mbcache.c
index ec88ff3..3a43aa7 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -674,6 +674,6 @@ static void __exit exit_mbcache(void)
      unregister_shrinker(&mb_cache_shrinker);
  }

-module_init(init_mbcache)
-module_exit(exit_mbcache)
+module_init(init_mbcache);
+module_exit(exit_mbcache);

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index d1d1eb8..6026177 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -647,7 +647,7 @@ static void __exit exit_minix_fs(void)
      destroy_inodecache();
  }

-module_init(init_minix_fs)
-module_exit(exit_minix_fs)
+module_init(init_minix_fs);
+module_exit(exit_minix_fs);
  MODULE_LICENSE("GPL");

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index d642f0e..6bec425 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -1044,6 +1044,6 @@ static void __exit exit_ncp_fs(void)
      destroy_inodecache();
  }

-module_init(init_ncp_fs)
-module_exit(exit_ncp_fs)
+module_init(init_ncp_fs);
+module_exit(exit_ncp_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index d22eb38..7977bef 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1419,5 +1419,5 @@ MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
  MODULE_LICENSE("GPL");
  module_param(enable_ino64, bool, 0644);

-module_init(init_nfs_fs)
-module_exit(exit_nfs_fs)
+module_init(init_nfs_fs);
+module_exit(exit_nfs_fs);
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 77d7b8c..97d636c 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -925,5 +925,5 @@ static void __exit exit_nfsd(void)

  MODULE_AUTHOR("Olaf Kirch <okir@monad.swb.de>");
  MODULE_LICENSE("GPL");
-module_init(init_nfsd)
-module_exit(exit_nfsd)
+module_init(init_nfsd);
+module_exit(exit_nfsd);
diff --git a/fs/nls/nls_ascii.c b/fs/nls/nls_ascii.c
index 7020e94..5cd626f 100644
--- a/fs/nls/nls_ascii.c
+++ b/fs/nls/nls_ascii.c
@@ -161,7 +161,7 @@ static void __exit exit_nls_ascii(void)
      unregister_nls(&table);
  }

-module_init(init_nls_ascii)
-module_exit(exit_nls_ascii)
+module_init(init_nls_ascii);
+module_exit(exit_nls_ascii);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp1250.c b/fs/nls/nls_cp1250.c
index c8471fe..a231e04 100644
--- a/fs/nls/nls_cp1250.c
+++ b/fs/nls/nls_cp1250.c
@@ -341,7 +341,7 @@ static void __exit exit_nls_cp1250(void)
          unregister_nls(&table);
  }

-module_init(init_nls_cp1250)
-module_exit(exit_nls_cp1250)
+module_init(init_nls_cp1250);
+module_exit(exit_nls_cp1250);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp1251.c b/fs/nls/nls_cp1251.c
index 1939b46..7f422c5 100644
--- a/fs/nls/nls_cp1251.c
+++ b/fs/nls/nls_cp1251.c
@@ -296,7 +296,7 @@ static void __exit exit_nls_cp1251(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp1251)
-module_exit(exit_nls_cp1251)
+module_init(init_nls_cp1251);
+module_exit(exit_nls_cp1251);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp1255.c b/fs/nls/nls_cp1255.c
index 8120ae2..2df7740 100644
--- a/fs/nls/nls_cp1255.c
+++ b/fs/nls/nls_cp1255.c
@@ -378,8 +378,8 @@ static void __exit exit_nls_cp1255(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp1255)
-module_exit(exit_nls_cp1255)
+module_init(init_nls_cp1255);
+module_exit(exit_nls_cp1255);

  MODULE_LICENSE("Dual BSD/GPL");
  MODULE_ALIAS_NLS(iso8859-8);
diff --git a/fs/nls/nls_cp437.c b/fs/nls/nls_cp437.c
index ff37a46..488d1c1 100644
--- a/fs/nls/nls_cp437.c
+++ b/fs/nls/nls_cp437.c
@@ -382,7 +382,7 @@ static void __exit exit_nls_cp437(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp437)
-module_exit(exit_nls_cp437)
+module_init(init_nls_cp437);
+module_exit(exit_nls_cp437);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp737.c b/fs/nls/nls_cp737.c
index f5576b8..71e4ba2 100644
--- a/fs/nls/nls_cp737.c
+++ b/fs/nls/nls_cp737.c
@@ -345,7 +345,7 @@ static void __exit exit_nls_cp737(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp737)
-module_exit(exit_nls_cp737)
+module_init(init_nls_cp737);
+module_exit(exit_nls_cp737);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp775.c b/fs/nls/nls_cp775.c
index 4905635..09e5027 100644
--- a/fs/nls/nls_cp775.c
+++ b/fs/nls/nls_cp775.c
@@ -314,7 +314,7 @@ static void __exit exit_nls_cp775(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp775)
-module_exit(exit_nls_cp775)
+module_init(init_nls_cp775);
+module_exit(exit_nls_cp775);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp850.c b/fs/nls/nls_cp850.c
index fe5bdad..c37aa74 100644
--- a/fs/nls/nls_cp850.c
+++ b/fs/nls/nls_cp850.c
@@ -310,7 +310,7 @@ static void __exit exit_nls_cp850(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp850)
-module_exit(exit_nls_cp850)
+module_init(init_nls_cp850);
+module_exit(exit_nls_cp850);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp852.c b/fs/nls/nls_cp852.c
index ceb1c01..db5233f 100644
--- a/fs/nls/nls_cp852.c
+++ b/fs/nls/nls_cp852.c
@@ -332,7 +332,7 @@ static void __exit exit_nls_cp852(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp852)
-module_exit(exit_nls_cp852)
+module_init(init_nls_cp852);
+module_exit(exit_nls_cp852);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp855.c b/fs/nls/nls_cp855.c
index cc7f5fb..fa0bf36 100644
--- a/fs/nls/nls_cp855.c
+++ b/fs/nls/nls_cp855.c
@@ -294,7 +294,7 @@ static void __exit exit_nls_cp855(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp855)
-module_exit(exit_nls_cp855)
+module_init(init_nls_cp855);
+module_exit(exit_nls_cp855);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp857.c b/fs/nls/nls_cp857.c
index e418e19..f6d2f3c 100644
--- a/fs/nls/nls_cp857.c
+++ b/fs/nls/nls_cp857.c
@@ -296,7 +296,7 @@ static void __exit exit_nls_cp857(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp857)
-module_exit(exit_nls_cp857)
+module_init(init_nls_cp857);
+module_exit(exit_nls_cp857);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp860.c b/fs/nls/nls_cp860.c
index a86c97d..efcb9e6 100644
--- a/fs/nls/nls_cp860.c
+++ b/fs/nls/nls_cp860.c
@@ -359,7 +359,7 @@ static void __exit exit_nls_cp860(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp860)
-module_exit(exit_nls_cp860)
+module_init(init_nls_cp860);
+module_exit(exit_nls_cp860);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp861.c b/fs/nls/nls_cp861.c
index bd92022..1314fea 100644
--- a/fs/nls/nls_cp861.c
+++ b/fs/nls/nls_cp861.c
@@ -382,7 +382,7 @@ static void __exit exit_nls_cp861(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp861)
-module_exit(exit_nls_cp861)
+module_init(init_nls_cp861);
+module_exit(exit_nls_cp861);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp862.c b/fs/nls/nls_cp862.c
index e9b68eb..ac0dfa1 100644
--- a/fs/nls/nls_cp862.c
+++ b/fs/nls/nls_cp862.c
@@ -416,7 +416,7 @@ static void __exit exit_nls_cp862(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp862)
-module_exit(exit_nls_cp862)
+module_init(init_nls_cp862);
+module_exit(exit_nls_cp862);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp863.c b/fs/nls/nls_cp863.c
index f8a9b07..7a1a927 100644
--- a/fs/nls/nls_cp863.c
+++ b/fs/nls/nls_cp863.c
@@ -376,7 +376,7 @@ static void __exit exit_nls_cp863(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp863)
-module_exit(exit_nls_cp863)
+module_init(init_nls_cp863);
+module_exit(exit_nls_cp863);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp864.c b/fs/nls/nls_cp864.c
index 8d31f43..e6e0f27 100644
--- a/fs/nls/nls_cp864.c
+++ b/fs/nls/nls_cp864.c
@@ -402,7 +402,7 @@ static void __exit exit_nls_cp864(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp864)
-module_exit(exit_nls_cp864)
+module_init(init_nls_cp864);
+module_exit(exit_nls_cp864);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp865.c b/fs/nls/nls_cp865.c
index 4bd902f..dc62732 100644
--- a/fs/nls/nls_cp865.c
+++ b/fs/nls/nls_cp865.c
@@ -382,7 +382,7 @@ static void __exit exit_nls_cp865(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp865)
-module_exit(exit_nls_cp865)
+module_init(init_nls_cp865);
+module_exit(exit_nls_cp865);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp866.c b/fs/nls/nls_cp866.c
index bdc7cb3..26e7b56 100644
--- a/fs/nls/nls_cp866.c
+++ b/fs/nls/nls_cp866.c
@@ -300,7 +300,7 @@ static void __exit exit_nls_cp866(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp866)
-module_exit(exit_nls_cp866)
+module_init(init_nls_cp866);
+module_exit(exit_nls_cp866);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp869.c b/fs/nls/nls_cp869.c
index 9f283a2..17c3385 100644
--- a/fs/nls/nls_cp869.c
+++ b/fs/nls/nls_cp869.c
@@ -310,7 +310,7 @@ static void __exit exit_nls_cp869(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp869)
-module_exit(exit_nls_cp869)
+module_init(init_nls_cp869);
+module_exit(exit_nls_cp869);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_cp874.c b/fs/nls/nls_cp874.c
index 0b3c488..afcbd8e 100644
--- a/fs/nls/nls_cp874.c
+++ b/fs/nls/nls_cp874.c
@@ -269,8 +269,8 @@ static void __exit exit_nls_cp874(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp874)
-module_exit(exit_nls_cp874)
+module_init(init_nls_cp874);
+module_exit(exit_nls_cp874);

  MODULE_LICENSE("Dual BSD/GPL");
  MODULE_ALIAS_NLS(tis-620);
diff --git a/fs/nls/nls_cp932.c b/fs/nls/nls_cp932.c
index 0ffed6f..038b753 100644
--- a/fs/nls/nls_cp932.c
+++ b/fs/nls/nls_cp932.c
@@ -7927,8 +7927,8 @@ static void __exit exit_nls_cp932(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp932)
-module_exit(exit_nls_cp932)
+module_init(init_nls_cp932);
+module_exit(exit_nls_cp932);

  MODULE_LICENSE("Dual BSD/GPL");
  MODULE_ALIAS_NLS(sjis);
diff --git a/fs/nls/nls_cp936.c b/fs/nls/nls_cp936.c
index 8277030..03e28ea 100644
--- a/fs/nls/nls_cp936.c
+++ b/fs/nls/nls_cp936.c
@@ -11105,8 +11105,8 @@ static void __exit exit_nls_cp936(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp936)
-module_exit(exit_nls_cp936)
+module_init(init_nls_cp936);
+module_exit(exit_nls_cp936);

  MODULE_LICENSE("Dual BSD/GPL");
  MODULE_ALIAS_NLS(gb2312);
diff --git a/fs/nls/nls_cp949.c b/fs/nls/nls_cp949.c
index 8a7a2fe..83a1643 100644
--- a/fs/nls/nls_cp949.c
+++ b/fs/nls/nls_cp949.c
@@ -13940,8 +13940,8 @@ static void __exit exit_nls_cp949(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp949)
-module_exit(exit_nls_cp949)
+module_init(init_nls_cp949);
+module_exit(exit_nls_cp949);

  MODULE_LICENSE("Dual BSD/GPL");
  MODULE_ALIAS_NLS(euc-kr);
diff --git a/fs/nls/nls_cp950.c b/fs/nls/nls_cp950.c
index ef25368..47adf75 100644
--- a/fs/nls/nls_cp950.c
+++ b/fs/nls/nls_cp950.c
@@ -9476,8 +9476,8 @@ static void __exit exit_nls_cp950(void)
      unregister_nls(&table);
  }

-module_init(init_nls_cp950)
-module_exit(exit_nls_cp950)
+module_init(init_nls_cp950);
+module_exit(exit_nls_cp950);

  MODULE_LICENSE("Dual BSD/GPL");
  MODULE_ALIAS_NLS(big5);
diff --git a/fs/nls/nls_euc-jp.c b/fs/nls/nls_euc-jp.c
index 7424929..f617dec 100644
--- a/fs/nls/nls_euc-jp.c
+++ b/fs/nls/nls_euc-jp.c
@@ -575,7 +575,7 @@ static void __exit exit_nls_euc_jp(void)
      unload_nls(p_nls);
  }

-module_init(init_nls_euc_jp)
-module_exit(exit_nls_euc_jp)
+module_init(init_nls_euc_jp);
+module_exit(exit_nls_euc_jp);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-1.c b/fs/nls/nls_iso8859-1.c
index 7b951bb..2d2a168 100644
--- a/fs/nls/nls_iso8859-1.c
+++ b/fs/nls/nls_iso8859-1.c
@@ -252,7 +252,7 @@ static void __exit exit_nls_iso8859_1(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_1)
-module_exit(exit_nls_iso8859_1)
+module_init(init_nls_iso8859_1);
+module_exit(exit_nls_iso8859_1);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-13.c b/fs/nls/nls_iso8859-13.c
index c4d52ea..7057dc1 100644
--- a/fs/nls/nls_iso8859-13.c
+++ b/fs/nls/nls_iso8859-13.c
@@ -280,7 +280,7 @@ static void __exit exit_nls_iso8859_13(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_13)
-module_exit(exit_nls_iso8859_13)
+module_init(init_nls_iso8859_13);
+module_exit(exit_nls_iso8859_13);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-14.c b/fs/nls/nls_iso8859-14.c
index dc02600..4cbb2e9 100644
--- a/fs/nls/nls_iso8859-14.c
+++ b/fs/nls/nls_iso8859-14.c
@@ -336,7 +336,7 @@ static void __exit exit_nls_iso8859_14(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_14)
-module_exit(exit_nls_iso8859_14)
+module_init(init_nls_iso8859_14);
+module_exit(exit_nls_iso8859_14);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-15.c b/fs/nls/nls_iso8859-15.c
index 3c7dfc8..007dc30 100644
--- a/fs/nls/nls_iso8859-15.c
+++ b/fs/nls/nls_iso8859-15.c
@@ -302,7 +302,7 @@ static void __exit exit_nls_iso8859_15(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_15)
-module_exit(exit_nls_iso8859_15)
+module_init(init_nls_iso8859_15);
+module_exit(exit_nls_iso8859_15);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-2.c b/fs/nls/nls_iso8859-2.c
index a2d2197..8b4dac8 100644
--- a/fs/nls/nls_iso8859-2.c
+++ b/fs/nls/nls_iso8859-2.c
@@ -303,7 +303,7 @@ static void __exit exit_nls_iso8859_2(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_2)
-module_exit(exit_nls_iso8859_2)
+module_init(init_nls_iso8859_2);
+module_exit(exit_nls_iso8859_2);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-3.c b/fs/nls/nls_iso8859-3.c
index a61e0da..07e0247 100644
--- a/fs/nls/nls_iso8859-3.c
+++ b/fs/nls/nls_iso8859-3.c
@@ -303,7 +303,7 @@ static void __exit exit_nls_iso8859_3(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_3)
-module_exit(exit_nls_iso8859_3)
+module_init(init_nls_iso8859_3);
+module_exit(exit_nls_iso8859_3);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-4.c b/fs/nls/nls_iso8859-4.c
index e8ff555..9387240 100644
--- a/fs/nls/nls_iso8859-4.c
+++ b/fs/nls/nls_iso8859-4.c
@@ -303,7 +303,7 @@ static void __exit exit_nls_iso8859_4(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_4)
-module_exit(exit_nls_iso8859_4)
+module_init(init_nls_iso8859_4);
+module_exit(exit_nls_iso8859_4);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-5.c b/fs/nls/nls_iso8859-5.c
index 4721e89..d168fd2 100644
--- a/fs/nls/nls_iso8859-5.c
+++ b/fs/nls/nls_iso8859-5.c
@@ -267,7 +267,7 @@ static void __exit exit_nls_iso8859_5(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_5)
-module_exit(exit_nls_iso8859_5)
+module_init(init_nls_iso8859_5);
+module_exit(exit_nls_iso8859_5);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-6.c b/fs/nls/nls_iso8859-6.c
index 01a517d..cd0e99a 100644
--- a/fs/nls/nls_iso8859-6.c
+++ b/fs/nls/nls_iso8859-6.c
@@ -258,7 +258,7 @@ static void __exit exit_nls_iso8859_6(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_6)
-module_exit(exit_nls_iso8859_6)
+module_init(init_nls_iso8859_6);
+module_exit(exit_nls_iso8859_6);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-7.c b/fs/nls/nls_iso8859-7.c
index 2d27b93..70c923c 100644
--- a/fs/nls/nls_iso8859-7.c
+++ b/fs/nls/nls_iso8859-7.c
@@ -312,7 +312,7 @@ static void __exit exit_nls_iso8859_7(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_7)
-module_exit(exit_nls_iso8859_7)
+module_init(init_nls_iso8859_7);
+module_exit(exit_nls_iso8859_7);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_iso8859-9.c b/fs/nls/nls_iso8859-9.c
index 694bf07..82dec0c 100644
--- a/fs/nls/nls_iso8859-9.c
+++ b/fs/nls/nls_iso8859-9.c
@@ -267,7 +267,7 @@ static void __exit exit_nls_iso8859_9(void)
      unregister_nls(&table);
  }

-module_init(init_nls_iso8859_9)
-module_exit(exit_nls_iso8859_9)
+module_init(init_nls_iso8859_9);
+module_exit(exit_nls_iso8859_9);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_koi8-r.c b/fs/nls/nls_koi8-r.c
index 4387531..16ae9aa 100644
--- a/fs/nls/nls_koi8-r.c
+++ b/fs/nls/nls_koi8-r.c
@@ -318,7 +318,7 @@ static void __exit exit_nls_koi8_r(void)
      unregister_nls(&table);
  }

-module_init(init_nls_koi8_r)
-module_exit(exit_nls_koi8_r)
+module_init(init_nls_koi8_r);
+module_exit(exit_nls_koi8_r);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_koi8-ru.c b/fs/nls/nls_koi8-ru.c
index e7bc1d7..8988308 100644
--- a/fs/nls/nls_koi8-ru.c
+++ b/fs/nls/nls_koi8-ru.c
@@ -77,7 +77,7 @@ static void __exit exit_nls_koi8_ru(void)
      unload_nls(p_nls);
  }

-module_init(init_nls_koi8_ru)
-module_exit(exit_nls_koi8_ru)
+module_init(init_nls_koi8_ru);
+module_exit(exit_nls_koi8_ru);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_koi8-u.c b/fs/nls/nls_koi8-u.c
index 8c9f029..3e1ebf6 100644
--- a/fs/nls/nls_koi8-u.c
+++ b/fs/nls/nls_koi8-u.c
@@ -325,7 +325,7 @@ static void __exit exit_nls_koi8_u(void)
      unregister_nls(&table);
  }

-module_init(init_nls_koi8_u)
-module_exit(exit_nls_koi8_u)
+module_init(init_nls_koi8_u);
+module_exit(exit_nls_koi8_u);

  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/nls/nls_utf8.c b/fs/nls/nls_utf8.c
index aa2c42f..832d393 100644
--- a/fs/nls/nls_utf8.c
+++ b/fs/nls/nls_utf8.c
@@ -56,6 +56,6 @@ static void __exit exit_nls_utf8(void)
          unregister_nls(&table);
  }

-module_init(init_nls_utf8)
-module_exit(exit_nls_utf8)
+module_init(init_nls_utf8);
+module_exit(exit_nls_utf8);
  MODULE_LICENSE("Dual BSD/GPL");
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 4a46743..3c763a9 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -3241,5 +3241,5 @@ module_param(debug_msgs, bool, 0);
  MODULE_PARM_DESC(debug_msgs, "Enable debug messages.");
  #endif

-module_init(init_ntfs_fs)
-module_exit(exit_ntfs_fs)
+module_init(init_ntfs_fs);
+module_exit(exit_ntfs_fs);
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 70e8fa9..162dfaf 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -923,5 +923,5 @@ out:
  MODULE_AUTHOR("Oracle");
  MODULE_LICENSE("GPL");

-module_init(init_o2nm)
-module_exit(exit_o2nm)
+module_init(init_o2nm);
+module_exit(exit_o2nm);
diff --git a/fs/ocfs2/dlm/dlmfs.c b/fs/ocfs2/dlm/dlmfs.c
index 6f7a77d..045656c 100644
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -649,5 +649,5 @@ static void __exit exit_dlmfs_fs(void)
  MODULE_AUTHOR("Oracle");
  MODULE_LICENSE("GPL");

-module_init(init_dlmfs_fs)
-module_exit(exit_dlmfs_fs)
+module_init(init_dlmfs_fs);
+module_exit(exit_dlmfs_fs);
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index d41bdc7..21cd187 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -464,6 +464,6 @@ static void __exit exit_openprom_fs(void)
      kmem_cache_destroy(op_inode_cachep);
  }

-module_init(init_openprom_fs)
-module_exit(exit_openprom_fs)
+module_init(init_openprom_fs);
+module_exit(exit_openprom_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 03ec595..1e9f81b 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -657,4 +657,4 @@ static int __init vmcore_init(void)
          proc_vmcore->size = vmcore_size;
      return 0;
  }
-module_init(vmcore_init)
+module_init(vmcore_init);
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 2aad104..abfdece 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -616,7 +616,7 @@ static void __exit exit_qnx4_fs(void)
      destroy_inodecache();
  }

-module_init(init_qnx4_fs)
-module_exit(exit_qnx4_fs)
+module_init(init_qnx4_fs);
+module_exit(exit_qnx4_fs);
  MODULE_LICENSE("GPL");

diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a83a351..6cc6f9e 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -219,8 +219,8 @@ static void __exit exit_ramfs_fs(void)
      unregister_filesystem(&ramfs_fs_type);
  }

-module_init(init_ramfs_fs)
-module_exit(exit_ramfs_fs)
+module_init(init_ramfs_fs);
+module_exit(exit_ramfs_fs);

  int __init init_rootfs(void)
  {
diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index 60d2f82..90acc47 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -661,6 +661,6 @@ static void __exit exit_romfs_fs(void)

  /* Yes, works even as a module... :) */

-module_init(init_romfs_fs)
-module_exit(exit_romfs_fs)
+module_init(init_romfs_fs);
+module_exit(exit_romfs_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index fc27fbf..6f23415 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -830,6 +830,6 @@ static void __exit exit_smb_fs(void)
      destroy_inodecache();
  }

-module_init(init_smb_fs)
-module_exit(exit_smb_fs)
+module_init(init_smb_fs);
+module_exit(exit_smb_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/sysv/super.c b/fs/sysv/super.c
index 5a903da..062c271 100644
--- a/fs/sysv/super.c
+++ b/fs/sysv/super.c
@@ -558,6 +558,6 @@ static void __exit exit_sysv_fs(void)
      sysv_destroy_icache();
  }

-module_init(init_sysv_fs)
-module_exit(exit_sysv_fs)
+module_init(init_sysv_fs);
+module_exit(exit_sysv_fs);
  MODULE_LICENSE("GPL");
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e25e701..2746a21 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -230,8 +230,8 @@ static void __exit exit_udf_fs(void)
      destroy_inodecache();
  }

-module_init(init_udf_fs)
-module_exit(exit_udf_fs)
+module_init(init_udf_fs);
+module_exit(exit_udf_fs);

  static int udf_sb_alloc_partition_maps(struct super_block *sb, u32 count)
  {
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index e65212d..24d4be3 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1474,6 +1474,6 @@ static void __exit exit_ufs_fs(void)
      destroy_inodecache();
  }

-module_init(init_ufs_fs)
-module_exit(exit_ufs_fs)
+module_init(init_ufs_fs);
+module_exit(exit_ufs_fs);
  MODULE_LICENSE("GPL");
diff --git a/include/linux/init.h b/include/linux/init.h
index 68cb026..2de0f5c 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -257,7 +257,7 @@ void __init parse_early_param(void);
   * builtin) or at module insertion time (if a module).  There can only
   * be one per module.
   */
-#define module_init(x)    __initcall(x);
+#define module_init(x)    __initcall(x)

  /**
   * module_exit() - driver exit entry point
@@ -269,7 +269,7 @@ void __init parse_early_param(void);
   * compiled into the kernel, module_exit() has no effect.
   * There can only be one per module.
   */
-#define module_exit(x)    __exitcall(x);
+#define module_exit(x)    __exitcall(x)

  #else /* MODULE */

@@ -288,13 +288,13 @@ void __init parse_early_param(void);
  #define module_init(initfn)                    \
      static inline initcall_t __inittest(void)        \
      { return initfn; }                    \
-    int init_module(void) __attribute__((alias(#initfn)));
+    int init_module(void) __attribute__((alias(#initfn)))

  /* This is only required if you want to be unloadable. */
  #define module_exit(exitfn)                    \
      static inline exitcall_t __exittest(void)        \
      { return exitfn; }                    \
-    void cleanup_module(void) __attribute__((alias(#exitfn)));
+    void cleanup_module(void) __attribute__((alias(#exitfn)))

  #define __setup_param(str, unique_id, fn)    /* nothing */
  #define __setup(str, func)             /* nothing */
diff --git a/kernel/kexec.c b/kernel/kexec.c
index ac0fde7..1df7d1f 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1148,7 +1148,7 @@ static int __init crash_notes_memory_init(void)
      }
      return 0;
  }
-module_init(crash_notes_memory_init)
+module_init(crash_notes_memory_init);


  /*
@@ -1421,7 +1421,7 @@ static int __init crash_save_vmcoreinfo_init(void)
      return 0;
  }

-module_init(crash_save_vmcoreinfo_init)
+module_init(crash_save_vmcoreinfo_init);

  /*
   * Move into place and start executing a preloaded standalone
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8ac014..fea6ef7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4373,7 +4373,7 @@ static int __init init_per_zone_pages_min(void)
      setup_per_zone_inactive_ratio();
      return 0;
  }
-module_init(init_per_zone_pages_min)
+module_init(init_per_zone_pages_min);

  /*
   * min_free_kbytes_sysctl_handler - just a wrapper around 
proc_dointvec() so
diff --git a/mm/shmem.c b/mm/shmem.c
index f1b0d48..c09deb4 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2525,7 +2525,7 @@ out4:
      shm_mnt = ERR_PTR(error);
      return error;
  }
-module_init(init_tmpfs)
+module_init(init_tmpfs);

  /**
   * shmem_file_setup - get an unlinked file living in tmpfs
diff --git a/mm/tiny-shmem.c b/mm/tiny-shmem.c
index 3e67d57..3d837e4 100644
--- a/mm/tiny-shmem.c
+++ b/mm/tiny-shmem.c
@@ -37,7 +37,7 @@ static int __init init_tmpfs(void)

      return 0;
  }
-module_init(init_tmpfs)
+module_init(init_tmpfs);

  /**
   * shmem_file_setup - get an unlinked file living in tmpfs
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 62e7f62..6846012 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2182,7 +2182,7 @@ static int __init kswapd_init(void)
      return 0;
  }

-module_init(kswapd_init)
+module_init(kswapd_init);

  #ifdef CONFIG_NUMA
  /*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c3ccfda..4cf6c59 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -966,4 +966,4 @@ static int __init setup_vmstat(void)
  #endif
      return 0;
  }
-module_init(setup_vmstat)
+module_init(setup_vmstat);
diff --git a/net/9p/mod.c b/net/9p/mod.c
index cf8a412..8f0bc5b 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -165,8 +165,8 @@ static void __exit exit_p9(void)
      p9_trans_fd_exit();
  }

-module_init(init_p9)
-module_exit(exit_p9)
+module_init(init_p9);
+module_exit(exit_p9);

  MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
  MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 4d2c1f1..510c823 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -104,7 +104,7 @@ static void __exit br_deinit(void)

  EXPORT_SYMBOL(br_should_route_hook);

-module_init(br_init)
-module_exit(br_deinit)
+module_init(br_init);
+module_exit(br_deinit);
  MODULE_LICENSE("GPL");
  MODULE_VERSION(BR_VERSION);
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 4e2bda8..1e75d67 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -298,7 +298,7 @@ static void __exit exit_basic(void)
      unregister_tcf_proto_ops(&cls_basic_ops);
  }

-module_init(init_basic)
-module_exit(exit_basic)
+module_init(init_basic);
+module_exit(exit_basic);
  MODULE_LICENSE("GPL");

diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index 6d6e875..901f63d 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -395,6 +395,6 @@ static void __exit exit_fw(void)
      unregister_tcf_proto_ops(&cls_fw_ops);
  }

-module_init(init_fw)
-module_exit(exit_fw)
+module_init(init_fw);
+module_exit(exit_fw);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index bdf1f41..286ee40 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -615,6 +615,6 @@ static void __exit exit_route4(void)
      unregister_tcf_proto_ops(&cls_route4_ops);
  }

-module_init(init_route4)
-module_exit(exit_route4)
+module_init(init_route4);
+module_exit(exit_route4);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 7034ea4..4d85577 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -656,5 +656,5 @@ static void __exit exit_rsvp(void)
      unregister_tcf_proto_ops(&RSVP_OPS);
  }

-module_init(init_rsvp)
-module_exit(exit_rsvp)
+module_init(init_rsvp);
+module_exit(exit_rsvp);
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index e806f23..c11a06e 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -501,6 +501,6 @@ static void __exit exit_tcindex(void)
      unregister_tcf_proto_ops(&cls_tcindex_ops);
  }

-module_init(init_tcindex)
-module_exit(exit_tcindex)
+module_init(init_tcindex);
+module_exit(exit_tcindex);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 05d1780..e1b9f40 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -784,6 +784,6 @@ static void __exit exit_u32(void)
      unregister_tcf_proto_ops(&cls_u32_ops);
  }

-module_init(init_u32)
-module_exit(exit_u32)
+module_init(init_u32);
+module_exit(exit_u32);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 2a8b83a..bf7c0fb 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -709,6 +709,6 @@ static void __exit atm_exit(void)
      unregister_qdisc(&atm_qdisc_ops);
  }

-module_init(atm_init)
-module_exit(atm_exit)
+module_init(atm_init);
+module_exit(atm_exit);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_blackhole.c b/net/sched/sch_blackhole.c
index 094a874..dcc1636 100644
--- a/net/sched/sch_blackhole.c
+++ b/net/sched/sch_blackhole.c
@@ -47,7 +47,7 @@ static void __exit blackhole_module_exit(void)
      unregister_qdisc(&blackhole_qdisc_ops);
  }

-module_init(blackhole_module_init)
-module_exit(blackhole_module_exit)
+module_init(blackhole_module_init);
+module_exit(blackhole_module_exit);

  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 9e43ed9..5f9ca4b 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -2067,6 +2067,6 @@ static void __exit cbq_module_exit(void)
  {
      unregister_qdisc(&cbq_qdisc_ops);
  }
-module_init(cbq_module_init)
-module_exit(cbq_module_exit)
+module_init(cbq_module_init);
+module_exit(cbq_module_exit);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index d303daa..e227186 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -506,7 +506,7 @@ static void __exit dsmark_module_exit(void)
      unregister_qdisc(&dsmark_qdisc_ops);
  }

-module_init(dsmark_module_init)
-module_exit(dsmark_module_exit)
+module_init(dsmark_module_init);
+module_exit(dsmark_module_exit);

  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 40408d5..e355093 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -602,7 +602,7 @@ static void __exit gred_module_exit(void)
      unregister_qdisc(&gred_qdisc_ops);
  }

-module_init(gred_module_init)
-module_exit(gred_module_exit)
+module_init(gred_module_init);
+module_exit(gred_module_exit);

  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 5070643..409a9cf 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1553,6 +1553,6 @@ static void __exit htb_module_exit(void)
      unregister_qdisc(&htb_qdisc_ops);
  }

-module_init(htb_module_init)
-module_exit(htb_module_exit)
+module_init(htb_module_init);
+module_exit(htb_module_exit);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 4a2b773..3281853 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -154,6 +154,6 @@ static void __exit ingress_module_exit(void)
      unregister_qdisc(&ingress_qdisc_ops);
  }

-module_init(ingress_module_init)
-module_exit(ingress_module_exit)
+module_init(ingress_module_init);
+module_exit(ingress_module_exit);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 7e15186..bd5277f 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -467,7 +467,7 @@ static void __exit multiq_module_exit(void)
      unregister_qdisc(&multiq_qdisc_ops);
  }

-module_init(multiq_module_init)
-module_exit(multiq_module_exit)
+module_init(multiq_module_init);
+module_exit(multiq_module_exit);

  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index d876b87..8a98b91 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -619,6 +619,6 @@ static void __exit netem_module_exit(void)
  {
      unregister_qdisc(&netem_qdisc_ops);
  }
-module_init(netem_module_init)
-module_exit(netem_module_exit)
+module_init(netem_module_init);
+module_exit(netem_module_exit);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 94cecef..f4c5085 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -429,7 +429,7 @@ static void __exit prio_module_exit(void)
      unregister_qdisc(&prio_qdisc_ops);
  }

-module_init(prio_module_init)
-module_exit(prio_module_exit)
+module_init(prio_module_init);
+module_exit(prio_module_exit);

  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 2bdf241..9c23359 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -375,7 +375,7 @@ static void __exit red_module_exit(void)
      unregister_qdisc(&red_qdisc_ops);
  }

-module_init(red_module_init)
-module_exit(red_module_exit)
+module_init(red_module_init);
+module_exit(red_module_exit);

  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index f3965df..f899872 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -591,6 +591,6 @@ static void __exit sfq_module_exit(void)
  {
      unregister_qdisc(&sfq_qdisc_ops);
  }
-module_init(sfq_module_init)
-module_exit(sfq_module_exit)
+module_init(sfq_module_init);
+module_exit(sfq_module_exit);
  MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index a2f93c0..34bf539 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -482,6 +482,6 @@ static void __exit tbf_module_exit(void)
  {
      unregister_qdisc(&tbf_qdisc_ops);
  }
-module_init(tbf_module_init)
-module_exit(tbf_module_exit)
+module_init(tbf_module_init);
+module_exit(tbf_module_exit);
  MODULE_LICENSE("GPL");
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 853a414..db024a5 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1368,5 +1368,5 @@ static void __exit exit_rpcsec_gss(void)
  }

  MODULE_LICENSE("GPL");
-module_init(init_rpcsec_gss)
-module_exit(exit_rpcsec_gss)
+module_init(init_rpcsec_gss);
+module_exit(exit_rpcsec_gss);
diff --git a/samples/kprobes/jprobe_example.c 
b/samples/kprobes/jprobe_example.c
index b754135..40c2ec9 100644
--- a/samples/kprobes/jprobe_example.c
+++ b/samples/kprobes/jprobe_example.c
@@ -63,6 +63,6 @@ static void __exit jprobe_exit(void)
      printk(KERN_INFO "jprobe at %p unregistered\n", my_jprobe.kp.addr);
  }

-module_init(jprobe_init)
-module_exit(jprobe_exit)
+module_init(jprobe_init);
+module_exit(jprobe_exit);
  MODULE_LICENSE("GPL");
diff --git a/samples/kprobes/kprobe_example.c 
b/samples/kprobes/kprobe_example.c
index a681998..f31b2f8 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -86,6 +86,6 @@ static void __exit kprobe_exit(void)
      printk(KERN_INFO "kprobe at %p unregistered\n", kp.addr);
  }

-module_init(kprobe_init)
-module_exit(kprobe_exit)
+module_init(kprobe_init);
+module_exit(kprobe_exit);
  MODULE_LICENSE("GPL");
diff --git a/samples/kprobes/kretprobe_example.c 
b/samples/kprobes/kretprobe_example.c
index 4e764b3..237b93a 100644
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -101,6 +101,6 @@ static void __exit kretprobe_exit(void)
          my_kretprobe.nmissed, my_kretprobe.kp.symbol_name);
  }

-module_init(kretprobe_init)
-module_exit(kretprobe_exit)
+module_init(kretprobe_init);
+module_exit(kretprobe_exit);
  MODULE_LICENSE("GPL");
diff --git a/samples/markers/marker-example.c 
b/samples/markers/marker-example.c
index e90dc5d..fa921b8 100644
--- a/samples/markers/marker-example.c
+++ b/samples/markers/marker-example.c
@@ -45,8 +45,8 @@ static void example_exit(void)
      remove_proc_entry("marker-example", NULL);
  }

-module_init(example_init)
-module_exit(example_exit)
+module_init(example_init);
+module_exit(example_exit);

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Mathieu Desnoyers");
diff --git a/samples/tracepoints/tracepoint-sample.c 
b/samples/tracepoints/tracepoint-sample.c
index 00d1697..03cd940 100644
--- a/samples/tracepoints/tracepoint-sample.c
+++ b/samples/tracepoints/tracepoint-sample.c
@@ -48,8 +48,8 @@ static void example_exit(void)
      remove_proc_entry("tracepoint-example", NULL);
  }

-module_init(example_init)
-module_exit(example_exit)
+module_init(example_init);
+module_exit(example_exit);

  MODULE_LICENSE("GPL");
  MODULE_AUTHOR("Mathieu Desnoyers");
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 195cafc..5d90a74 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -522,7 +522,7 @@ static void __exit alsa_hwdep_exit(void)
      snd_hwdep_proc_done();
  }

-module_init(alsa_hwdep_init)
-module_exit(alsa_hwdep_exit)
+module_init(alsa_hwdep_init);
+module_exit(alsa_hwdep_exit);

  EXPORT_SYMBOL(snd_hwdep_new);
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 1b3534d..177e82c 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -524,8 +524,8 @@ static void __exit snd_mem_exit(void)
  }


-module_init(snd_mem_init)
-module_exit(snd_mem_exit)
+module_init(snd_mem_init);
+module_exit(snd_mem_exit);


  /*
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 4690b8b..d94d741 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -1383,7 +1383,7 @@ static void __exit alsa_mixer_oss_exit(void)
      }
  }

-module_init(alsa_mixer_oss_init)
-module_exit(alsa_mixer_oss_exit)
+module_init(alsa_mixer_oss_init);
+module_exit(alsa_mixer_oss_exit);

  EXPORT_SYMBOL(snd_mixer_oss_ioctl_card);
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index e178366..be38cef 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -3058,5 +3058,5 @@ static void __exit alsa_pcm_oss_exit(void)
      snd_pcm_notify(&snd_pcm_oss_notify, 1);
  }

-module_init(alsa_pcm_oss_init)
-module_exit(alsa_pcm_oss_exit)
+module_init(alsa_pcm_oss_init);
+module_exit(alsa_pcm_oss_exit);
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 192a433..8fe60d9 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1138,5 +1138,5 @@ static void __exit alsa_pcm_exit(void)
      snd_pcm_proc_done();
  }

-module_init(alsa_pcm_init)
-module_exit(alsa_pcm_exit)
+module_init(alsa_pcm_init);
+module_exit(alsa_pcm_exit);
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 002777b..a20ef2f 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1670,8 +1670,8 @@ static void __exit alsa_rawmidi_exit(void)
      snd_ctl_unregister_ioctl_compat(snd_rawmidi_control_ioctl);
  }

-module_init(alsa_rawmidi_init)
-module_exit(alsa_rawmidi_exit)
+module_init(alsa_rawmidi_init);
+module_exit(alsa_rawmidi_exit);

  EXPORT_SYMBOL(snd_rawmidi_output_params);
  EXPORT_SYMBOL(snd_rawmidi_input_params);
diff --git a/sound/core/rtctimer.c b/sound/core/rtctimer.c
index 0851cd1..cdb2b28 100644
--- a/sound/core/rtctimer.c
+++ b/sound/core/rtctimer.c
@@ -175,8 +175,8 @@ static void __exit rtctimer_exit(void)
  /*
   * exported stuff
   */
-module_init(rtctimer_init)
-module_exit(rtctimer_exit)
+module_init(rtctimer_init);
+module_exit(rtctimer_exit);

  module_param(rtctimer_freq, int, 0444);
  MODULE_PARM_DESC(rtctimer_freq, "timer frequency in Hz");
diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index f25e3cc..88a9b4d 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -116,8 +116,8 @@ static void __exit alsa_seq_oss_exit(void)
      unregister_device();
  }

-module_init(alsa_seq_oss_init)
-module_exit(alsa_seq_oss_exit)
+module_init(alsa_seq_oss_init);
+module_exit(alsa_seq_oss_exit);

  /*
   * ALSA minor device interface
diff --git a/sound/core/seq/seq.c b/sound/core/seq/seq.c
index bf09a5a..59a4a39 100644
--- a/sound/core/seq/seq.c
+++ b/sound/core/seq/seq.c
@@ -128,5 +128,5 @@ static void __exit alsa_seq_exit(void)
      snd_sequencer_memory_done();
  }

-module_init(alsa_seq_init)
-module_exit(alsa_seq_exit)
+module_init(alsa_seq_init);
+module_exit(alsa_seq_exit);
diff --git a/sound/core/seq/seq_device.c b/sound/core/seq/seq_device.c
index 1f99767..4be8a51 100644
--- a/sound/core/seq/seq_device.c
+++ b/sound/core/seq/seq_device.c
@@ -561,8 +561,8 @@ static void __exit alsa_seq_device_exit(void)
          snd_printk(KERN_ERR "drivers not released (%d)\n", num_ops);
  }

-module_init(alsa_seq_device_init)
-module_exit(alsa_seq_device_exit)
+module_init(alsa_seq_device_init);
+module_exit(alsa_seq_device_exit);

  EXPORT_SYMBOL(snd_seq_device_load_drivers);
  EXPORT_SYMBOL(snd_seq_device_new);
diff --git a/sound/core/seq/seq_dummy.c b/sound/core/seq/seq_dummy.c
index f3bdc54..097a2c0 100644
--- a/sound/core/seq/seq_dummy.c
+++ b/sound/core/seq/seq_dummy.c
@@ -257,5 +257,5 @@ static void __exit alsa_seq_dummy_exit(void)
      delete_client();
  }

-module_init(alsa_seq_dummy_init)
-module_exit(alsa_seq_dummy_exit)
+module_init(alsa_seq_dummy_init);
+module_exit(alsa_seq_dummy_exit);
diff --git a/sound/core/seq/seq_midi.c b/sound/core/seq/seq_midi.c
index 4d26146..652f152 100644
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -478,5 +478,5 @@ static void __exit alsa_seq_midi_exit(void)
      snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_MIDISYNTH);
  }

-module_init(alsa_seq_midi_init)
-module_exit(alsa_seq_midi_exit)
+module_init(alsa_seq_midi_init);
+module_exit(alsa_seq_midi_exit);
diff --git a/sound/core/seq/seq_midi_emul.c b/sound/core/seq/seq_midi_emul.c
index 07c6631..f8bad3d 100644
--- a/sound/core/seq/seq_midi_emul.c
+++ b/sound/core/seq/seq_midi_emul.c
@@ -730,8 +730,8 @@ static void __exit alsa_seq_midi_emul_exit(void)
  {
  }

-module_init(alsa_seq_midi_emul_init)
-module_exit(alsa_seq_midi_emul_exit)
+module_init(alsa_seq_midi_emul_init);
+module_exit(alsa_seq_midi_emul_exit);

  EXPORT_SYMBOL(snd_midi_process_event);
  EXPORT_SYMBOL(snd_midi_channel_set_clear);
diff --git a/sound/core/seq/seq_midi_event.c 
b/sound/core/seq/seq_midi_event.c
index 8284f17..d2dac08 100644
--- a/sound/core/seq/seq_midi_event.c
+++ b/sound/core/seq/seq_midi_event.c
@@ -545,5 +545,5 @@ static void __exit alsa_seq_midi_event_exit(void)
  {
  }

-module_init(alsa_seq_midi_event_init)
-module_exit(alsa_seq_midi_event_exit)
+module_init(alsa_seq_midi_event_init);
+module_exit(alsa_seq_midi_event_exit);
diff --git a/sound/core/seq/seq_virmidi.c b/sound/core/seq/seq_virmidi.c
index 86e7739..1f4e75a 100644
--- a/sound/core/seq/seq_virmidi.c
+++ b/sound/core/seq/seq_virmidi.c
@@ -536,7 +536,7 @@ static void __exit alsa_virmidi_exit(void)
  {
  }

-module_init(alsa_virmidi_init)
-module_exit(alsa_virmidi_exit)
+module_init(alsa_virmidi_init);
+module_exit(alsa_virmidi_exit);

  EXPORT_SYMBOL(snd_virmidi_new);
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 44a69bb..54de771 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -464,5 +464,5 @@ static void __exit alsa_sound_exit(void)
      unregister_chrdev(major, "alsa");
  }

-module_init(alsa_sound_init)
-module_exit(alsa_sound_exit)
+module_init(alsa_sound_init);
+module_exit(alsa_sound_exit);
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 7965320..edb1139 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1974,8 +1974,8 @@ static void __exit alsa_timer_exit(void)
  #endif
  }

-module_init(alsa_timer_init)
-module_exit(alsa_timer_exit)
+module_init(alsa_timer_init);
+module_exit(alsa_timer_exit);

  EXPORT_SYMBOL(snd_timer_open);
  EXPORT_SYMBOL(snd_timer_close);
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 73be7e1..58b85c7 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -711,5 +711,5 @@ static void __exit alsa_card_dummy_exit(void)
      snd_dummy_unregister_all();
  }

-module_init(alsa_card_dummy_init)
-module_exit(alsa_card_dummy_exit)
+module_init(alsa_card_dummy_init);
+module_exit(alsa_card_dummy_exit);
diff --git a/sound/drivers/ml403-ac97cr.c b/sound/drivers/ml403-ac97cr.c
index 7783843..f4bd8f7 100644
--- a/sound/drivers/ml403-ac97cr.c
+++ b/sound/drivers/ml403-ac97cr.c
@@ -1350,5 +1350,5 @@ static void __exit alsa_card_ml403_ac97cr_exit(void)
      platform_driver_unregister(&snd_ml403_ac97cr_driver);
  }

-module_init(alsa_card_ml403_ac97cr_init)
-module_exit(alsa_card_ml403_ac97cr_exit)
+module_init(alsa_card_ml403_ac97cr_init);
+module_exit(alsa_card_ml403_ac97cr_exit);
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
index 5b996f3..1b041c1 100644
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -285,5 +285,5 @@ static void __exit alsa_card_mpu401_exit(void)
      snd_mpu401_unregister_all();
  }

-module_init(alsa_card_mpu401_init)
-module_exit(alsa_card_mpu401_exit)
+module_init(alsa_card_mpu401_init);
+module_exit(alsa_card_mpu401_exit);
diff --git a/sound/drivers/mpu401/mpu401_uart.c 
b/sound/drivers/mpu401/mpu401_uart.c
index 2af0999..b655cc9 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -627,5 +627,5 @@ static void __exit alsa_mpu401_uart_exit(void)
  {
  }

-module_init(alsa_mpu401_uart_init)
-module_exit(alsa_mpu401_uart_exit)
+module_init(alsa_mpu401_uart_init);
+module_exit(alsa_mpu401_uart_exit);
diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index 5b89c08..26a5d52 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -786,5 +786,5 @@ static void __exit alsa_card_mtpav_exit(void)
      platform_driver_unregister(&snd_mtpav_driver);
  }

-module_init(alsa_card_mtpav_init)
-module_exit(alsa_card_mtpav_exit)
+module_init(alsa_card_mtpav_init);
+module_exit(alsa_card_mtpav_exit);
diff --git a/sound/drivers/opl3/opl3_lib.c b/sound/drivers/opl3/opl3_lib.c
index 7805823..0194596 100644
--- a/sound/drivers/opl3/opl3_lib.c
+++ b/sound/drivers/opl3/opl3_lib.c
@@ -556,5 +556,5 @@ static void __exit alsa_opl3_exit(void)
  {
  }

-module_init(alsa_opl3_init)
-module_exit(alsa_opl3_exit)
+module_init(alsa_opl3_init);
+module_exit(alsa_opl3_exit);
diff --git a/sound/drivers/opl3/opl3_seq.c b/sound/drivers/opl3/opl3_seq.c
index 2d33f53..3420d62 100644
--- a/sound/drivers/opl3/opl3_seq.c
+++ b/sound/drivers/opl3/opl3_seq.c
@@ -293,5 +293,5 @@ static void __exit alsa_opl3_seq_exit(void)
      snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_OPL3);
  }

-module_init(alsa_opl3_seq_init)
-module_exit(alsa_opl3_seq_exit)
+module_init(alsa_opl3_seq_init);
+module_exit(alsa_opl3_seq_exit);
diff --git a/sound/drivers/opl4/opl4_lib.c b/sound/drivers/opl4/opl4_lib.c
index 01997f2..c5563db 100644
--- a/sound/drivers/opl4/opl4_lib.c
+++ b/sound/drivers/opl4/opl4_lib.c
@@ -275,5 +275,5 @@ static void __exit alsa_opl4_exit(void)
  {
  }

-module_init(alsa_opl4_init)
-module_exit(alsa_opl4_exit)
+module_init(alsa_opl4_init);
+module_exit(alsa_opl4_exit);
diff --git a/sound/drivers/opl4/opl4_seq.c b/sound/drivers/opl4/opl4_seq.c
index 43d8a2b..9daa525 100644
--- a/sound/drivers/opl4/opl4_seq.c
+++ b/sound/drivers/opl4/opl4_seq.c
@@ -210,5 +210,5 @@ static void __exit alsa_opl4_synth_exit(void)
      snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_OPL4);
  }

-module_init(alsa_opl4_synth_init)
-module_exit(alsa_opl4_synth_exit)
+module_init(alsa_opl4_synth_init);
+module_exit(alsa_opl4_synth_exit);
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index d8aab9d..d73950e 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -1045,5 +1045,5 @@ static void __exit alsa_card_serial_exit(void)
      snd_serial_unregister_all();
  }

-module_init(alsa_card_serial_init)
-module_exit(alsa_card_serial_exit)
+module_init(alsa_card_serial_init);
+module_exit(alsa_card_serial_exit);
diff --git a/sound/drivers/virmidi.c b/sound/drivers/virmidi.c
index f79e361..2d1f498 100644
--- a/sound/drivers/virmidi.c
+++ b/sound/drivers/virmidi.c
@@ -191,5 +191,5 @@ static void __exit alsa_card_virmidi_exit(void)
      snd_virmidi_unregister_all();
  }

-module_init(alsa_card_virmidi_init)
-module_exit(alsa_card_virmidi_exit)
+module_init(alsa_card_virmidi_init);
+module_exit(alsa_card_virmidi_exit);
diff --git a/sound/drivers/vx/vx_core.c b/sound/drivers/vx/vx_core.c
index 14e3354..1bf353e 100644
--- a/sound/drivers/vx/vx_core.c
+++ b/sound/drivers/vx/vx_core.c
@@ -822,5 +822,5 @@ static void __exit alsa_vx_core_exit(void)
  {
  }

-module_init(alsa_vx_core_init)
-module_exit(alsa_vx_core_exit)
+module_init(alsa_vx_core_init);
+module_exit(alsa_vx_core_exit);
diff --git a/sound/i2c/cs8427.c b/sound/i2c/cs8427.c
index 020a5d5..73bb991 100644
--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -622,5 +622,5 @@ static void __exit alsa_cs8427_module_exit(void)
  {
  }

-module_init(alsa_cs8427_module_init)
-module_exit(alsa_cs8427_module_exit)
+module_init(alsa_cs8427_module_init);
+module_exit(alsa_cs8427_module_exit);
diff --git a/sound/i2c/i2c.c b/sound/i2c/i2c.c
index 5c0c77d..fad4bca 100644
--- a/sound/i2c/i2c.c
+++ b/sound/i2c/i2c.c
@@ -342,5 +342,5 @@ static void __exit alsa_i2c_exit(void)
  {
  }

-module_init(alsa_i2c_init)
-module_exit(alsa_i2c_exit)
+module_init(alsa_i2c_init);
+module_exit(alsa_i2c_exit);
diff --git a/sound/i2c/other/ak4xxx-adda.c b/sound/i2c/other/ak4xxx-adda.c
index ee47aba..0cea516 100644
--- a/sound/i2c/other/ak4xxx-adda.c
+++ b/sound/i2c/other/ak4xxx-adda.c
@@ -868,5 +868,5 @@ static void __exit alsa_akm4xxx_module_exit(void)
  {
  }

-module_init(alsa_akm4xxx_module_init)
-module_exit(alsa_akm4xxx_module_exit)
+module_init(alsa_akm4xxx_module_init);
+module_exit(alsa_akm4xxx_module_exit);
diff --git a/sound/i2c/other/tea575x-tuner.c 
b/sound/i2c/other/tea575x-tuner.c
index c13a178..16b5fdd 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -245,8 +245,8 @@ static void __exit alsa_tea575x_module_exit(void)
  {
  }

-module_init(alsa_tea575x_module_init)
-module_exit(alsa_tea575x_module_exit)
+module_init(alsa_tea575x_module_init);
+module_exit(alsa_tea575x_module_exit);

  EXPORT_SYMBOL(snd_tea575x_init);
  EXPORT_SYMBOL(snd_tea575x_exit);
diff --git a/sound/i2c/tea6330t.c b/sound/i2c/tea6330t.c
index 0e3a9f2..2be283e 100644
--- a/sound/i2c/tea6330t.c
+++ b/sound/i2c/tea6330t.c
@@ -381,5 +381,5 @@ static void __exit alsa_tea6330t_exit(void)
  {
  }

-module_init(alsa_tea6330t_init)
-module_exit(alsa_tea6330t_exit)
+module_init(alsa_tea6330t_init);
+module_exit(alsa_tea6330t_exit);
diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
index 7752424..5d161f7 100644
--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -285,5 +285,5 @@ static void __exit alsa_card_ad1816a_exit(void)
      pnp_unregister_card_driver(&ad1816a_pnpc_driver);
  }

-module_init(alsa_card_ad1816a_init)
-module_exit(alsa_card_ad1816a_exit)
+module_init(alsa_card_ad1816a_init);
+module_exit(alsa_card_ad1816a_exit);
diff --git a/sound/isa/als100.c b/sound/isa/als100.c
index f1ce30f..6deb85e 100644
--- a/sound/isa/als100.c
+++ b/sound/isa/als100.c
@@ -323,5 +323,5 @@ static void __exit alsa_card_als100_exit(void)
      pnp_unregister_card_driver(&als100_pnpc_driver);
  }

-module_init(alsa_card_als100_init)
-module_exit(alsa_card_als100_exit)
+module_init(alsa_card_als100_init);
+module_exit(alsa_card_als100_exit);
diff --git a/sound/isa/azt2320.c b/sound/isa/azt2320.c
index 3e74d1a..4a700b1 100644
--- a/sound/isa/azt2320.c
+++ b/sound/isa/azt2320.c
@@ -350,5 +350,5 @@ static void __exit alsa_card_azt2320_exit(void)
      pnp_unregister_card_driver(&azt2320_pnpc_driver);
  }

-module_init(alsa_card_azt2320_init)
-module_exit(alsa_card_azt2320_exit)
+module_init(alsa_card_azt2320_init);
+module_exit(alsa_card_azt2320_exit);
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index e49aec7..071c5d3 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -707,5 +707,5 @@ static void __exit alsa_card_cmi8330_exit(void)
          isa_unregister_driver(&snd_cmi8330_driver);
  }

-module_init(alsa_card_cmi8330_init)
-module_exit(alsa_card_cmi8330_exit)
+module_init(alsa_card_cmi8330_init);
+module_exit(alsa_card_cmi8330_exit);
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index 019c940..966442e 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -746,5 +746,5 @@ static void __exit alsa_card_cs423x_exit(void)
          isa_unregister_driver(&cs423x_isa_driver);
  }

-module_init(alsa_card_cs423x_init)
-module_exit(alsa_card_cs423x_exit)
+module_init(alsa_card_cs423x_init);
+module_exit(alsa_card_cs423x_exit);
diff --git a/sound/isa/cs423x/cs4236_lib.c b/sound/isa/cs423x/cs4236_lib.c
index 6a85fdc..ccc13bf 100644
--- a/sound/isa/cs423x/cs4236_lib.c
+++ b/sound/isa/cs423x/cs4236_lib.c
@@ -1033,5 +1033,5 @@ static void __exit alsa_cs4236_exit(void)
  {
  }

-module_init(alsa_cs4236_init)
-module_exit(alsa_cs4236_exit)
+module_init(alsa_cs4236_init);
+module_exit(alsa_cs4236_exit);
diff --git a/sound/isa/dt019x.c b/sound/isa/dt019x.c
index a0242c3..55ce72c 100644
--- a/sound/isa/dt019x.c
+++ b/sound/isa/dt019x.c
@@ -316,5 +316,5 @@ static void __exit alsa_card_dt019x_exit(void)
      pnp_unregister_card_driver(&dt019x_pnpc_driver);
  }

-module_init(alsa_card_dt019x_init)
-module_exit(alsa_card_dt019x_exit)
+module_init(alsa_card_dt019x_init);
+module_exit(alsa_card_dt019x_exit);
diff --git a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
index 4fbb508..e08dca3 100644
--- a/sound/isa/es1688/es1688_lib.c
+++ b/sound/isa/es1688/es1688_lib.c
@@ -1049,5 +1049,5 @@ static void __exit alsa_es1688_exit(void)
  {
  }

-module_init(alsa_es1688_init)
-module_exit(alsa_es1688_exit)
+module_init(alsa_es1688_init);
+module_exit(alsa_es1688_exit);
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 90498e4..03e0e20 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -2448,5 +2448,5 @@ static void __exit alsa_card_es18xx_exit(void)
          isa_unregister_driver(&snd_es18xx_isa_driver);
  }

-module_init(alsa_card_es18xx_init)
-module_exit(alsa_card_es18xx_exit)
+module_init(alsa_card_es18xx_init);
+module_exit(alsa_card_es18xx_exit);
diff --git a/sound/isa/gus/gus_main.c b/sound/isa/gus/gus_main.c
index 12eb98f..ec1ea9c 100644
--- a/sound/isa/gus/gus_main.c
+++ b/sound/isa/gus/gus_main.c
@@ -478,5 +478,5 @@ static void __exit alsa_gus_exit(void)
  {
  }

-module_init(alsa_gus_init)
-module_exit(alsa_gus_exit)
+module_init(alsa_gus_init);
+module_exit(alsa_gus_exit);
diff --git a/sound/isa/gus/gusmax.c b/sound/isa/gus/gusmax.c
index f94c197..1f2f039 100644
--- a/sound/isa/gus/gusmax.c
+++ b/sound/isa/gus/gusmax.c
@@ -383,5 +383,5 @@ static void __exit alsa_card_gusmax_exit(void)
      isa_unregister_driver(&snd_gusmax_driver);
  }

-module_init(alsa_card_gusmax_init)
-module_exit(alsa_card_gusmax_exit)
+module_init(alsa_card_gusmax_init);
+module_exit(alsa_card_gusmax_exit);
diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
index 5faecfb..c54c763 100644
--- a/sound/isa/gus/interwave.c
+++ b/sound/isa/gus/interwave.c
@@ -940,5 +940,5 @@ static void __exit alsa_card_interwave_exit(void)
          isa_unregister_driver(&snd_interwave_driver);
  }

-module_init(alsa_card_interwave_init)
-module_exit(alsa_card_interwave_exit)
+module_init(alsa_card_interwave_init);
+module_exit(alsa_card_interwave_exit);
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index 58c972b..e8c3a12 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -953,5 +953,5 @@ static void __exit alsa_card_opl3sa2_exit(void)
          isa_unregister_driver(&snd_opl3sa2_isa_driver);
  }

-module_init(alsa_card_opl3sa2_init)
-module_exit(alsa_card_opl3sa2_exit)
+module_init(alsa_card_opl3sa2_init);
+module_exit(alsa_card_opl3sa2_exit);
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 440755c..7e9c60d 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -1440,5 +1440,5 @@ static void __exit alsa_card_miro_exit(void)
      isa_unregister_driver(&snd_miro_driver);
  }

-module_init(alsa_card_miro_init)
-module_exit(alsa_card_miro_exit)
+module_init(alsa_card_miro_init);
+module_exit(alsa_card_miro_exit);
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c 
b/sound/isa/opti9xx/opti92x-ad1848.c
index 19706b0..a42cc0f 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -1031,5 +1031,5 @@ static void __exit alsa_card_opti9xx_exit(void)
  #endif
  }

-module_init(alsa_card_opti9xx_init)
-module_exit(alsa_card_opti9xx_exit)
+module_init(alsa_card_opti9xx_init);
+module_exit(alsa_card_opti9xx_exit);
diff --git a/sound/isa/sb/emu8000_synth.c b/sound/isa/sb/emu8000_synth.c
index 0c7905c..c301809 100644
--- a/sound/isa/sb/emu8000_synth.c
+++ b/sound/isa/sb/emu8000_synth.c
@@ -131,5 +131,5 @@ static void __exit alsa_emu8000_exit(void)
      snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_EMU8000);
  }

-module_init(alsa_emu8000_init)
-module_exit(alsa_emu8000_exit)
+module_init(alsa_emu8000_init);
+module_exit(alsa_emu8000_exit);
diff --git a/sound/isa/sb/es968.c b/sound/isa/sb/es968.c
index c8c8e21..b8a0a07 100644
--- a/sound/isa/sb/es968.c
+++ b/sound/isa/sb/es968.c
@@ -243,5 +243,5 @@ static void __exit alsa_card_es968_exit(void)
      pnp_unregister_card_driver(&es968_pnpc_driver);
  }

-module_init(alsa_card_es968_init)
-module_exit(alsa_card_es968_exit)
+module_init(alsa_card_es968_init);
+module_exit(alsa_card_es968_exit);
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
index 2c201f7..bbeefba 100644
--- a/sound/isa/sb/sb16.c
+++ b/sound/isa/sb/sb16.c
@@ -691,5 +691,5 @@ static void __exit alsa_card_sb16_exit(void)
          isa_unregister_driver(&snd_sb16_isa_driver);
  }

-module_init(alsa_card_sb16_init)
-module_exit(alsa_card_sb16_exit)
+module_init(alsa_card_sb16_init);
+module_exit(alsa_card_sb16_exit);
diff --git a/sound/isa/sb/sb16_csp.c b/sound/isa/sb/sb16_csp.c
index 49037d0..f39aa46 100644
--- a/sound/isa/sb/sb16_csp.c
+++ b/sound/isa/sb/sb16_csp.c
@@ -1196,5 +1196,5 @@ static void __exit alsa_sb_csp_exit(void)
  {
  }

-module_init(alsa_sb_csp_init)
-module_exit(alsa_sb_csp_exit)
+module_init(alsa_sb_csp_init);
+module_exit(alsa_sb_csp_exit);
diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index 2a6cc1c..ced1a0d 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -920,5 +920,5 @@ static void __exit alsa_sb16_exit(void)
  {
  }

-module_init(alsa_sb16_init)
-module_exit(alsa_sb16_exit)
+module_init(alsa_sb16_init);
+module_exit(alsa_sb16_exit);
diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index ea06877..120944f 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -265,5 +265,5 @@ static void __exit alsa_card_sb8_exit(void)
      isa_unregister_driver(&snd_sb8_driver);
  }

-module_init(alsa_card_sb8_init)
-module_exit(alsa_card_sb8_exit)
+module_init(alsa_card_sb8_init);
+module_exit(alsa_card_sb8_exit);
diff --git a/sound/isa/sb/sb8_main.c b/sound/isa/sb/sb8_main.c
index 658d557..a69cdd5 100644
--- a/sound/isa/sb/sb8_main.c
+++ b/sound/isa/sb/sb8_main.c
@@ -555,5 +555,5 @@ static void __exit alsa_sb8_exit(void)
  {
  }

-module_init(alsa_sb8_init)
-module_exit(alsa_sb8_exit)
+module_init(alsa_sb8_init);
+module_exit(alsa_sb8_exit);
diff --git a/sound/isa/sb/sb_common.c b/sound/isa/sb/sb_common.c
index 27a6515..a68a64e 100644
--- a/sound/isa/sb/sb_common.c
+++ b/sound/isa/sb/sb_common.c
@@ -316,5 +316,5 @@ static void __exit alsa_sb_common_exit(void)
  {
  }

-module_init(alsa_sb_common_init)
-module_exit(alsa_sb_common_exit)
+module_init(alsa_sb_common_init);
+module_exit(alsa_sb_common_exit);
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index ca35924..e574173 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -651,5 +651,5 @@ static void __exit alsa_card_sc6000_exit(void)
      isa_unregister_driver(&snd_sc6000_driver);
  }

-module_init(alsa_card_sc6000_init)
-module_exit(alsa_card_sc6000_exit)
+module_init(alsa_card_sc6000_init);
+module_exit(alsa_card_sc6000_exit);
diff --git a/sound/isa/sgalaxy.c b/sound/isa/sgalaxy.c
index 2c7503b..98fb4a2 100644
--- a/sound/isa/sgalaxy.c
+++ b/sound/isa/sgalaxy.c
@@ -365,5 +365,5 @@ static void __exit alsa_card_sgalaxy_exit(void)
      isa_unregister_driver(&snd_sgalaxy_driver);
  }

-module_init(alsa_card_sgalaxy_init)
-module_exit(alsa_card_sgalaxy_exit)
+module_init(alsa_card_sgalaxy_init);
+module_exit(alsa_card_sgalaxy_exit);
diff --git a/sound/isa/wavefront/wavefront.c 
b/sound/isa/wavefront/wavefront.c
index 4c095bc..030fbc7 100644
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -683,5 +683,5 @@ static void __exit alsa_card_wavefront_exit(void)
          isa_unregister_driver(&snd_wavefront_driver);
  }

-module_init(alsa_card_wavefront_init)
-module_exit(alsa_card_wavefront_exit)
+module_init(alsa_card_wavefront_init);
+module_exit(alsa_card_wavefront_exit);
diff --git a/sound/mips/sgio2audio.c b/sound/mips/sgio2audio.c
index 4c63504..2d15dcd 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -1002,5 +1002,5 @@ static void __exit alsa_card_sgio2audio_exit(void)
      platform_driver_unregister(&sgio2audio_driver);
  }

-module_init(alsa_card_sgio2audio_init)
-module_exit(alsa_card_sgio2audio_exit)
+module_init(alsa_card_sgio2audio_init);
+module_exit(alsa_card_sgio2audio_exit);
diff --git a/sound/pci/ac97/ac97_codec.c b/sound/pci/ac97/ac97_codec.c
index e2b843b..885d5fa 100644
--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -2899,5 +2899,5 @@ static void __exit alsa_ac97_exit(void)
  {
  }

-module_init(alsa_ac97_init)
-module_exit(alsa_ac97_exit)
+module_init(alsa_ac97_init);
+module_exit(alsa_ac97_exit);
diff --git a/sound/pci/ali5451/ali5451.c b/sound/pci/ali5451/ali5451.c
index 1a0fd65..b066a6f 100644
--- a/sound/pci/ali5451/ali5451.c
+++ b/sound/pci/ali5451/ali5451.c
@@ -2374,5 +2374,5 @@ static void __exit alsa_card_ali_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_ali_init)
-module_exit(alsa_card_ali_exit)
+module_init(alsa_card_ali_init);
+module_exit(alsa_card_ali_exit);
diff --git a/sound/pci/als300.c b/sound/pci/als300.c
index 8df6824..327e22f 100644
--- a/sound/pci/als300.c
+++ b/sound/pci/als300.c
@@ -866,5 +866,5 @@ static void __exit alsa_card_als300_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_als300_init)
-module_exit(alsa_card_als300_exit)
+module_init(alsa_card_als300_init);
+module_exit(alsa_card_als300_exit);
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index ba57005..fc5ffc7 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -1056,5 +1056,5 @@ static void __exit alsa_card_als4000_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_als4000_init)
-module_exit(alsa_card_als4000_exit)
+module_init(alsa_card_als4000_init);
+module_exit(alsa_card_als4000_exit);
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 226fe82..4dda8c9 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1715,5 +1715,5 @@ static void __exit alsa_card_atiixp_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_atiixp_init)
-module_exit(alsa_card_atiixp_exit)
+module_init(alsa_card_atiixp_init);
+module_exit(alsa_card_atiixp_exit);
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 0e6e5cc..8404e40 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1353,5 +1353,5 @@ static void __exit alsa_card_atiixp_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_atiixp_init)
-module_exit(alsa_card_atiixp_exit)
+module_init(alsa_card_atiixp_init);
+module_exit(alsa_card_atiixp_exit);
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index a36d4d1..681b24b 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -393,5 +393,5 @@ static void __exit alsa_card_vortex_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_vortex_init)
-module_exit(alsa_card_vortex_exit)
+module_init(alsa_card_vortex_init);
+module_exit(alsa_card_vortex_exit);
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 333007c..dce2917 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -2408,5 +2408,5 @@ alsa_card_azf3328_exit(void)
      snd_azf3328_dbgcallleave();
  }

-module_init(alsa_card_azf3328_init)
-module_exit(alsa_card_azf3328_exit)
+module_init(alsa_card_azf3328_init);
+module_exit(alsa_card_azf3328_exit);
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 1aa1c04..6d7980c 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -983,5 +983,5 @@ static void __exit alsa_card_bt87x_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_bt87x_init)
-module_exit(alsa_card_bt87x_exit)
+module_init(alsa_card_bt87x_init);
+module_exit(alsa_card_bt87x_exit);
diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 0e62205..1bbb6eb 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1847,5 +1847,5 @@ static void __exit alsa_card_ca0106_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_ca0106_init)
-module_exit(alsa_card_ca0106_exit)
+module_init(alsa_card_ca0106_init);
+module_exit(alsa_card_ca0106_exit);
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 1a74ca6..ebf427f 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -3417,5 +3417,5 @@ static void __exit alsa_card_cmipci_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_cmipci_init)
-module_exit(alsa_card_cmipci_exit)
+module_init(alsa_card_cmipci_init);
+module_exit(alsa_card_cmipci_exit);
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 192e784..78a445e 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -2113,5 +2113,5 @@ static void __exit alsa_card_cs4281_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_cs4281_init)
-module_exit(alsa_card_cs4281_exit)
+module_init(alsa_card_cs4281_init);
+module_exit(alsa_card_cs4281_exit);
diff --git a/sound/pci/cs46xx/cs46xx.c b/sound/pci/cs46xx/cs46xx.c
index e876b32..61f351b 100644
--- a/sound/pci/cs46xx/cs46xx.c
+++ b/sound/pci/cs46xx/cs46xx.c
@@ -182,5 +182,5 @@ static void __exit alsa_card_cs46xx_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_cs46xx_init)
-module_exit(alsa_card_cs46xx_exit)
+module_init(alsa_card_cs46xx_init);
+module_exit(alsa_card_cs46xx_exit);
diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
index 6dea5b5..8330ccc 100644
--- a/sound/pci/cs5530.c
+++ b/sound/pci/cs5530.c
@@ -300,6 +300,6 @@ static void __exit alsa_card_cs5530_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_cs5530_init)
-module_exit(alsa_card_cs5530_exit)
+module_init(alsa_card_cs5530_init);
+module_exit(alsa_card_cs5530_exit);

diff --git a/sound/pci/cs5535audio/cs5535audio.c 
b/sound/pci/cs5535audio/cs5535audio.c
index 826e6de..5475e04 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -414,8 +414,8 @@ static void __exit alsa_card_cs5535audio_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_cs5535audio_init)
-module_exit(alsa_card_cs5535audio_exit)
+module_init(alsa_card_cs5535audio_init);
+module_exit(alsa_card_cs5535audio_exit);

  MODULE_AUTHOR("Jaya Kumar");
  MODULE_LICENSE("GPL");
diff --git a/sound/pci/echoaudio/echoaudio.c 
b/sound/pci/echoaudio/echoaudio.c
index 8dbc5c4..cc16b2a 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -2177,5 +2177,5 @@ static void __exit alsa_card_echo_exit(void)
  }


-module_init(alsa_card_echo_init)
-module_exit(alsa_card_echo_exit)
+module_init(alsa_card_echo_init);
+module_exit(alsa_card_echo_exit);
diff --git a/sound/pci/emu10k1/emu10k1.c b/sound/pci/emu10k1/emu10k1.c
index 8354c1a..7440c11 100644
--- a/sound/pci/emu10k1/emu10k1.c
+++ b/sound/pci/emu10k1/emu10k1.c
@@ -280,5 +280,5 @@ static void __exit alsa_card_emu10k1_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_emu10k1_init)
-module_exit(alsa_card_emu10k1_exit)
+module_init(alsa_card_emu10k1_init);
+module_exit(alsa_card_emu10k1_exit);
diff --git a/sound/pci/emu10k1/emu10k1_synth.c 
b/sound/pci/emu10k1/emu10k1_synth.c
index ad7b714..721c1df 100644
--- a/sound/pci/emu10k1/emu10k1_synth.c
+++ b/sound/pci/emu10k1/emu10k1_synth.c
@@ -119,5 +119,5 @@ static void __exit alsa_emu10k1_synth_exit(void)
      snd_seq_device_unregister_driver(SNDRV_SEQ_DEV_ID_EMU10K1_SYNTH);
  }

-module_init(alsa_emu10k1_synth_init)
-module_exit(alsa_emu10k1_synth_exit)
+module_init(alsa_emu10k1_synth_init);
+module_exit(alsa_emu10k1_synth_exit);
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 5ff4dbb..ebb3b39 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -1633,5 +1633,5 @@ static void __exit alsa_card_emu10k1x_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_emu10k1x_init)
-module_exit(alsa_card_emu10k1x_exit)
+module_init(alsa_card_emu10k1x_init);
+module_exit(alsa_card_emu10k1x_exit);
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 9bf9536..773a8d4 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -2493,5 +2493,5 @@ static void __exit alsa_card_ens137x_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_ens137x_init)
-module_exit(alsa_card_ens137x_exit)
+module_init(alsa_card_ens137x_init);
+module_exit(alsa_card_ens137x_exit);
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 4cd9a1f..ef65238 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1895,5 +1895,5 @@ static void __exit alsa_card_es1938_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_es1938_init)
-module_exit(alsa_card_es1938_exit)
+module_init(alsa_card_es1938_init);
+module_exit(alsa_card_es1938_exit);
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index e9c3794..a253ec2 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2758,5 +2758,5 @@ static void __exit alsa_card_es1968_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_es1968_init)
-module_exit(alsa_card_es1968_exit)
+module_init(alsa_card_es1968_init);
+module_exit(alsa_card_es1968_exit);
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index c129f9e..6d5b67d 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1604,5 +1604,5 @@ static void __exit alsa_card_fm801_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_fm801_init)
-module_exit(alsa_card_fm801_exit)
+module_init(alsa_card_fm801_init);
+module_exit(alsa_card_fm801_exit);
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index f04de11..37c9551 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2483,5 +2483,5 @@ static void __exit alsa_card_azx_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_azx_init)
-module_exit(alsa_card_azx_exit)
+module_init(alsa_card_azx_init);
+module_exit(alsa_card_azx_exit);
diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index 26247cf..c801a19 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -4347,5 +4347,5 @@ static void __exit patch_analog_exit(void)
      snd_hda_delete_codec_preset(&analog_list);
  }

-module_init(patch_analog_init)
-module_exit(patch_analog_exit)
+module_init(patch_analog_init);
+module_exit(patch_analog_exit);
diff --git a/sound/pci/hda/patch_atihdmi.c b/sound/pci/hda/patch_atihdmi.c
index 233e477..f2e809f 100644
--- a/sound/pci/hda/patch_atihdmi.c
+++ b/sound/pci/hda/patch_atihdmi.c
@@ -221,5 +221,5 @@ static void __exit patch_atihdmi_exit(void)
      snd_hda_delete_codec_preset(&atihdmi_list);
  }

-module_init(patch_atihdmi_init)
-module_exit(patch_atihdmi_exit)
+module_init(patch_atihdmi_init);
+module_exit(patch_atihdmi_exit);
diff --git a/sound/pci/hda/patch_cmedia.c b/sound/pci/hda/patch_cmedia.c
index f3ebe83..cb30329 100644
--- a/sound/pci/hda/patch_cmedia.c
+++ b/sound/pci/hda/patch_cmedia.c
@@ -762,5 +762,5 @@ static void __exit patch_cmedia_exit(void)
      snd_hda_delete_codec_preset(&cmedia_list);
  }

-module_init(patch_cmedia_init)
-module_exit(patch_cmedia_exit)
+module_init(patch_cmedia_init);
+module_exit(patch_cmedia_exit);
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index b20e1ce..55423cc 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1802,5 +1802,5 @@ static void __exit patch_conexant_exit(void)
      snd_hda_delete_codec_preset(&conexant_list);
  }

-module_init(patch_conexant_init)
-module_exit(patch_conexant_exit)
+module_init(patch_conexant_init);
+module_exit(patch_conexant_exit);
diff --git a/sound/pci/hda/patch_intelhdmi.c 
b/sound/pci/hda/patch_intelhdmi.c
index 3564f4e..1466458 100644
--- a/sound/pci/hda/patch_intelhdmi.c
+++ b/sound/pci/hda/patch_intelhdmi.c
@@ -707,5 +707,5 @@ static void __exit patch_intelhdmi_exit(void)
      snd_hda_delete_codec_preset(&intel_list);
  }

-module_init(patch_intelhdmi_init)
-module_exit(patch_intelhdmi_exit)
+module_init(patch_intelhdmi_init);
+module_exit(patch_intelhdmi_exit);
diff --git a/sound/pci/hda/patch_nvhdmi.c b/sound/pci/hda/patch_nvhdmi.c
index 0270fda..5c13efd 100644
--- a/sound/pci/hda/patch_nvhdmi.c
+++ b/sound/pci/hda/patch_nvhdmi.c
@@ -187,5 +187,5 @@ static void __exit patch_nvhdmi_exit(void)
      snd_hda_delete_codec_preset(&nvhdmi_list);
  }

-module_init(patch_nvhdmi_init)
-module_exit(patch_nvhdmi_exit)
+module_init(patch_nvhdmi_init);
+module_exit(patch_nvhdmi_exit);
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0bd4e6b..cf28975 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -16665,5 +16665,5 @@ static void __exit patch_realtek_exit(void)
      snd_hda_delete_codec_preset(&realtek_list);
  }

-module_init(patch_realtek_init)
-module_exit(patch_realtek_exit)
+module_init(patch_realtek_init);
+module_exit(patch_realtek_exit);
diff --git a/sound/pci/hda/patch_si3054.c b/sound/pci/hda/patch_si3054.c
index 43b436c..e1e507c 100644
--- a/sound/pci/hda/patch_si3054.c
+++ b/sound/pci/hda/patch_si3054.c
@@ -330,5 +330,5 @@ static void __exit patch_si3054_exit(void)
      snd_hda_delete_codec_preset(&si3054_list);
  }

-module_init(patch_si3054_init)
-module_exit(patch_si3054_exit)
+module_init(patch_si3054_init);
+module_exit(patch_si3054_exit);
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 35b83dc..e1fd48b 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -5557,5 +5557,5 @@ static void __exit patch_sigmatel_exit(void)
      snd_hda_delete_codec_preset(&sigmatel_list);
  }

-module_init(patch_sigmatel_init)
-module_exit(patch_sigmatel_exit)
+module_init(patch_sigmatel_init);
+module_exit(patch_sigmatel_exit);
diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index c761394..0cbe18f 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -3340,5 +3340,5 @@ static void __exit patch_via_exit(void)
      snd_hda_delete_codec_preset(&via_list);
  }

-module_init(patch_via_init)
-module_exit(patch_via_exit)
+module_init(patch_via_init);
+module_exit(patch_via_exit);
diff --git a/sound/pci/ice1712/ak4xxx.c b/sound/pci/ice1712/ak4xxx.c
index 03391da..9b88e36 100644
--- a/sound/pci/ice1712/ak4xxx.c
+++ b/sound/pci/ice1712/ak4xxx.c
@@ -186,8 +186,8 @@ static void __exit 
alsa_ice1712_akm4xxx_module_exit(void)
  {
  }

-module_init(alsa_ice1712_akm4xxx_module_init)
-module_exit(alsa_ice1712_akm4xxx_module_exit)
+module_init(alsa_ice1712_akm4xxx_module_init);
+module_exit(alsa_ice1712_akm4xxx_module_exit);

  EXPORT_SYMBOL(snd_ice1712_akm4xxx_init);
  EXPORT_SYMBOL(snd_ice1712_akm4xxx_free);
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 58d7cda..9eb23e6 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2797,5 +2797,5 @@ static void __exit alsa_card_ice1712_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_ice1712_init)
-module_exit(alsa_card_ice1712_exit)
+module_init(alsa_card_ice1712_init);
+module_exit(alsa_card_ice1712_exit);
diff --git a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
index 0dfa054..e34c59c 100644
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2621,5 +2621,5 @@ static void __exit alsa_card_ice1724_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_ice1724_init)
-module_exit(alsa_card_ice1724_exit)
+module_init(alsa_card_ice1724_init);
+module_exit(alsa_card_ice1724_exit);
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 19d3391..74509b6 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -3161,5 +3161,5 @@ static void __exit alsa_card_intel8x0_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_intel8x0_init)
-module_exit(alsa_card_intel8x0_exit)
+module_init(alsa_card_intel8x0_init);
+module_exit(alsa_card_intel8x0_exit);
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index 93449e4..a3a5741 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -1339,5 +1339,5 @@ static void __exit alsa_card_intel8x0m_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_intel8x0m_init)
-module_exit(alsa_card_intel8x0m_exit)
+module_init(alsa_card_intel8x0m_init);
+module_exit(alsa_card_intel8x0m_exit);
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index 5f8006b..55b54ab 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -2491,5 +2491,5 @@ static void __exit alsa_card_korg1212_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_korg1212_init)
-module_exit(alsa_card_korg1212_exit)
+module_init(alsa_card_korg1212_init);
+module_exit(alsa_card_korg1212_exit);
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 59bbaf8..0a16135 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2769,5 +2769,5 @@ static void __exit alsa_card_m3_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_m3_init)
-module_exit(alsa_card_m3_exit)
+module_init(alsa_card_m3_init);
+module_exit(alsa_card_m3_exit);
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index f23a735..7029f8e 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1454,5 +1454,5 @@ static void __exit alsa_card_mixart_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_mixart_init)
-module_exit(alsa_card_mixart_exit)
+module_init(alsa_card_mixart_init);
+module_exit(alsa_card_mixart_exit);
diff --git a/sound/pci/nm256/nm256.c b/sound/pci/nm256/nm256.c
index 50c9f8a..7f3e94e 100644
--- a/sound/pci/nm256/nm256.c
+++ b/sound/pci/nm256/nm256.c
@@ -1764,5 +1764,5 @@ static void __exit alsa_card_nm256_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_nm256_init)
-module_exit(alsa_card_nm256_exit)
+module_init(alsa_card_nm256_init);
+module_exit(alsa_card_nm256_exit);
diff --git a/sound/pci/oxygen/hifier.c b/sound/pci/oxygen/hifier.c
index 1ab833f..51c11fe 100644
--- a/sound/pci/oxygen/hifier.c
+++ b/sound/pci/oxygen/hifier.c
@@ -212,5 +212,5 @@ static void __exit alsa_card_hifier_exit(void)
      pci_unregister_driver(&hifier_driver);
  }

-module_init(alsa_card_hifier_init)
-module_exit(alsa_card_hifier_exit)
+module_init(alsa_card_hifier_init);
+module_exit(alsa_card_hifier_exit);
diff --git a/sound/pci/oxygen/oxygen.c b/sound/pci/oxygen/oxygen.c
index de999c6..b057776 100644
--- a/sound/pci/oxygen/oxygen.c
+++ b/sound/pci/oxygen/oxygen.c
@@ -381,5 +381,5 @@ static void __exit alsa_card_oxygen_exit(void)
      pci_unregister_driver(&oxygen_driver);
  }

-module_init(alsa_card_oxygen_init)
-module_exit(alsa_card_oxygen_exit)
+module_init(alsa_card_oxygen_init);
+module_exit(alsa_card_oxygen_exit);
diff --git a/sound/pci/oxygen/virtuoso.c b/sound/pci/oxygen/virtuoso.c
index 98c6a8c..7e8ffde 100644
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -953,5 +953,5 @@ static void __exit alsa_card_xonar_exit(void)
      pci_unregister_driver(&xonar_driver);
  }

-module_init(alsa_card_xonar_init)
-module_exit(alsa_card_xonar_exit)
+module_init(alsa_card_xonar_init);
+module_exit(alsa_card_xonar_exit);
diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index 27cf2c2..5d41c23 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -1583,5 +1583,5 @@ static void __exit pcxhr_module_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(pcxhr_module_init)
-module_exit(pcxhr_module_exit)
+module_init(pcxhr_module_init);
+module_exit(pcxhr_module_exit);
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index e7ef3a1..50da54f 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -2003,5 +2003,5 @@ static void __exit alsa_card_rme32_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_rme32_init)
-module_exit(alsa_card_rme32_exit)
+module_init(alsa_card_rme32_init);
+module_exit(alsa_card_rme32_exit);
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 3fdd488..907fe20 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -2416,5 +2416,5 @@ static void __exit alsa_card_rme96_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_rme96_init)
-module_exit(alsa_card_rme96_exit)
+module_init(alsa_card_rme96_init);
+module_exit(alsa_card_rme96_exit);
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 44d0c15..4d76942 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -5208,5 +5208,5 @@ static void __exit alsa_card_hdsp_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_hdsp_init)
-module_exit(alsa_card_hdsp_exit)
+module_init(alsa_card_hdsp_init);
+module_exit(alsa_card_hdsp_exit);
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 71231cf..2f044e0 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -4562,5 +4562,5 @@ static void __exit alsa_card_hdspm_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_hdspm_init)
-module_exit(alsa_card_hdspm_exit)
+module_init(alsa_card_hdspm_init);
+module_exit(alsa_card_hdspm_exit);
diff --git a/sound/pci/rme9652/rme9652.c b/sound/pci/rme9652/rme9652.c
index 2570907..41aa86b 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -2649,5 +2649,5 @@ static void __exit alsa_card_hammerfall_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_hammerfall_init)
-module_exit(alsa_card_hammerfall_exit)
+module_init(alsa_card_hammerfall_init);
+module_exit(alsa_card_hammerfall_exit);
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index cd408b8..9dfe1ea 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1511,5 +1511,5 @@ static void __exit alsa_card_sonicvibes_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_sonicvibes_init)
-module_exit(alsa_card_sonicvibes_exit)
+module_init(alsa_card_sonicvibes_init);
+module_exit(alsa_card_sonicvibes_exit);
diff --git a/sound/pci/trident/trident.c b/sound/pci/trident/trident.c
index d94b16f..b9ffcda 100644
--- a/sound/pci/trident/trident.c
+++ b/sound/pci/trident/trident.c
@@ -192,5 +192,5 @@ static void __exit alsa_card_trident_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_trident_init)
-module_exit(alsa_card_trident_exit)
+module_init(alsa_card_trident_init);
+module_exit(alsa_card_trident_exit);
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 1aafe95..7e4ff49 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2559,5 +2559,5 @@ static void __exit alsa_card_via82xx_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_via82xx_init)
-module_exit(alsa_card_via82xx_exit)
+module_init(alsa_card_via82xx_init);
+module_exit(alsa_card_via82xx_exit);
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 5bd79d2..9590e91 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1241,5 +1241,5 @@ static void __exit alsa_card_via82xx_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_via82xx_init)
-module_exit(alsa_card_via82xx_exit)
+module_init(alsa_card_via82xx_init);
+module_exit(alsa_card_via82xx_exit);
diff --git a/sound/pci/vx222/vx222.c b/sound/pci/vx222/vx222.c
index acc352f..6b64de4 100644
--- a/sound/pci/vx222/vx222.c
+++ b/sound/pci/vx222/vx222.c
@@ -310,5 +310,5 @@ static void __exit alsa_card_vx222_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_vx222_init)
-module_exit(alsa_card_vx222_exit)
+module_init(alsa_card_vx222_init);
+module_exit(alsa_card_vx222_exit);
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 2631a55..e57937c 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -365,5 +365,5 @@ static void __exit alsa_card_ymfpci_exit(void)
      pci_unregister_driver(&driver);
  }

-module_init(alsa_card_ymfpci_init)
-module_exit(alsa_card_ymfpci_exit)
+module_init(alsa_card_ymfpci_init);
+module_exit(alsa_card_ymfpci_exit);
diff --git a/sound/ppc/powermac.c b/sound/ppc/powermac.c
index c936225..469e688 100644
--- a/sound/ppc/powermac.c
+++ b/sound/ppc/powermac.c
@@ -191,5 +191,5 @@ static void __exit alsa_card_pmac_exit(void)
      platform_driver_unregister(&snd_pmac_driver);
  }

-module_init(alsa_card_pmac_init)
-module_exit(alsa_card_pmac_exit)
+module_init(alsa_card_pmac_init);
+module_exit(alsa_card_pmac_exit);
diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index f16a3fc..f4a382e 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -187,5 +187,5 @@ static void __exit alsa_emux_exit(void)
  {
  }

-module_init(alsa_emux_init)
-module_exit(alsa_emux_exit)
+module_init(alsa_emux_init);
+module_exit(alsa_emux_exit);
diff --git a/sound/synth/util_mem.c b/sound/synth/util_mem.c
index c85522e..65a9fa9 100644
--- a/sound/synth/util_mem.c
+++ b/sound/synth/util_mem.c
@@ -206,5 +206,5 @@ static void __exit alsa_util_mem_exit(void)
  {
  }

-module_init(alsa_util_mem_init)
-module_exit(alsa_util_mem_exit)
+module_init(alsa_util_mem_init);
+module_exit(alsa_util_mem_exit);
diff --git a/sound/usb/caiaq/caiaq-device.c b/sound/usb/caiaq/caiaq-device.c
index b143ef7..29adbdc 100644
--- a/sound/usb/caiaq/caiaq-device.c
+++ b/sound/usb/caiaq/caiaq-device.c
@@ -501,6 +501,6 @@ static void __exit snd_module_exit(void)
      usb_deregister(&snd_usb_driver);
  }

-module_init(snd_module_init)
-module_exit(snd_module_exit)
+module_init(snd_module_init);
+module_exit(snd_module_exit);

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index c2515b6..b922b37 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -689,5 +689,5 @@ static void __exit snd_us122l_module_exit(void)
      usb_deregister(&snd_us122l_usb_driver);
  }

-module_init(snd_us122l_module_init)
-module_exit(snd_us122l_module_exit)
+module_init(snd_us122l_module_init);
+module_exit(snd_us122l_module_exit);
diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index e5981a6..59bf87d 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -456,5 +456,5 @@ static void __exit snd_usX2Y_module_exit(void)
      usb_deregister(&snd_usX2Y_usb_driver);
  }

-module_init(snd_usX2Y_module_init)
-module_exit(snd_usX2Y_module_exit)
+module_init(snd_usX2Y_module_init);
+module_exit(snd_usX2Y_module_exit);
-- 
1.5.5.3


