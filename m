Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZAPILT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZAPILT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZAPILG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:11:06 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:31212 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754177AbZAPILF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:11:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y9DLtm5MgetEsX/THn7+UidMdXYkTAObswbXAGfjpw+pIIfx8APgeM1UpNSbFuWZw8vwXwQEwcWGI/IIZmqJ6UpT07DaY2hiFliV0kdV3MAPmOmcz8SdEwX3KEwMmsImQyRv6fEmh1Uz+/DXB5rrtCxZENaJenpGWtJ9QeiLmx4=  ;
X-YMail-OSG: jrAsRlsVM1lrmz5cWy8PqhWM5AkRyaEQP6HLVgKAVIYl9q8YtCmBZ3O6MRNAvznLBiPmsmfC4zyhOkKfs03fxYt8VQNvtkrjCerzr2Vljz6QiKUbVgwtXFyYpl_cggHRmFD37zu1Xggx_.I5rCUzzAV9srkXXv3HPgMPco_PiRqi8voeoLFtyWd14Met1T.wcdaIwaqCk7DUrL9mCg2ziRw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH] gpiolib: request fix V2
Date: Fri, 16 Jan 2009 00:11:01 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       akpm@linux-foundation.org
References: <20090116073406.11946.95332.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090116073406.11946.95332.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901160011.01325.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Fix request related issue in gpiolib:
>  - fix request-already-requested handling in gpio_request()
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Appropriate for 2.6.28-stable.


> ---
> 
>   Changes since V1:
>   - dropped the gpio_direction_input/output fixes
> 
>  drivers/gpio/gpiolib.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- 0001/drivers/gpio/gpiolib.c
> +++ work/drivers/gpio/gpiolib.c	2008-12-26 13:09:50.000000000 +0900
> @@ -789,6 +789,7 @@ int gpio_request(unsigned gpio, const ch
>  	} else {
>  		status = -EBUSY;
>  		module_put(chip->owner);
> +		goto done;
>  	}
>  
>  	if (chip->request) {
> 
> 


