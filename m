Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbZHETjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbZHETjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZHETjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:39:47 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:27299 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751246AbZHETjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:39:47 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: Kj9LjyMVM1m4vJPRRXOvDKTH7nTlVnfaSGCq4gj47Sq4i_LqX3AJ.iDyqYwVpefZuy6OYbzsxlH1aDzKCGKVPwUwL7ZDjb6NTbjDd1haly9lz.WjSd9jDeIuR39C_ZpPZTnk6vKvFOEOHa0aLbHBP5V4iyP3lTL220Un1fBdUEg_rR0NeqZ7ZO81qSZFf6TXLC_Vh2RZSkUVnMA3Q68RrKwcfygQECxhESJv8tPl7O5Y2OUKjAKsbe4n4Jvv6nvVviga2py1R15Lsvqgkw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A79DFAF.2010605@schaufler-ca.com>
Date: Wed, 05 Aug 2009 12:38:23 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] security/smack: Use AF_INET for sin_family field
References: <Pine.LNX.4.64.0908051434340.20453@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0908051434340.20453@pc-004.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Elsewhere the sin_family field holds a value with a name of the form
> AF_..., so it seems reasonable to do so here as well.  Also the values of
> PF_INET and AF_INET are the same.
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> struct sockaddr_in sip;
> @@
>
> (
> sip.sin_family ==
> - PF_INET
> + AF_INET
> |
> sip.sin_family !=
> - PF_INET
> + AF_INET
> |
> sip.sin_family =
> - PF_INET
> + AF_INET
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

Yes, this is a correction. Thank you.


> ---
>  security/smack/smack_lsm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -u -p a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2464,7 +2464,7 @@ static int smack_socket_sendmsg(struct s
>  	/*
>  	 * Perfectly reasonable for this to be NULL
>  	 */
> -	if (sip == NULL || sip->sin_family != PF_INET)
> +	if (sip == NULL || sip->sin_family != AF_INET)
>  		return 0;
>  
>  	return smack_netlabel_send(sock->sk, sip);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   

