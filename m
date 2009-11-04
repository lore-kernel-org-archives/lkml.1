Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbZKDQW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbZKDQW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbZKDQW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:22:27 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35671 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbZKDQW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:22:26 -0500
Message-ID: <4AF1AA37.5060500@cs.wisc.edu>
Date: Wed, 04 Nov 2009 10:22:15 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: James.Bottomley@suse.de, Karen Xie <kxie@chelsio.com>,
       james.smart@emulex.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -2nd repost 2/4] SCSI: remove unnecessary NULL test
References: <1257351321-8281-1-git-send-email-jirislaby@gmail.com> <1257351321-8281-2-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1257351321-8281-2-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Karen and removing adaptec since this is chelsio's driver.

Jiri Slaby wrote:
> Stanse found that c3cn is poked many times around in
> cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.
> 
> Remove the test.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: James E.J. Bottomley <James.Bottomley@suse.de>
> ---
>  drivers/scsi/cxgb3i/cxgb3i_pdu.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> index 7091050..64bbc28 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
> @@ -461,10 +461,8 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
>  		skb = skb_peek(&c3cn->receive_queue);
>  	}
>  	read_unlock(&c3cn->callback_lock);
> -	if (c3cn) {
> -		c3cn->copied_seq += read;
> -		cxgb3i_c3cn_rx_credits(c3cn, read);
> -	}
> +	c3cn->copied_seq += read;
> +	cxgb3i_c3cn_rx_credits(c3cn, read);
>  	conn->rxdata_octets += read;
>  
>  	if (err) {

Looks ok to me. The null check was useless since we access c3cn all over 
the function and would have oopsed before we got there.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
