Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbXKTUnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbXKTUnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761402AbXKTUnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:43:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39715 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760607AbXKTUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:43:36 -0500
Message-ID: <474346DE.5050305@zytor.com>
Date: Tue, 20 Nov 2007 12:43:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       travis@sgi.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
References: <20071120011132.143632442@sgi.com> <200711200416.32954.ak@suse.de> <Pine.LNX.4.64.0711191945260.21813@schroedinger.engr.sgi.com> <200711201301.25373.ak@suse.de>
In-Reply-To: <200711201301.25373.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tuesday 20 November 2007 04:50, Christoph Lameter wrote:
>> On Tue, 20 Nov 2007, Andi Kleen wrote:
>>> I might be pointing out the obvious, but on x86-64 there is definitely
>>> not 256TB of VM available for this.
>> Well maybe in the future.
> 
> That would either require more than 4 levels or larger pages
> in page tables.
> 
>> One of the issues that I ran into is that I had to place the cpu area
>> in between to make the offsets link right.
> 
> Above -2GB, otherwise you cannot address them
> 

This limitation shouldn't apply to the percpu area, since gs_base can be 
pointed anywhere in the address space -- in effect we're always indirect.

Obviously the offsets *within* the percpu area has to be in range (±2 GB 
per cpu for absolute offsets, slightly smaller for %rip-based addressing 
-- obviously judicious use of an offset for gs_base is essential in the 
latter case).

Thus you want the percpu areas below -2 GB where they don't interfere 
with modules or any other precious address space.

	-hpa
