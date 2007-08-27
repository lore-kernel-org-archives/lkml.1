Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbXH0XSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbXH0XSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbXH0XRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:17:52 -0400
Received: from tara2.wa.amnet.net.au ([203.161.126.21]:44019 "EHLO
	tara2.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbXH0XRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:17:51 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2007 19:17:50 EDT
Date: Tue, 28 Aug 2007 07:11:04 +0800
From: Michael Deegan <michael@ucc.gu.uwa.edu.au>
To: linux-cifs-client@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [linux-cifs-client] Re: BUG: scheduling while atomic - linux 2.6.22
Message-ID: <20070827231104.GN4867@wibble.darktech.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Subliminal-Message: .yenom em dneS .tsixe ton od segassem lanimilbuS
X-Homepage-URL: http://wibble.darktech.org/
X-Random-Number: -4.73509846390026e+147
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue Aug 7 16:00:19 GMT 2007, Martin Koegler  wrote:
> A vanilla 2.6.22 kernel (SMP PREEMPT i686) produced the following messages, while working with a CIFS mount point:
> 
> Aug  7 16:12:30 localhost kernel: BUG: scheduling while atomic: bash/0x00000001/5868
> Aug  7 16:12:30 localhost kernel:  [schedule+1312/2250] schedule+0x520/0x8ca
> Aug  7 16:12:30 localhost kernel:  [__switch_to+157/410] __switch_to+0x9d/0x19a
> Aug  7 16:12:30 localhost kernel:  [kernel_sendmsg+39/53] kernel_sendmsg+0x27/0x35
> Aug  7 16:12:30 localhost kernel:  [<e0c204aa>] wait_for_response+0xca/0x134 [cifs]
> Aug  7 16:12:30 localhost kernel:  [autoremove_wake_function+0/53] autoremove_wake_function+0x0/0x35
> Aug  7 16:12:30 localhost kernel:  [<e0c20a5c>] SendReceive+0x12b/0x457 [cifs]
> Aug  7 16:12:30 localhost kernel:  [<e0c0abf4>] CIFSSMBOpen+0x109/0x2c2 [cifs]
> Aug  7 16:12:30 localhost kernel:  [<e0c170d3>] cifs_reopen_file+0x123/0x3d0 [cifs]
> Aug  7 16:12:30 localhost kernel:  [<e0c17cf4>] find_writable_file+0x7b/0xdb [cifs]
> Aug  7 16:12:30 localhost kernel:  [<e0c183e8>] is_size_safe_to_change+0x18/0x7a [cifs]
> Aug  7 16:12:30 localhost kernel:  [<e0c26959>] cifs_readdir+0x1118/0x167f [cifs]
> Aug  7 16:12:30 localhost kernel:  [filldir64+0/197] filldir64+0x0/0xc5
> Aug  7 16:12:30 localhost kernel:  [filldir64+0/197] filldir64+0x0/0xc5
> Aug  7 16:12:30 localhost kernel:  [vfs_readdir+124/145] vfs_readdir+0x7c/0x91
> Aug  7 16:12:30 localhost kernel:  [sys_getdents64+99/165] sys_getdents64+0x63/0xa5
> Aug  7 16:12:30 localhost kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
> Aug  7 16:12:30 localhost kernel:  [netlbl_unlabel_list+143/479] netlbl_unlabel_list+0x8f/0x1df
> Aug  7 16:12:30 localhost kernel:  =======================
> Aug  7 16:13:03 localhost kernel:  CIFS VFS: Send error in Close = -9

FWIW, I saw something very similar:

Aug 27 22:33:08 wibble kernel: BUG: scheduling while atomic: bash/0x00000001/4077
Aug 27 22:33:08 wibble kernel:
Aug 27 22:33:08 wibble kernel: Call Trace:
Aug 27 22:33:08 wibble kernel:  [<ffffffff805265df>] __sched_text_start+0x5f/0x79b
Aug 27 22:33:08 wibble kernel:  [<ffffffff8049cb7a>] kernel_sendmsg+0x2c/0x3e
Aug 27 22:33:08 wibble kernel:  [<ffffffff8032ba42>] wait_for_response+0xbe/0x155
Aug 27 22:33:08 wibble kernel:  [<ffffffff802392bf>] autoremove_wake_function+0x0/0x2e
Aug 27 22:33:08 wibble kernel:  [<ffffffff8032c0e1>] SendReceive+0x1fb/0x3f8
Aug 27 22:33:08 wibble kernel:  [<ffffffff803192c2>] CIFSSMBOpen+0x1c6/0x27a
Aug 27 22:33:08 wibble kernel:  [<ffffffff80323b8a>] cifs_reopen_file+0x1ea/0x356
Aug 27 22:33:08 wibble kernel:  [<ffffffff8032455c>] find_writable_file+0x84/0xe7
Aug 27 22:33:08 wibble kernel:  [<ffffffff80324b51>] is_size_safe_to_change+0x16/0x4e
Aug 27 22:33:08 wibble kernel:  [<ffffffff8032fbc7>] fill_in_inode+0x270/0x4ec
Aug 27 22:33:08 wibble kernel:  [<ffffffff80330c67>] cifs_readdir+0xe24/0x1071
Aug 27 22:33:08 wibble kernel:  [<ffffffff802733c8>] filldir64+0x0/0xb8
Aug 27 22:33:08 wibble kernel:  [<ffffffff80218c71>] do_page_fault+0x40b/0x74a
Aug 27 22:33:08 wibble kernel:  [<ffffffff80527ffb>] __mutex_lock_slowpath+0x234/0x23f
Aug 27 22:33:08 wibble kernel:  [<ffffffff802733c8>] filldir64+0x0/0xb8
Aug 27 22:33:08 wibble kernel:  [<ffffffff80273594>] vfs_readdir+0x5d/0x92
Aug 27 22:33:08 wibble kernel:  [<ffffffff8027363e>] sys_getdents64+0x75/0xba
Aug 27 22:33:08 wibble kernel:  [<ffffffff8052948d>] error_exit+0x0/0x84
Aug 27 22:33:08 wibble kernel:  [<ffffffff8020958e>] system_call+0x7e/0x83
Aug 27 22:33:08 wibble kernel:

I'm using a 2.6.22.1 kernel (with SMP and PREEMPT, including BKL) on Debian
etch AMD64, and Samba 3.0.24-6etch4.

(please CC replies)

-MD

-- 
-------------------------------------------------------------------------------
Michael Deegan           Hugaholic          http://wibble.darktech.org/gallery/
------------------------- Nyy Tybel Gb Gur Ulcabgbnq! -------------------------
