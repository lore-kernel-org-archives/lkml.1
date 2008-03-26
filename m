Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbYCZHKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbYCZHKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYCZHKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:10:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59127 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbYCZHKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:10:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E9F6BB.4010601@s5r6.in-berlin.de>
Date: Wed, 26 Mar 2008 08:09:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: plug dma memory leak in AR handler
References: <200803251647.16227.jwilson@redhat.com>
In-Reply-To: <200803251647.16227.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> @@ -605,7 +606,7 @@ static void ar_context_tasklet(unsigned long data)
>  			buffer = handle_ar_packet(ctx, buffer);
>  
>  		dma_free_coherent(ohci->card.device, PAGE_SIZE,
> -				  buffer, buffer_bus);
> +				  start, start_bus);
>  		ar_context_add_page(ctx);

On the other hand, why do we free a page + allocate a page?
Why don't we re-initialize and re-add the old page?
-- 
Stefan Richter
-=====-==--- --== ==-=-
http://arcgraph.de/sr/
