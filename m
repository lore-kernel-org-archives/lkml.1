Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZALSGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZALSGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZALSGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:06:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:33263 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZALSGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:06:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LHNni7rY5RiS/pxQWrCP9AHiNzrq3Wb4tqRLBu1fuCK+u+3QzRt0qkulPAsBZMwYUr
         lD8QYDXkoh6EHRYcULnE8Kcuqyvhl/WiSEv3MFxCbxlJ4A2YrPijvEwKwJOZCoq7C0pc
         M8Vzc2qnCtXMYey+nLvqI4Fb6isrVodJO6440=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: [2.6.27.10] warn_on_slowpath on CD access
Date: Mon, 12 Jan 2009 19:04:02 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-next-20090107; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@googlemail.com>
References: <50218D5BDC%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <50218D5BDC%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121904.02584.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, Darren Salt wrote:
> I'm seeing warn_on_slowpath traces if I run "gxine cdda://" with a CD in the
> drive. (The test CD has a data track followed by some audio tracks, but
> that's probably not important.)
> 
> The warning follows this paragraph. There is taint, but that's entirely due
> to earlier warn_on_slowpath traces, all identical to this one. Hardware, if
> it's relevant, is an nForce4-based board. Kernel is a locally-compiled
> 2.6.27.10; config is attached.
> 
> 
> WARNING: at arch/x86/kernel/pci-nommu.c:62 nommu_map_sg+0x31/0xb2()
> Modules linked in: mt2060 dvb_usb_dib0700 dib7000p dib7000m dvb_usb dib3000mc
> dibx000_common dib0070 vfat fat usb_storage sd_mod radeon drm rfcomm l2cap
> ip6t_LOG xt_tcpudp ip6t_REJECT nf_conntrack_ipv6 xt_state nf_conntrack
> ip6table_mangle ip6table_filter ip6_tables x_tables snd_emu10k1_synth
> snd_emux_synth snd_seq_virmidi snd_seq_midi_emul dvb_pll cx22702 cx88_dvb
> videobuf_dvb dvb_core snd_emu10k1 snd_seq_midi cx8800 snd_rawmidi
> compat_ioctl32 cx8802 cx88xx snd_util_mem ir_common videodev v4l1_compat
> snd_intel8x0 tveeprom snd_hwdep sata_nv v4l2_common btcx_risc videobuf_dma_sg
> btusb snd_ac97_codec videobuf_core ac97_bus snd_pcm_oss snd_mixer_oss libata
> dock snd_pcm bluetooth snd_page_alloc
> Pid: 9809, comm: gxine Tainted: G        W 2.6.27.10 #1
> 
> Call Trace:
>  [<ffffffff802299aa>] warn_on_slowpath+0x51/0x77
>  [<ffffffff80315e3f>] delay_tsc+0x15/0x27
>  [<ffffffff803abf50>] do_rw_taskfile+0x1cb/0x1e3
>  [<ffffffff8030da3b>] cfq_dispatch_insert+0x37/0x4a
>  [<ffffffff80223668>] update_curr+0x3b/0x57
>  [<ffffffff80223ff3>] dequeue_entity+0x12/0x80
>  [<ffffffff802102a7>] nommu_map_sg+0x31/0xb2
>  [<ffffffff803ad5d5>] ide_build_dmatable+0x29/0x127
>  [<ffffffff803ad802>] ide_dma_setup+0x36/0xd0
>  [<ffffffff803b1fdf>] cdrom_do_newpc_cont+0x0/0x18
>  [<ffffffff803b1a99>] ide_cd_do_request+0x56b/0x5f8
>  [<ffffffff803a701b>] ide_do_request+0x6c0/0x904
>  [<ffffffff80306214>] elv_insert+0x81/0x19a
>  [<ffffffff80309a8c>] blk_execute_rq_nowait+0x51/0x6d
>  [<ffffffff80309b30>] blk_execute_rq+0x88/0xb0
>  [<ffffffff80307a7e>] get_request_wait+0x3a/0xdd
>  [<ffffffff80309dd2>] blk_recount_segments+0x30/0x5b
>  [<ffffffff803b2113>] ide_cd_queue_pc+0xc2/0x154
>  [<ffffffff803079ad>] get_request+0x19f/0x236
>  [<ffffffff803b3457>] ide_cdrom_packet+0x77/0x8e
>  [<ffffffff803bf476>] mmc_ioctl+0x1ec/0x1214
>  [<ffffffff80210276>] nommu_map_sg+0x0/0xb2
>  [<ffffffff80315e3f>] delay_tsc+0x15/0x27
>  [<ffffffff803a7c27>] __ide_wait_stat+0x9b/0xc7
>  [<ffffffff80223668>] update_curr+0x3b/0x57
>  [<ffffffff80223f35>] __dequeue_entity+0x25/0x68
>  [<ffffffff8022468f>] pick_next_task_fair+0x9a/0xaa
>  [<ffffffff8024bd5e>] sync_page_killable+0x0/0x31
>  [<ffffffff804b01ca>] io_schedule+0xf/0x17
>  [<ffffffff8024a6d1>] sync_page+0x39/0x3e
>  [<ffffffff804b0330>] __wait_on_bit_lock+0x63/0x71
>  [<ffffffff8022cfa1>] current_fs_time+0x1e/0x24
>  [<ffffffff803c0d71>] cdrom_ioctl+0x8d3/0xc39
>  [<ffffffff8024c263>] generic_file_aio_read+0x4d4/0x534
>  [<ffffffff803b11ea>] idecd_ioctl+0x149/0x15c
>  [<ffffffff8024a527>] find_get_page+0x1a/0x51
>  [<ffffffff8024a80b>] find_lock_page+0x22/0x54
>  [<ffffffff8030afb7>] blkdev_ioctl+0x605/0x63a
>  [<ffffffff802558a8>] __do_fault+0x307/0x350
>  [<ffffffff80256d9c>] handle_mm_fault+0x315/0x5a4
>  [<ffffffff80288741>] block_ioctl+0x1b/0x1f
>  [<ffffffff8027202f>] vfs_ioctl+0x1b/0x50
>  [<ffffffff80272276>] do_vfs_ioctl+0x212/0x21f
>  [<ffffffff802722bf>] sys_ioctl+0x3c/0x5d
>  [<ffffffff8020b11b>] system_call_fastpath+0x16/0x1b
> 
> ---[ end trace 7284c9695c67e9c1 ]---

Please try patches from:

http://bugzilla.kernel.org/show_bug.cgi?id=12320

Thanks,
Bart
