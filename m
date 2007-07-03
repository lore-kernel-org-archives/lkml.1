Return-Path: <linux-kernel-owner+w=401wt.eu-S1759877AbXGCOyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759877AbXGCOyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbXGCOyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:54:06 -0400
Received: from smtp.webon.net ([213.188.24.21]:47100 "EHLO smtp.webon.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175AbXGCOyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:54:04 -0400
X-Greylist: delayed 880 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 10:54:03 EDT
Message-ID: <468A5F89.70900@sourcepoet.org>
Date: Tue, 03 Jul 2007 16:39:05 +0200
From: Morten Helgesen <morten@sourcepoet.org>
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] genericserial: Remove bogus optimisation check and dead
 code paths
References: <20070703152021.6eb8013d@the-village.bc.nu>
In-Reply-To: <20070703152021.6eb8013d@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

[...snip...]
> @@ -75,11 +64,11 @@
>  	if (! (port->flags & ASYNC_INITIALIZED)) return;
>  
>  	/* Take a lock on the serial tranmit buffer! */
> -	LOCKIT;
> +	mutex_lock(& port->port_write_mutex);
>   

^ Contains additional whitespace.

>  	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
>  		/* Sorry, buffer is full, drop character. Update statistics???? -- REW */
> -		RELEASEIT;
> +		mutex_unlock(&port->port_write_mutex);
>  		return;
>  	}
>  
> @@ -87,13 +76,11 @@
>   
[...snip...]

== Morten
