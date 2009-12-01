Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZLARvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZLARvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbZLARvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:51:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZLARvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:51:22 -0500
Date: Tue, 1 Dec 2009 18:49:57 +0100
From: Michal Schmidt <mschmidt@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, jkj@kapsi.fi, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, serue@us.ibm.com, jmorris@namei.org,
       stable@kernel.org
Subject: Re: [PATCH] bsdacct: fix uid/gid misreporting (#14676)
Message-ID: <20091201184957.27a2aaab@leela>
In-Reply-To: <20091130224032.GA5598@x200.malnet.ru>
References: <20091130224032.GA5598@x200.malnet.ru>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 01:40:32 +0300 Alexey Dobriyan wrote:
> commit d8e180dcd5bbbab9cd3ff2e779efcf70692ef541
> "bsdacct: switch credentials for writing to the accounting file"
> introduced credential switching during final acct data collecting.
> However, uid/gid pair continued to be collected from current which
> became credentials of who created acct file, not who exits.
> 
> Fix http://bugzilla.kernel.org/show_bug.cgi?id=14676
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Ah, indeed. The original commit went into 2.6.31-stable so this one
should too.

Reviewed-by: Michal Schmidt <mschmidt@redhat.com>

> 
>  Juho, please, confirm.
> 
>  kernel/acct.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -536,7 +536,8 @@ static void do_acct_process(struct
> bsd_acct_struct *acct, do_div(elapsed, AHZ);
>  	ac.ac_btime = get_seconds() - elapsed;
>  	/* we really need to bite the bullet and change layout */
> -	current_uid_gid(&ac.ac_uid, &ac.ac_gid);
> +	ac.ac_uid = orig_cred->uid;
> +	ac.ac_gid = orig_cred->gid;
>  #if ACCT_VERSION==2
>  	ac.ac_ahz = AHZ;
>  #endif

