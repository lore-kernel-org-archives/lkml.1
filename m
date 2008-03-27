Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbYC0SAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbYC0SAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760350AbYC0SAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:00:01 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.10]:57214 "EHLO
	mail15-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760342AbYC0SAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:00:00 -0400
X-Greylist: delayed 1717 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 14:00:00 EDT
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JYEGNS-02-6EU-01
Date: Thu, 27 Mar 2008 18:30:27 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Chris Snook <csnook@redhat.com>
Cc: Jack Steiner <steiner@sgi.com>, mingo@elte.hu, ak@suse.de,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Increase max physical memory size of x86_64
Message-ID: <20080327173027.GA26969@alberich.amd.com>
References: <20080321133157.GA10911@sgi.com> <20080325164154.GA5909@alberich.amd.com> <20080325165438.GA5298@sgi.com> <47E96876.3050206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E96876.3050206@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 27 Mar 2008 17:30:17.0067 (UTC) FILETIME=[391693B0:01C89030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 05:02:46PM -0400, Chris Snook wrote:
> Jack Steiner wrote:
>> On Tue, Mar 25, 2008 at 05:41:54PM +0100, Andreas Herrmann wrote:
>>> On Fri, Mar 21, 2008 at 08:31:57AM -0500, Jack Steiner wrote:
>>>> Increase the maximum physical address size of x86_64 system
>>>> to 44-bits. This is in preparation for future chips that
>>>> support larger physical memory sizes.
>>> Shouldn't this be increased to 48?
>>> AMD family 10h CPUs actually support 48 bits for the
>>> physical address.
>> You are probably correct but I don't work with AMD processors
>> and don't understand their requirements. If someone
>> wants to submit a patch to support larger phys memory sizes,
>> I certainly have no objections....
>
> The only advantage 44 bits has over 48 bits is that it allows us to 
> uniquely identify 4k physical pages with 32 bits, potentially allowing for 
> tighter packing of certain structures.  Do we have any code that does this, 
> and if so, is it a worthwhile optimization?

I've checked where those defines are used. If I didn't miss something
MAX_PHYSADDR_BITS isn't used at all on x86 and MAX_PHYSMEM_BITS is
used (directly or indirectly) in several other macros.

But basically it's just section_to_node_table which would increase to 2
or 4 MB depending on MAX_NUMNODES.  Using 44 bits this table is just
128 kB resp. 256 kB in size.

> Personally, I think we should support the full capability of the hardware, 
> but I don't have a 17 TB Opteron box to test with.

I don't have one either.
By adjusting some NB-registers it might be possible to configure
physical addresses larger than 40 or 44 bits though. (Even if the
machine has not more than 1 or 16 TB.) I'll verify whether this is
really possible.

At the moment I think it's best to leave the define as is (44 or 40
bit) as there is currently no practical benefit from increasing it to
48 bit.


Regards,

Andreas


