Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbXEQRre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbXEQRre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbXEQRrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:47:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759456AbXEQRrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:47:19 -0400
Date: Thu, 17 May 2007 10:36:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
       herbert@gondor.apana.org.au, dmitry.torokhov@gmail.com, kkeil@suse.de,
       trond.myklebust@fys.uio.no, chas@cmf.nrl.navy.mil, kaber@trash.net,
       devel@openvz.org
Subject: Re: [PATCH] Make common helpers for seq_files that work with
 list_head-s
Message-Id: <20070517103655.b6a7054c.akpm@linux-foundation.org>
In-Reply-To: <464C728C.8050507@sw.ru>
References: <464C728C.8050507@sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 19:19:40 +0400 Pavel Emelianov <xemul@sw.ru> wrote:

> Many places in kernel use seq_file API to iterate over a regular
> list_head. The code for such iteration is identical in all the
> places, so it's worth introducing a common helpers.
> 
> This makes code more than 300 lines smaller.
> 
> Cc-ed are people, who maintain the code altered by the patch.
> 
> Signed-off-by: Pavel Emelianov <xemul@openvz.org>
> 
>  block/genhd.c                                         |   40 +++-----
>  crypto/proc.c                                         |   17 ---
>  drivers/char/misc.c                                   |   18 ----
>  drivers/input/input.c                                 |   29 ------
>  drivers/isdn/capi/kcapi_proc.c                        |   28 ------
>  fs/afs/proc.c                                         |   81 ++----------------
>  fs/namespace.c                                        |   14 ---
>  fs/nfs/client.c                                       |   54 +-----------
>  fs/proc/proc_tty.c                                    |   15 ---
>  include/linux/seq_file.h                              |   35 +++++++
>  kernel/module.c                                       |   17 ---
>  mm/slab.c                                             |   28 +-----
>  net/atm/br2684.c                                      |   22 ----
>  net/core/sock.c                                       |   39 --------
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |   27 ------
>  net/netfilter/nf_conntrack_expect.c                   |   27 ------
>  net/rxrpc/ar-proc.c                                   |   48 +---------
>  17 files changed, 116 insertions(+), 423 deletions(-)

Can't complain about the diffstat.  Please experiment with uninlining
seq_list_start(), see if that reduces overall text size.

And as Dmitry indicated, it would be less disruptive if we could have the
one core patch then a stream of per-subsystem patches, please.
