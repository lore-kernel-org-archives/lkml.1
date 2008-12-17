Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754671AbYLQPuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYLQPuy (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYLQPum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:50:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52077 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYLQPul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:50:41 -0500
Date: Wed, 17 Dec 2008 10:49:53 -0500
From: Jeff Layton <jlayton@redhat.com>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: torvalds@linux-foundation.org, sfrench@gmail.com,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] cifs: fix buffer overrun in parse_DFS_referrals
Message-ID: <20081217104953.2c6fc497@tleilax.poochiereds.net>
In-Reply-To: <49491D88.3020106@diamondcut.com.br>
References: <1229513513-16445-1-git-send-email-jlayton@redhat.com>
	<49491D88.3020106@diamondcut.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 13:40:56 -0200
"Renato S. Yamane" <yamane@diamondcut.com.br> wrote:

> Jeff Layton wrote:
> > ---
> >  fs/cifs/cifssmb.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 9395928..824df14 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -3992,7 +3992,8 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
> >  
> >  		node->flags = le16_to_cpu(pSMBr->DFSFlags);
> >  		if (is_unicode) {
> > -			__le16 *tmp = kmalloc(strlen(searchName)*2, GFP_KERNEL);
> > +			__le16 *tmp = kmalloc(strlen(searchName)*2 + 2,
> > +						GFP_KERNEL);
> >  			cifsConvertToUCS((__le16 *) tmp, searchName,
> >  					PATH_MAX, nls_codepage, remap);
> >  			node->path_consumed = hostlen_fromUCS(tmp,
> 
> This patch can't be applied in -stable release:
> 
> yamane@mandachuva:~/kernel/linux-2.6.27.9$ patch -p1 < cifs.patch
> patching file fs/cifs/cifssmb.c
> patch unexpectedly ends in middle of line
> Hunk #1 FAILED at 3992.
> 1 out of 1 hunk FAILED -- saving rejects to file fs/cifs/cifssmb.c.rej
> 

My apologies. The patch that introduced this problem isn't in stable
releases. You can drop this patch from stable queue. Sorry for false alarm.

It would be good for 2.6.28 kernels though since it's a regression and
possible memory corruptor.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
