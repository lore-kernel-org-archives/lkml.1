Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbXH3N7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbXH3N7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbXH3N7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:59:40 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51383 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbXH3N7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:59:39 -0400
Message-ID: <46D6CC35.90207@aitel.hist.no>
Date: Thu, 30 Aug 2007 15:55:01 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Daniel Drake <ddrake@brontes3d.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: speeding up swapoff
References: <fa.j/pO3mTWDugTdvZ3XNr9XpvgzPQ@ifi.uio.no> <fa.ed9fasZXOwVCrbffkPQTX7G3a7g@ifi.uio.no> <fa./NZA3biuO1+qW5pW8ybdZMDWcZs@ifi.uio.no> <46D61F48.5090406@shaw.ca>
In-Reply-To: <46D61F48.5090406@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Daniel Drake wrote:
>> On Wed, 2007-08-29 at 07:30 -0700, Arjan van de Ven wrote:
>>>> My experiments show that when there is not much free physical memory,
>>>> swapoff moves pages out of swap at a rate of approximately 5mb/sec.
>>> sounds like about disk speed (at random-seek IO pattern)
>>
>> We are only using 'standard' seagate SATA disks, but I would have
>> thought much more performance (40+ mb/sec) would be reachable.
>
> Not if it is doing random seeks..
If the swap device is full, then there is no need for random
seeks as the swap pages can be read in disk order. A not
so full swap will skip over the unused areas, the time
needed should still be limited to the time needed for reading the
whole swap device.

If this optimization is worth it is another problem though.

Helge Hafting
