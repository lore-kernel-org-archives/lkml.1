Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbXHFSBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbXHFSBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXHFSBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:01:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41432 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752432AbXHFSBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:01:39 -0400
Date: Mon, 6 Aug 2007 11:01:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-kernel@vger.kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.22.1 Oops in put_nfs_open_context
Message-Id: <20070806110107.0d0a2c2b.akpm@linux-foundation.org>
In-Reply-To: <20070806100813.GA30370@gallifrey>
References: <20070806100813.GA30370@gallifrey>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007 11:08:13 +0100 "Dr. David Alan Gilbert" <linux@treblig.org> wrote:

>   The oops below is from one of a pair of machines that run compiles;
> they're not managing to stay up for more than a day or two at a time
> this is the first time I've actually managed to capture an oops from one.
> They lock to the point where they still ping, and they won't toggle
> capslock.  A top left running on them showed it sitting with pdflush
> using 99% CPU.
> 
>   Config at the bottom.  The hardware are supermicro X7DVA boards with
> 2x Xeon 5140's. (These Supermicro bios don't appear to have the PCI-Express
> coalesce option being discussed in another thread).
> 
> Dave
> 
> Aug  3 19:15:41 fel kernel: [185427.633686] BUG: unable to handle kernel paging request at virtual address 00100104
> Aug  3 19:15:41 fel kernel: [185427.633691]  printing eip:
> Aug  3 19:15:41 fel kernel: [185427.633693] c01fe613
> Aug  3 19:15:41 fel kernel: [185427.633694] *pde = 00000000
> Aug  3 19:15:41 fel kernel: [185427.633697] Oops: 0002 [#1]
> Aug  3 19:15:41 fel kernel: [185427.633705] SMP
> Aug  3 19:15:41 fel kernel: [185427.633712] Modules linked in: netconsole
> Aug  3 19:15:41 fel kernel: [185427.633721] CPU:    2 Aug  3 19:15:41 fel kernel: [185427.633722] EIP:    0060:[<c01fe613>]    Not tainted VLI
> Aug  3 19:15:41 fel kernel: [185427.633723] EFLAGS: 00010296   (2.6.22.1daveg #3) Aug  3 19:15:41 fel kernel: [185427.633735] EIP is at put_nfs_open_context+0x30/0x7d
> Aug  3 19:15:41 fel kernel: [185427.633739] eax: 00100100   ebx: d299b634   ecx: 00000001   edx: 00200200 Aug  3 19:15:41 fel kernel: [185427.633744] esi: cd4c7240   edi: cd4c7260   ebp: e2a25d30   esp: e2a25d24
> Aug  3 19:15:42 fel kernel: [185427.633748] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068 Aug  3 19:15:43 fel kernel: [185427.633752] Process ccache (pid: 8352, ti=e2a24000 task=f69c15b0 task.ti=e2a24000)
> Aug  3 19:15:43 fel kernel: [185427.633756] Stack: e469b680 d299b57c 00000029 e2a25d3c c02014dd 00000000 e2a25d68 c020475f Aug  3 19:15:43 fel kernel: [185427.633774]        00000001 00000000 00000000 ffffffff d299b4ac e469b680 d299b57c 00000000
> Aug  3 19:15:43 fel kernel: [185427.633791]        00000001 e2a25da0 c0205a2d 00000000 00000000 00000000 00000000 d299b4ac Aug  3 19:15:44 fel kernel: [185427.633809] Call Trace:
> Aug  3 19:15:44 fel kernel: [185427.633813]  [<c0104034>] show_trace_log_lvl+0x19/0x2e
> Aug  3 19:15:46 fel kernel: [185427.633821]  [<c01040fe>] show_stack_log_lvl+0xa1/0xa9
> Aug  3 19:15:47 fel kernel: [185427.633827]  [<c0104301>] show_registers+0x1b8/0x289
> Aug  3 19:15:47 fel kernel: [185427.633833]  [<c0104524>] die+0x10d/0x1d2
> Aug  3 19:15:47 fel kernel: [185427.633839]  [<c0431938>] do_page_fault+0x44d/0x524
> Aug  3 19:15:47 fel kernel: [185427.633847]  [<c043018a>] error_code+0x72/0x78
> Aug  3 19:15:47 fel kernel: [185427.633852]  [<c02014dd>] nfs_release_request+0x20/0x2f
> Aug  3 19:15:47 fel kernel: [185427.633859]  [<c020475f>] nfs_wait_on_requests_locked+0x6d/0xae
> Aug  3 19:15:47 fel kernel: [185427.633866]  [<c0205a2d>] nfs_sync_mapping_wait+0x82/0x11b
> Aug  3 19:15:47 fel kernel: [185427.633872]  [<c0205b23>] nfs_wb_all+0x5d/0x7b
> Aug  3 19:15:47 fel kernel: [185427.633878]  [<c01fc93b>] nfs_rename+0x16b/0x275
> Aug  3 19:15:47 fel kernel: [185427.633884]  [<c0168c99>] vfs_rename_other+0x65/0xaf
> Aug  3 19:15:47 fel kernel: [185427.633891]  [<c0168dd0>] vfs_rename+0xed/0x20b
> Aug  3 19:15:47 fel kernel: [185427.633896]  [<c016902f>] do_rename+0x141/0x182
> Aug  3 19:15:47 fel kernel: [185427.633902]  [<c01690ab>] sys_renameat+0x3b/0x5d
> Aug  3 19:15:47 fel kernel: [185427.633907]  [<c01690f5>] sys_rename+0x28/0x2a
> Aug  3 19:15:47 fel kernel: [185427.633913]  [<c01032a6>] sysenter_past_esp+0x5f/0x85
> Aug  3 19:15:47 fel kernel: [185427.633919]  =======================
> Aug  3 19:15:47 fel kernel: [185427.633922] Code: 89 c6 53 f0 ff 08 0f 94 c0 84 c0 74 66 8d 7e 20 39 7e 20 74 30 8b 46 08 8b 58 24 83 c3 6c 89 d8 e8 4c 17 23 00 8b 46 20 8b 57 04 <89> 50 04 89 02 89 d8 c7 46 20 00 01 10 00 c7 47 04 00 02 20 00
> Aug  3 19:15:47 fel kernel: [185427.634022] EIP: [<c01fe613>] put_nfs_open_context+0x30/0x7d SS:ESP 0068:e2a25d24

We did a list operation on an already-deleted list_head.

That code has changed a lot between 2..22 and 2.6.23-rc2.  Hopefully for the
better, although I can't immediately find a commit in there which looks like
it addresses this bug.



