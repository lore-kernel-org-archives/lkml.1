Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZFBI6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZFBI6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZFBI55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:57:57 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:23530 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbZFBI54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:57:56 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432R98dR1805M873fnzz1202hzzz32i6bh17ch43j)
X-FB-SS: 5,
X-WSS-ID: 0KKLSWB-04-7EI-01
Date: Tue, 2 Jun 2009 10:57:37 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] dma-debug: add dma_debug_driver kernel command line
Message-ID: <20090602085736.GM4062@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com> <1243523971-12681-4-git-send-email-joerg.roedel@amd.com> <20090601150813.84c932f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090601150813.84c932f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Jun 2009 08:57:37.0390 (UTC) FILETIME=[2D5858E0:01C9E360]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 03:08:13PM -0700, Andrew Morton wrote:
> On Thu, 28 May 2009 17:19:30 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > This patch add the dma_debug_driver= boot parameter to enable the driver
> > filter for early boot.
> > 
> 
> Please always update Documentation/kernel-parameters.txt when adding
> new boot options.
> 
> > +static int __init parse_dma_debug_driver(char *str)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < NAME_MAX_LEN - 1; ++i, ++str) {
> > +		current_driver_name[i] = *str;
> > +		if (*str == ' ' || *str == '\t' || isspace(*str) || *str == 0)
> 
> The comparisons with ' ' and '\t' are unneeded, surely?
> 
> > +			break;
> > +	}
> > +	current_driver_name[i] = 0;
> > +
> > +	if (current_driver_name[0])
> > +		printk(KERN_INFO "DMA-API: enable driver filter for "
> > +				 "driver [%s]\n", current_driver_name);
> > +
> > +
> > +	return 1;
> > +}
> > +__setup("dma_debug_driver=", parse_dma_debug_driver);
> 
> The whole thing seems a bit overdone - take a look at some other __setup
> functions, see what they're doing.  None of them bother looking for
> spaces in the input - higher level code took care of that.
> 
> It's conventional for the name of a __setup function to end in "_setup".

Ok, thanks. Will check again here.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

