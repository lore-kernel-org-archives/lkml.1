Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbYJCOYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbYJCOYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYJCOX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:23:58 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:48723 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYJCOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:23:57 -0400
Date: Fri, 3 Oct 2008 15:23:42 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, matthew.dodd@sparta.com, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 11/14] NFS/RPC: Add the auth_seclabel security flavor
	to allow the process label to be sent to the server.
Message-ID: <20081003142342.GA9774@brain>
References: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov> <1222707986-26606-12-git-send-email-dpquigl@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222707986-26606-12-git-send-email-dpquigl@tycho.nsa.gov>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 01:06:23PM -0400, David P. Quigley wrote:
[...]
>  
> +	if (dom->flavour != &svcauth_unix
> +#ifdef CONFIG_SECURITY
> +	    && dom->flavour != &svcauth_seclabel
> +#endif
> +	   )
>  	if (dom->flavour != &svcauth_unix)
>  		return -EINVAL;
>  	udom = container_of(dom, struct unix_domain, h);
> @@ -873,3 +889,80 @@ struct auth_ops svcauth_unix = {
>  	.set_client	= svcauth_unix_set_client,
>  };

checkpatch picked up on a suspect code indent for this hunk.  It is
unhappy about the second if expecting it to be indented.  By the looks
of this I am suspecting a miss-merge of the change in this function and
the second if should have been removed.  To my reading it actually still
does the right thing but ...

-apw
