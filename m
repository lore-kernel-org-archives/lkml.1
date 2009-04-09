Return-Path: <linux-kernel-owner+w=401wt.eu-S936904AbZDIWir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936904AbZDIWir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbZDIWid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:38:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44769 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZDIWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:38:32 -0400
Message-ID: <49DE78E4.2060201@garzik.org>
Date: Thu, 09 Apr 2009 18:38:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Marin Mitov <mitov@issp.bas.bg>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Silencing warning: 'host' may be used uninitialized in
 this function
References: <200904100133.58556.mitov@issp.bas.bg>
In-Reply-To: <200904100133.58556.mitov@issp.bas.bg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marin Mitov wrote:
> Hi all,
> 
> I do not know if that is worth the effort, but...
> 
> Silencing:  warning: 'host' may be used uninitialized in this function
> It is a false positive.
> 
> The patch is against 2.6.30-rc1, but should apply to 2.6.29(.1) too.
> 
> Signed-off-by: Marin Mitov mitov@issp.bas.bg
> ================================================
> --- a/drivers/ata/sata_via.c	2009-04-05 22:59:26.000000000 +0300
> +++ b/drivers/ata/sata_via.c	2009-04-06 00:07:25.000000000 +0300
> @@ -566,7 +566,7 @@
>  	static int printed_version;
>  	unsigned int i;
>  	int rc;
> -	struct ata_host *host;
> +	struct ata_host *host = host;
>  	int board_id = (int) ent->driver_data;
>  	const unsigned *bar_sizes;

we use the uninitialized_var() macro for false positives.

	Jeff



