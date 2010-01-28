Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873Ab0A1WfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0A1WfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 17:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653Ab0A1We7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 17:34:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:16749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab0A1We6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 17:34:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eTRcSQNcMv9IAeUrmhCM7/lUWNjJKSDDf3Z4W4BL+Bgvu72qqO0NRTNd2gtZHvHVfi
         OE255NvLG+SpswbWukvPfS6bytXJS5B6RfkpFgQEaDruRcf88B7H0YCu8tz31gWzZTjJ
         rQumQmLZqxLx0uF7SjHlzT1kXR4fRXtePoCYI=
Date: Thu, 28 Jan 2010 23:34:47 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
Message-ID: <20100128223447.GC3109@del.dom.local>
References: <4B605D1B.60402@majjas.com>
 <20100127085049.5b5048e9@nehalam>
 <4B60707F.1000608@majjas.com>
 <20100127095614.14313677@nehalam>
 <4B608128.7090607@majjas.com>
 <4B6089C7.4010803@majjas.com>
 <4B61ADF1.7060705@majjas.com>
 <4B61BEA4.1030905@majjas.com>
 <20100128090835.0d93e53a@nehalam>
 <4B61DB79.4080703@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61DB79.4080703@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 01:46:17PM -0500, Michael Breuer wrote:
> On 1/28/2010 12:08 PM, Stephen Hemminger wrote:
> >--- a/lib/dma-debug.c	2010-01-20 15:22:55.919519883 -0800
> >+++ b/lib/dma-debug.c	2010-01-20 15:26:31.648895638 -0800
> >@@ -285,11 +285,9 @@ static struct dma_debug_entry *hash_buck
> >  	}
> >
> >  	/*
> >-	 * If we have multiple matches but no perfect-fit, just return
> >-	 * NULL.
> >+	 * If we have multiple matches but no perfect-fit
> >+	 * return best value and let caller deal with it.
> >  	 */
> >-	ret = (matches == 1) ? ret : NULL;
> >-
> >  	return ret;
> >  }
> >
> Ok - applied. Noise gone... however I'm not sure whether I'll be
> able to keep dma-debug going long enough to catch anything.
> num_free_entries keeps dropping... looks like entries are not freed.
> I'm running with a huge number for now & sky2 as the driver filter.
> Is there a reason that entries wouldn't be unmapped, or is
> dma-debug.c just not processing the unmap correctly?

Do you mean it's after this patch or earlier too? I think you might
use my sky2/receive_copy/pci_unmap_len patch instead to get rid of
this warning.

Btw, since 1000 was too much, maybe you could try copybreak=256 yet,
plus additional ping or some other source of shorter packets. And how
about trying this new switch?

Jarek P.
