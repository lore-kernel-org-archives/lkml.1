Return-Path: <linux-kernel-owner+w=401wt.eu-S966203AbXDCRho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966203AbXDCRho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966207AbXDCRhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:37:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56098 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966203AbXDCRhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:37:42 -0400
Date: Tue, 3 Apr 2007 20:37:35 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Rene Herman <rene.herman@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
In-Reply-To: <4612642F.90407@gmail.com>
Message-ID: <Pine.LNX.4.64.0704032035590.8078@sbz-30.cs.Helsinki.FI>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
 <4610481D.8000102@gmail.com> <46104954.50608@gmail.com>
 <Pine.LNX.4.64.0704020949160.23099@sbz-30.cs.Helsinki.FI>
 <20070402071018.GE11996@kernel.dk> <Pine.LNX.4.64.0704021152280.27165@sbz-30.cs.Helsinki.FI>
 <46111ED7.20201@gmail.com> <Pine.LNX.4.64.0704021837480.6518@sbz-30.cs.Helsinki.FI>
 <46112650.8080208@gmail.com> <Pine.LNX.4.64.0704021906040.7500@sbz-30.cs.Helsinki.FI>
 <461165FD.2010508@gmail.com> <Pine.LNX.4.64.0704030908420.20080@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0704030956330.20741@sbz-30.cs.Helsinki.FI> <4612642F.90407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Rene Herman wrote:
> I believe the "tar" runs has produced something useful now though:
> 
> root@5va2:~# dmesg -c >/dev/null
> root@5va2:~# strace -o tar.strace tar cvf foo.tar /mnt/cdrom
> tar: Removing leading `/' from member names
> /mnt/cdrom/
> /mnt/cdrom/dott/
> /mnt/cdrom/dott/adlib.ims
> /mnt/cdrom/dott/dott.bat
> /mnt/cdrom/dott/dotticon.ico
> /mnt/cdrom/dott/gmidi.ims
> /mnt/cdrom/dott/maniac/
> rlogin: connection closed.
> rene@7ixe4:~$
> 
> When I now switch the monitor to 5va2 directly, there is an oops on the
> screen, with a backtrace saying (manual transcription):
> 
> Call Trace:
>   [<c1047eb6>] drain_array+0x94/0xc3
>   [   ...    ] cache_reap+0x55/0xe9
>   [   ...    ] run_workqueue+0x8f/0x14d
>   [   ...    ] cache_reap+0x0//0xe9
>   [   ...    ] worker_thread+0x122/0x14b
>   [   ...    ] default_wake_function+0x0/0xc
>   [   ...    ] default_wake_function+0x0/0xc
>   [   ...    ] worker_thread+0x0/0x14b
>   [   ...    ] kthread+0x72/0x97
>   [   ...    ] kthread+0x0/0x97
>   [   ...    ] kernel_thread_helper+0x7/0x10
>   =======================
> Code: [ ... ]
> EIP: [<c1047787>] free_block+0x58/0xcf SS:ESP [ ... ]
> 
> Couple of functions mentioned twice in that backtrace. That looks a
> little off no?

It looks like we are passing a bad pointer to slab. Please turn on 
CONFIG_DEBUG_SLAB and reproduce. It's probably a double-free as the TOC 
reading bits look racy.

				Pekka
