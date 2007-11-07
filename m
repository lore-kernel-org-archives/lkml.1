Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbXKGNor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbXKGNor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbXKGNok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:44:40 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:54102 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421AbXKGNoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:44:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAEpOMUdMROHU/2dsb2JhbACBWw
Date: Wed, 7 Nov 2007 08:44:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1 NULL pointer dereference in NFS
Message-ID: <20071107134437.GB28283@Krystal>
References: <20071106204808.GB18743@Krystal> <1194442328.7456.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1194442328.7456.5.camel@heimdal.trondhjem.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:43:12 up 3 days, 18:48,  2 users,  load average: 0.29, 0.61,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Trond Myklebust (trond.myklebust@fys.uio.no) wrote:
> 
> On Tue, 2007-11-06 at 15:48 -0500, Mathieu Desnoyers wrote:
> > Hi,
> > 
> > I just ran through this OOPS when I was doing a dpkg dist-upgrade on my
> > Pentium III. Any idea what could have caused this ?
> > 
> > (by the way, this computer is generally slow since I upgraded to
> > 2.6.23.1. It could be a related symptom...)
> > 
> > BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> >  printing eip:
> > c54a53cf
> > *pde = 00000000
> > Oops: 0002 [#1]
> > PREEMPT 
> > Modules linked in: mga_vid fuse rt2570 iptable_filter ip_tables x_tables tun mga drm uhci_hcd 3c59x mii via_agp thermal usbcore button agpgart processor
> > CPU:    0
> >    Not tainted VLI
> > EFLAGS: 00210202   (2.6.23.1 #1)
> > EIP is at 0xc54a53cf
> > eax: c54a5344   ebx: c54a5344   ecx: 00000000   edx: c54a5378
> > esi: 00000000   edi: c54a53ac   ebp: c54a5474   esp: dfedbc34
> > ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
> > Process xmms (pid: 1337, ti=dfeda000 task=e0602000 task.ti=dfeda000)
> > Stack: c041dcc8 00000001 c54a5344 c54a54b8 c54a5344 c54a5344 c54a54b8 e75b6c00 
> >        c01f364e 00000000 00000000 c54a5340 c54a54b8 dfedbd54 c01f37c0 00002000 
> >        00000000 00002000 dfedbd54 c136bb20 00003000 c01f19b2 00002000 00000000 
> > Call Trace:
> > __rpc_execute+0x5b/0x21f
> > nfs_execute_read+0x30/0x3f
> > nfs_pagein_one+0x99/0xd0
> > nfs_pageio_doio+0x2e/0x54
> > nfs_pageio_add_request+0x98/0xa9
> > readpage_async_filler+0x117/0x134
> > readpage_async_filler+0x0/0x134
> > read_cache_pages+0x6a/0xb4
> > nfs_readpages+0x124/0x173
> > nfs_pagein_one+0x0/0xd0
> > nfs_readpages+0x0/0x173
> > __do_page_cache_readahead+0x19b/0x260
> > update_curr+0x102/0x12c
> > ondemand_readahead+0x48/0xee
> > page_cache_sync_readahead+0x2a/0x2f
> > do_generic_mapping_read+0xd8/0x3d0
> > __check_preempt_curr_fair+0x4f/0x7c
> > generic_file_aio_read+0x152/0x181
> > file_read_actor+0x0/0xd7
> > do_sync_read+0x0/0x109
> > do_sync_read+0xc6/0x109
> > autoremove_wake_function+0x0/0x33
> > do_sync_read+0x0/0x109
> > vfs_read+0xa6/0x128
> > sys_read+0x41/0x67
> > syscall_call+0x7/0xb
> >  =======================
> > Code: a4 53 4a c5 a4 53 4a c5 c1 cf 50 d7 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1e 06 00 00 00 00 00 <00> 1e 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> 
> That is a lot of zeros... Did you perchance compile this kernel over NFS
> using kernel 2.6.23 or 2.6.23.1? There is a known writeback bug that
> results in that kind of corruption. See
> 
>    http://bugzilla.kernel.org/show_bug.cgi?id=9315
> 

Nope, it was compiled locally on an ext3 partition.

When the oops happened, I was also reading a flac file from an NFS
server using xmms, which is liklely to be what was causing the NFS
traffic.

Mathieu


> Cheers
>   Trond
> 
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
