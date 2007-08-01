Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbXHAAyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbXHAAyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXHAAyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:54:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57061 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXHAAyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:54:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46AFD99D.7040007@s5r6.in-berlin.de>
Date: Wed, 01 Aug 2007 02:53:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: jack@hawkeye.stone.uk.eu.org
CC: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Patch 05/16] Remove unnecessary kmalloc casts in the drivers
 subdirectory.
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125440.305176000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125440.305176000@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jack@hawkeye.stone.uk.eu.org wrote:
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -2034,7 +2034,7 @@ static int init_dev(struct tty_driver *d
>  	}
>  
>  	if (!*tp_loc) {
> -		tp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
> +		tp = kmalloc(sizeof(struct ktermios),
>  						GFP_KERNEL);
>  		if (!tp)
>  			goto free_mem_out;
> 

Looks like you can pull the "GFP_KERNEL);" into the same line as the
kmalloc.  IMO a cleanup patch shouldn't leave inexplicable linebreaks
and other whitespace strangeness behind.
-- 
Stefan Richter
-=====-=-=== =--- ----=
http://arcgraph.de/sr/
