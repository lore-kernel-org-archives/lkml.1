Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYFCFW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYFCFW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 01:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYFCFWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 01:22:05 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:31174 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbYFCFWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 01:22:04 -0400
Date: Tue, 3 Jun 2008 08:21:46 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, alexisb@us.ibm.com, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] x86 calgary: fix handling of devces that aren't
	behind the Calgary
Message-ID: <20080603052146.GI7011@il.ibm.com>
References: <20080531133114P.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531133114P.tomof@acm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 01:31:33PM +0900, FUJITA Tomonori wrote:

> The calgary code can give drivers addresses above 4GB which is very
> bad for hardware that is only 32bit DMA addressable:
> 
> http://lkml.org/lkml/2008/5/8/423
> 
> This patch tries to fix the problem by using per-device
> dma_mapping_ops support. This fixes the calgary code to use swiotlb
> or nommu properly for devices which are not behind the
> Calgary/CalIOC2.
> 
> With this patch, the calgary code sets the global dma_ops to swiotlb
> or nommu, and the dma_ops of devices behind the Calgary/CalIOC2 to
> calgary_dma_ops. So the calgary code can handle devices safely that
> aren't behind the Calgary/CalIOC2.

This seems a little backward to me. I thought we were going to get rid
of the global dma_ops? If not, assuming going through the global one
would be more efficient, Calgary should be the global one and
nommu/swiotlb should be used on devices that do not have translation
enabled. The reason why is that the majority of devices on a Calgary
system, assuming Calgary is in use, will have translation enabled.

In general the patch looks good, barring the point above. We'll give
it a spin on some Calgary/CalIOC2 machines.

Cheers,
Muli


