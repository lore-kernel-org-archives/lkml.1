Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbYBMTeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbYBMTeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbYBMTeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:34:10 -0500
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:36811 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751584AbYBMTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:34:08 -0500
X-YMail-OSG: OZOiWOEVM1lamvgNcArPWS322lnqrHgfK.jaXBw68GFb17N14ZlO0nb45rfBixVdn4Ah5E4Uv4nL6akouiOMrZSQE7mEGyPrsNPSft8fGFhvPYRjkE8-
X-RocketYMMF: rancidfat
Date: Wed, 13 Feb 2008 11:34:07 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: + smack-check-for-struct-socket-with-null-sk.patch added to -mm tree
To: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, casey@schuafler-ca.com
In-Reply-To: <200802130811.m1D8BOx9015575@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <694696.12762.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- akpm@linux-foundation.org wrote:

> 
> The patch titled
>      Smack: check for 'struct socket' with NULL sk
> has been added to the -mm tree.  Its filename is
>      smack-check-for-struct-socket-with-null-sk.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: Smack: check for 'struct socket' with NULL sk
> From: "Ahmed S. Darwish" <darwish.07@gmail.com>
> 
> There's a small problem with smack and NFS. A similar report was also
> sent here: http://lkml.org/lkml/2007/10/27/85
> 
> I've also added similar checks in inode_{get/set}security().  Cheating from
> SELinux post_create_socket(), it does the same.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> Acked-by: Casey Schaufler <casey@schuafler-ca.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Correct the dislexio in the ack.

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  security/smack/smack_lsm.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff -puN
> security/smack/smack_lsm.c~smack-check-for-struct-socket-with-null-sk
> security/smack/smack_lsm.c
> --- a/security/smack/smack_lsm.c~smack-check-for-struct-socket-with-null-sk
> +++ a/security/smack/smack_lsm.c
> @@ -701,7 +701,7 @@ static int smack_inode_getsecurity(const
>  		return -EOPNOTSUPP;
>  
>  	sock = SOCKET_I(ip);
> -	if (sock == NULL)
> +	if (sock == NULL || sock->sk == NULL)
>  		return -EOPNOTSUPP;
>  
>  	ssp = sock->sk->sk_security;
> @@ -1280,10 +1280,12 @@ static void smack_to_secattr(char *smack
>   */
>  static int smack_netlabel(struct sock *sk)
>  {
> -	struct socket_smack *ssp = sk->sk_security;
> +	struct socket_smack *ssp;
>  	struct netlbl_lsm_secattr secattr;
>  	int rc = 0;
>  
> +	BUG_ON(sk == NULL);
> +	ssp = sk->sk_security;
>  	netlbl_secattr_init(&secattr);
>  	smack_to_secattr(ssp->smk_out, &secattr);
>  	if (secattr.flags != NETLBL_SECATTR_NONE)
> @@ -1331,7 +1333,7 @@ static int smack_inode_setsecurity(struc
>  		return -EOPNOTSUPP;
>  
>  	sock = SOCKET_I(inode);
> -	if (sock == NULL)
> +	if (sock == NULL || sock->sk == NULL)
>  		return -EOPNOTSUPP;
>  
>  	ssp = sock->sk->sk_security;
> @@ -1362,7 +1364,7 @@ static int smack_inode_setsecurity(struc
>  static int smack_socket_post_create(struct socket *sock, int family,
>  				    int type, int protocol, int kern)
>  {
> -	if (family != PF_INET)
> +	if (family != PF_INET || sock->sk == NULL)
>  		return 0;
>  	/*
>  	 * Set the outbound netlbl.
> _
> 
> Patches currently in -mm which might be from darwish.07@gmail.com are
> 
> origin.patch
> smack-check-for-struct-socket-with-null-sk.patch
> smack-check-for-struct-socket-with-null-sk-fix.patch
> git-kvm.patch
> git-x86.patch
>
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
> 
> -
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
