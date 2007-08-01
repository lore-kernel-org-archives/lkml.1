Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXHAFfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXHAFfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 01:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXHAFfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 01:35:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:40910 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbXHAFfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 01:35:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Wo9celmE0ADM36Ee7HfK/KEeVi5dHdFGabOH6utIpEbY9vJ6upaUCvvc8hREuyi/FvU5YLMmpySKhvUKvdmVDArkAwNjcKZCSy6NhzXHdfaksPigHi1aNoNzAAehQXhyjRoOvMF44aDMy6bS8Nof4k5frIImjDxLOfQvvbjaC2Y=
Date: Wed, 1 Aug 2007 09:35:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
Message-ID: <20070801053509.GA5905@martell.zuzino.mipt.ru>
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 10:04:10PM +0530, Satyam Sharma wrote:
> Callers (especially "store" functions for sysfs or configfs attributes)
> that want to convert an input string to a number may often also want to
> check for simple input sanity or allowable range. strtol10_check_range()
> of netconsole does this, so extract it out into lib/vsprintf.c, make it
> generic w.r.t. base, and export it to the rest of the kernel and modules.

> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -335,9 +307,11 @@ static ssize_t store_enabled(struct netconsole_target *nt,
>  	int err;
>  	long enabled;
>  
> -	enabled = strtol10_check_range(buf, 0, 1);
> -	if (enabled < 0)
> +	enabled = strtol_check_range(buf, 0, 1, 10);
> +	if (enabled < 0) {
> +		printk(KERN_ERR "netconsole: invalid input\n");
>  		return enabled;
> +	}

Please, copy strtonum() from BSD instead. Nobody needs another
home-grown converter.

