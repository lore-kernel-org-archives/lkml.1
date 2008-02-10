Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbYBJVNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbYBJVNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYBJVNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:13:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:26776 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYBJVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:13:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ht6XEfywhdJlwGfsTbrzaBt5O3LXTGVa5myYbKV25VzfdkW00adVewGLOj/bNAZ9JUtvs6c/70mcZQsXp3hRGsJT9DbZHcwBOsGor6595TStE/sl+EFpr5TZj8R6EozXfPcn+afvN54JHcTHdkzw23vdGMevypU5+F+FwR+e3I0=
Date: Mon, 11 Feb 2008 00:12:58 +0300
To: Julia Lawall <julia@diku.dk>
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com,
       lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 8/8] : Use FIELD_SIZEOF
Message-ID: <20080210211258.GE1754@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0802102115100.23906@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802102115100.23906@ask.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 09:16:04PM +0100, Julia Lawall wrote:
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -618,7 +618,7 @@ static inline int param_type2af(__be16 t
>  static inline int sctp_sanity_check(void)
>  {
>  	SCTP_ASSERT(sizeof(struct sctp_ulpevent) <=
> -		    sizeof(((struct sk_buff *)0)->cb),
> +		    FIELD_SIZEOF(struct sk_buff, cb),
>  		    "SCTP: ulpevent does not fit in skb!\n", return 0);
>  
>  	return 1;

Same here. Use BUILD_BUG_ON instead.
