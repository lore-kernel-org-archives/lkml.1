Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbXFIOGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbXFIOGB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 10:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbXFIOFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 10:05:53 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2696 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXFIOFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 10:05:52 -0400
Message-ID: <466AB3CC.5020802@shadowen.org>
Date: Sat, 09 Jun 2007 15:06:04 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Joel Schopp <jschopp@austin.ibm.com>,
       Dan Williams <dan.j.williams@intel.com>
CC: rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: add an exclusion for 'for_each' helper macros
References: <20070608171105.7391.40550.stgit@dwillia2-linux.ch.intel.com> <466995DB.6080703@austin.ibm.com>
In-Reply-To: <466995DB.6080703@austin.ibm.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Schopp wrote:
> 
> Dan Williams wrote:
>> checkpatch currently complains about macros like the following:
>>
>> #define for_each_dma_cap_mask(cap, mask) \
>>     for ((cap) = first_dma_cap(mask);       \
>>         (cap) < DMA_TX_TYPE_END;        \
>>         (cap) = next_dma_cap((cap), (mask)))
>>
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> I'd like it if this patch updated Chapter 12 of
> Documentation/CodingStyle as well. That section is where the rule to
> check came from and it would be nice for it to mention the exception to
> the rule as well.
> 
> 
> 

The actual restriction is on statements not on lines it seems:

"Macros with multiple statements should be enclosed in a do - while block"

So if this is only a single statement it is safe without a "container".
 I have a patch cooked up here which works out if there are more than
one statement which seems to do the trick.

Dan, thanks for the report.

-apw
