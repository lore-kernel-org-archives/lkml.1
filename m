Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZGAPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZGAPOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZGAPN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:13:59 -0400
Received: from tundra.namei.org ([65.99.196.166]:55133 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZGAPN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:13:58 -0400
Date: Thu, 2 Jul 2009 01:13:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Amerigo Wang <amwang@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 1/3] elf: fix one check-after-use
In-Reply-To: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.0907020112520.29793@tundra.namei.org>
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Amerigo Wang wrote:

> 
> Check before use it.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: David Howells <dhowells@redhat.com>

Probably needs to go into Linus' tree and stable.


Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: James Morris <jmorris@namei.org>

> 
> ---
> Index: linux-2.6/fs/binfmt_elf.c
> ===================================================================
> --- linux-2.6.orig/fs/binfmt_elf.c
> +++ linux-2.6/fs/binfmt_elf.c
> @@ -1522,11 +1522,11 @@ static int fill_note_info(struct elfhdr 
>  	info->thread = NULL;
>  
>  	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
> -	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
> -
>  	if (psinfo == NULL)
>  		return 0;
>  
> +	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
> +
>  	/*
>  	 * Figure out how many notes we're going to need for each thread.
>  	 */
> 

-- 
James Morris
<jmorris@namei.org>
