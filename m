Return-Path: <linux-kernel-owner+w=401wt.eu-S939521AbXGSPtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939521AbXGSPtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbXGSPsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:48:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353AbXGSPsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:48:53 -0400
Subject: Re: [PATCH] Fix memory leak in dlm_add_member() when
	dlm_node_weight() returns less than zero
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Teigland <teigland@redhat.com>
In-Reply-To: <200707190027.43195.jesper.juhl@gmail.com>
References: <200707190027.43195.jesper.juhl@gmail.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 19 Jul 2007 16:48:28 +0100
Message-Id: <1184860108.8765.396.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the GFS2 git tree. Thanks,

Steve.

On Thu, 2007-07-19 at 00:27 +0200, Jesper Juhl wrote:
> Greetings,
> 
> There's a memory leak in fs/dlm/member.c::dlm_add_member().
> 
> If "dlm_node_weight(ls->ls_name, nodeid)" returns < 0, then 
> we'll return without freeing the memory allocated to the (at 
> that point yet unused) 'memb'.
> This patch frees the allocated memory in that case and thus 
> avoids the leak.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  fs/dlm/member.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/dlm/member.c b/fs/dlm/member.c
> index 073599d..d099775 100644
> --- a/fs/dlm/member.c
> +++ b/fs/dlm/member.c
> @@ -56,8 +56,10 @@ static int dlm_add_member(struct dlm_ls *ls, int nodeid)
>  		return -ENOMEM;
>  
>  	w = dlm_node_weight(ls->ls_name, nodeid);
> -	if (w < 0)
> +	if (w < 0) {
> +		kfree(memb);
>  		return w;
> +	}
>  
>  	memb->nodeid = nodeid;
>  	memb->weight = w;
> 

