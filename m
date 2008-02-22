Return-Path: <linux-kernel-owner+w=401wt.eu-S1764900AbYBVD7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764900AbYBVD7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 22:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbYBVD7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 22:59:38 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63357 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYBVD7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 22:59:37 -0500
Date: Thu, 21 Feb 2008 21:59:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Configure MSI-X vectors to target different CPUs
In-reply-to: <fa.Q1ZK6K82hcGwyp7RFiD9BqBU0CQ@ifi.uio.no>
To: caiying@yahoo.com
Cc: linux-kernel@vger.kernel.org
Message-id: <47BE4892.6050904@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Q1ZK6K82hcGwyp7RFiD9BqBU0CQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

caiying@yahoo.com wrote:
> Hi,
> 
> In MSI-HOWTO, it's said:
> 
> "Using MSI enables the device functions to support two or more vectors, which can be configured to target different CPUs to increase scalability."
> 
> So how can I set up MSI-X vectors to target different CPUs? I want to allocate the same number of MSI-X vectors as CPUs, and equally distribute them to every CPU.
> 
> Is it automatically done by Linux when I call pci_enable_msix()? If yes, how? If not, what should I do? My guess is to set the affinity of the interrupts manually. Am I right?
> 
> Please CC'ed me (caiying@yahoo.com) answers/comments  in response to this posting. 
> 
> Thanks,
> Ying

If the device actually supports multiple vectors (not all do), I think 
they should show up as separate interrupts in /proc/interrupts and you 
can either set the affinity manually, or maybe irqbalance is smart 
enough for this.

Careful, though, as in some cases this may reduce performance due to 
causing more cache line bouncing between CPUs.
