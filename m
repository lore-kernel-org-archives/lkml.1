Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbXICQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbXICQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXICQQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 12:16:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56162 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbXICQQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 12:16:18 -0400
Date: Mon, 3 Sep 2007 21:59:15 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 01/32] VFS: export release_open_intent symbol
In-Reply-To: <118878605590-git-send-email-jsipek@cs.sunysb.edu>
Message-ID: <alpine.LFD.0.999.0709032157000.5763@enigma.security.iitk.ac.in>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
 <118878605590-git-send-email-jsipek@cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 2 Sep 2007, Josef 'Jeff' Sipek wrote:
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index a83160a..b2b7c8e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -374,6 +374,7 @@ void release_open_intent(struct nameidata *nd)
>  	else
>  		fput(nd->intent.open.file);
>  }
> +EXPORT_SYMBOL(release_open_intent);

Hmm, why is this being pushed into mainline? This also looks like an
-mm only patch to me, there are no modular users of release_open_intent()
in mainline, and the next patch doesn't add one either.
