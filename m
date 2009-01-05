Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZAEIr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZAEIr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 03:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZAEIrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 03:47:13 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34276 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZAEIrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 03:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q7AiE8Mq8iMU/IoYOdeGaSYnbZy8KsepYo/QF48MYmawtBxD1kb7WLvdEu13Pera5w
         xTiYVSUxuBOx9dwCOKlD1Nv7GWn69ktlC8bY+G8/MRaWMjwYVAmlF94PEBvbs/a3NR88
         YWGvIbpQVG7G3wDnMUpDod6E1/kn03vaLMRsM=
Date: Mon, 5 Jan 2009 09:47:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090105084703.GA5741@nowhere>
References: <20090104092430.7ffd2c41@infradead.org> <1231135294.8179.45.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231135294.8179.45.camel@nigel-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 05:01:34PM +1100, Nigel Cunningham wrote:
> Hi Arjan.
> 
> Great work, and valuable too. I'm just wondering if the header file name
> "async.h" is a little too generic? Something like async_init.h perhaps?
> 
> Regards,
> 
> Nigel
>

Hi Nigel,

That's what I thought too at first. But I guess there could be other
users of these async functions than the initcalls.
It looks like out of order workqueues that can synchronize themselves.
It seems a bit more costly than workqueues (since the concept comes along
a loop of creation/destroying of several threads) but more efficient for the
same reason as the number of active threads adapts to the number of CPU and jobs to perform.
The purpose is not the same. But I guess it's more reliable
than workqueues for pathes that require mutiple parallel jobs which need
to locally synchronize on critical pathes.

