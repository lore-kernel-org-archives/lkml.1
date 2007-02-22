Return-Path: <linux-kernel-owner+w=401wt.eu-S965029AbXBVAWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029AbXBVAWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965025AbXBVAWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:22:13 -0500
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:39475 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965029AbXBVAWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:22:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QfKPgckA9L57M29Z7UtEtKjmDHP+0+AlrX5Polw/QxTsOWX0IvCzn4k0lxzzpbEvmxEVDCMF3Cr+be7VUBF4d1HOGAdPuxoSmysO58OO0OM7ZIVTuQ50PPEj6MiWFJ6emnh4Ep4+TCsmy2oAclQI0FSvPRfYx3BStxExyiXEC20=  ;
X-YMail-OSG: VjJjJzgVM1l8Y1gnxuP5GbR2lbdgh_xdyU1GpcZRUq9Pml03dOd2EGZ_kB16ZDoHPS1jfXCCmo4LDxV8ARI_SzzqxxeM7bRs3xWYVvNTz3cs.WpSqjBfNBgd1_tBQ8X6TZA9WeJ3k6A-
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML - Fix 2.6.20 hang
Date: Thu, 22 Feb 2007 01:22:06 +0100
User-Agent: KMail/1.9.5
Cc: Jeff Dike <jdike@addtoit.com>, akpm@osdl.org, stable@vger.kernel.org,
       uml@ligatura.org, linux-kernel@vger.kernel.org
References: <20070215170713.GB5641@ccure.user-mode-linux.org>
In-Reply-To: <20070215170713.GB5641@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702220122.07414.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 18:07, Jeff Dike wrote:
> Signed-off-by: Jeff Dike <jdike@addtoit.com>
[...]
> @@ -331,10 +334,9 @@ void maybe_sigio_broken(int fd, int read
>
>  	sigio_lock();
>  	err = need_poll(&all_sigio_fds, all_sigio_fds.used + 1);
> -	if(err){
> -		printk("maybe_sigio_broken - failed to add pollfd\n");
> +	if(err)
>  		goto out;
> -	}
> +
>  	all_sigio_fds.poll[all_sigio_fds.used++] =
>  		((struct pollfd) { .fd  	= fd,
>  				   .events 	= read ? POLLIN : POLLOUT,
>
Was that removal wanted or it happened by mistake? That way, err is completely 
lost.
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
