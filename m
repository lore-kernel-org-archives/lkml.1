Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbXA3D4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbXA3D4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965081AbXA3D4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:56:19 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965059AbXA3D4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:56:18 -0500
Date: Mon, 29 Jan 2007 19:56:05 -0800
From: Andrew Morton <akpm@osdl.org>
To: Alan Cox <alan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: cleanup release_mem
Message-Id: <20070129195605.f5d50302.akpm@osdl.org>
In-Reply-To: <20070129190604.GA20564@devserv.devel.redhat.com>
References: <20070128171244.GA21378@lst.de>
	<20070129120100.GA4338@devserv.devel.redhat.com>
	<20070129181235.GA9063@lst.de>
	<20070129190604.GA20564@devserv.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 14:06:04 -0500
Alan Cox <alan@redhat.com> wrote:

> On Mon, Jan 29, 2007 at 07:12:35PM +0100, Christoph Hellwig wrote:
> > Okay.  Now that we get into the details I've also added some renaming,
> > release_mem becomes release_tty and the new factored out function is
> > release_one_tty.  The difference is documented in the kdoc comments.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Alan Cox <alan@redhat.com>

VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 300k freed
Write protecting the kernel read-only data: 920k
BUG: unable to handle kernel paging request at virtual address 6b6b6bdf
 printing eip:
c02a91ec
*pde = 00000000
Oops: 0000 [#1]
SMP 
last sysfs file: /block/hdc/range
Modules linked in:
CPU:    0
EIP:    0060:[<c02a91ec>]    Not tainted VLI
EFLAGS: 00010286   (2.6.20-rc6-mm3 #1)
EIP is at release_tty+0x2c/0x40
eax: 6b6b6b6b   ebx: f71c860c   ecx: c0175e24   edx: 00000000
esi: 00000000   edi: 00000001   ebp: c222fe88   esp: c222fe80
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process init (pid: 1, ti=c222e000 task=c222cae0 task.ti=c222e000)
Stack: f71c860c 00000000 c222ff3c c02aac29 00000000 c22e453c c222fea0 00000006 
       c222fec4 002ad15c 00000000 00000001 00000000 00000000 00000000 00000001 
       c06650a0 000001d8 00000000 c222ff24 c013d53f c0178d34 f7c383c4 c222ff20 
Call Trace:
 [<c0103f7a>] show_trace_log_lvl+0x1a/0x30
 [<c0104038>] show_stack_log_lvl+0xa8/0xe0
 [<c0104259>] show_registers+0x1e9/0x2f0
 [<c010447a>] die+0x11a/0x250
 [<c0115580>] do_page_fault+0x2f0/0x5f0
 [<c03d74b4>] error_code+0x7c/0x84
 [<c02aac29>] release_dev+0x519/0x750
 [<c02aae72>] tty_release+0x12/0x20
 [<c017b8e4>] __fput+0xb4/0x180
 [<c017bb02>] fput+0x22/0x40
 [<c0178db7>] filp_close+0x47/0x70
 [<c0179f4d>] sys_close+0x6d/0xc0
 [<c0102edc>] sysenter_past_esp+0x5d/0x99
 =======================
Code: 89 e5 83 ec 08 89 1c 24 89 c3 89 74 24 04 89 d6 8b 80 fc 00 00 00 85 c0 74 05 e8 00 ff ff ff 89 f2 89 d8 e8 f7 fe ff ff 8b 43 04 <8b> 40 74 e8 8c b3 e9 ff 8b 1c 24 8b 74 24 04 89 ec 5d c3 90 55 
EIP: [<c02a91ec>] release_tty+0x2c/0x40 SS:ESP 0068:c222fe80
Kernel panic - not syncing: Attempted to kill init!
