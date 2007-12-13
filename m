Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbXLMLZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbXLMLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 06:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXLMLZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 06:25:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53223 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXLMLZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 06:25:15 -0500
Date: Thu, 13 Dec 2007 12:25:14 +0100
From: Jan Kara <jack@suse.cz>
To: Mitch <Mitch@0Bits.COM>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext3 SMP bug  ?  PANIC in __d_find_alias
Message-ID: <20071213112514.GC15541@atrey.karlin.mff.cuni.cz>
References: <475FD03A.7080401@0Bits.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475FD03A.7080401@0Bits.COM>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can anyone help with this ? This seems to be a true SMP bug - the same 
> kernel on another UP machine is working fine (although different h/w). 
> Seems like stress (find for example) can easily trigger this. Does it 
> look like i have a bad filesystem ? Can anyone help me figure out which 
> one ? The fact that this is tainted (due to nvidia) is a red herring i 
> think because both my machines (the SMP and UP one) are using the same 
> nvidia module and the panic is in ext3 code.
> 
> Help
> Mitch
> 
> Dec 10 03:02:43 home kernel: BUG: unable to handle kernel NULL pointer 
> dereference at virtual address 00000000
> Dec 10 03:02:43 home kernel:  printing eip:
> Dec 10 03:02:43 home kernel: c01761fc
> Dec 10 03:02:43 home kernel: *pdpt = 00000000198a6001
> Dec 10 03:02:43 home kernel: *pde = 0000000000000000
> Dec 10 03:02:43 home kernel: Oops: 0000 [#1]
> Dec 10 03:02:43 home kernel: PREEMPT SMP
> Dec 10 03:02:43 home kernel: Modules linked in: loop nls_iso8859_1 
> nls_cp437 vfat fat tun iptable_nat nvidia(P) appletalk psnap llc nfsd expo
> rtfs lockd sunrpc xt_limit xt_tcpudp iptable_mangle ipt_LOG 
> ipt_MASQUERADE nf_nat ipt_TOS ipt_REJECT nf_conntrack_irc 
> nf_conntrack_ftp nf_con
> ntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables 
> ftdi_sio usbserial forcedeth snd_hda_intel snd_seq_oss snd_seq_midi_event
>  snd_seq snd_seq_device snd_pcm_oss snd_pcm snd_timer snd_page_alloc 
> snd_mixer_oss snd usb_storage ehci_hcd ohci_hcd it87 hwmon_vid i2c_dev i
> 2c_core
> Dec 10 03:02:43 home kernel: CPU:    1
> Dec 10 03:02:43 home kernel: EIP:    0060:[__d_find_alias+44/192] 
  Looks like inode->i_dentry.next has been NULL. But I don't really
understand how that could be ever NULL because list_heads are always
cyclic lists... Can you try enabling "Debug linked list manipulation" and
also "Debug slab memory allocations" in Kernel hacking menu and see
whether some other errors appear?

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
