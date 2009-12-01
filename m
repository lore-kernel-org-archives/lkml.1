Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZLAOnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZLAOnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZLAOnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:43:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33866 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZLAOnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:43:21 -0500
Date: Tue, 1 Dec 2009 08:43:19 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, jkj@kapsi.fi, linux-kernel@vger.kernel.org,
       mschmidt@redhat.com, dhowells@redhat.com, jmorris@namei.org
Subject: Re: [PATCH] bsdacct: fix uid/gid misreporting (#14676)
Message-ID: <20091201144319.GA32117@us.ibm.com>
References: <20091130224032.GA5598@x200.malnet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130224032.GA5598@x200.malnet.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> commit d8e180dcd5bbbab9cd3ff2e779efcf70692ef541
> "bsdacct: switch credentials for writing to the accounting file"
> introduced credential switching during final acct data collecting.
> However, uid/gid pair continued to be collected from current which
> became credentials of who created acct file, not who exits.
> 
> Fix http://bugzilla.kernel.org/show_bug.cgi?id=14676
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Yeah seems like it wouuld be needed, thanks.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  Juho, please, confirm.
> 
>  kernel/acct.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -536,7 +536,8 @@ static void do_acct_process(struct bsd_acct_struct *acct,
>  	do_div(elapsed, AHZ);
>  	ac.ac_btime = get_seconds() - elapsed;
>  	/* we really need to bite the bullet and change layout */
> -	current_uid_gid(&ac.ac_uid, &ac.ac_gid);
> +	ac.ac_uid = orig_cred->uid;
> +	ac.ac_gid = orig_cred->gid;
>  #if ACCT_VERSION==2
>  	ac.ac_ahz = AHZ;
>  #endif
