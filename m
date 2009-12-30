Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZL3FqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZL3FqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 00:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZL3FqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 00:46:18 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:39115 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZL3FqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 00:46:17 -0500
Message-ID: <4B3AE891.5010508@oracle.com>
Date: Wed, 30 Dec 2009 13:43:45 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: michaelc@cs.wisc.edu, open-iscsi@googlegroups.com
CC: linux-kernel@vger.kernel.org
Subject: iscsi warning in 2.6.33-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B3AE91C.0191:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	I met with this warning when using iscsi with the 2.6.33-rc2.

------------[ cut here ]------------
WARNING: at drivers/scsi/libiscsi_tcp.c:996 
iscsi_tcp_task_xmit+0x15e/0x2b8 [libiscsi_tcp]()
Hardware name: OptiPlex 745
unexpected fifo state
Modules linked in: ipt_REJECT xt_tcpudp iptable_filter ip_tables 
x_tables bridge stp netconsole autofs4 hidp rfcomm l2cap crc16 bluetooth 
rfkill ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager 
ocfs2_stackglue configfs sunrpc ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad 
ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_multipath dm_mod 
video output sbs sbshc battery acpi_memhotplug ac lp sg 
snd_hda_codec_analog snd_hda_intel dcdbas rtc_cmos tg3 snd_hda_codec 
rtc_core parport_pc rtc_lib libphy sr_mod cdrom parport tpm_tis 
serio_raw snd_seq_dummy tpm tpm_bios snd_seq_oss snd_seq_midi_event 
button snd_seq e1000 snd_seq_device shpchp snd_pcm_oss snd_mixer_oss 
i2c_i801 i2c_core snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr 
ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd 
[last unloaded: microcode]
Pid: 4125, comm: iscsi_q_4 Not tainted 2.6.33-rc2 #1
Call Trace:
  [<ffffffffa028a34c>] ? iscsi_xmitworker+0x0/0x2ae [libiscsi]
  [<ffffffffa029ae77>] ? iscsi_tcp_task_xmit+0x15e/0x2b8 [libiscsi_tcp]
  [<ffffffff8203712f>] ? warn_slowpath_common+0x77/0x8e
  [<ffffffff820371a2>] ? warn_slowpath_fmt+0x51/0x59
  [<ffffffff822f3ba0>] ? _raw_spin_lock_bh+0x9/0x1f
  [<ffffffffa029ae77>] ? iscsi_tcp_task_xmit+0x15e/0x2b8 [libiscsi_tcp]
  [<ffffffffa028a34c>] ? iscsi_xmitworker+0x0/0x2ae [libiscsi]
  [<ffffffffa028984f>] ? iscsi_xmit_task+0x45/0x83 [libiscsi]
  [<ffffffffa028a4d9>] ? iscsi_xmitworker+0x18d/0x2ae [libiscsi]
  [<ffffffff8204be27>] ? worker_thread+0x146/0x1e0
  [<ffffffff8204e79b>] ? autoremove_wake_function+0x0/0x2e
  [<ffffffff8204bce1>] ? worker_thread+0x0/0x1e0
  [<ffffffff8204e4a7>] ? kthread+0x79/0x81
  [<ffffffff82003614>] ? kernel_thread_helper+0x4/0x10
  [<ffffffff8204e42e>] ? kthread+0x0/0x81
  [<ffffffff82003610>] ? kernel_thread_helper+0x0/0x10
---[ end trace 962db674bc379fa3 ]---

http://pastebin.com/m62a71466

iscsi target is
[root@ocfs2-test1 ~]# cat /etc/distro-release
Openfiler NSA 2.3

iscsi initiator is
[root@ocfs2-test2 ~]# rpm -qa|grep iscsi
iscsi-initiator-utils-6.2.0.868-0.18.el5

The other thing I can confirm is that I didn't meet with such problem in 
2.6.32-rc8.

Regards,
Tao


