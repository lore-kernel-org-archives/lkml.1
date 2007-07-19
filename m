Return-Path: <linux-kernel-owner+w=401wt.eu-S936152AbXGSAyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936152AbXGSAyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbXGSAyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:54:39 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:39633 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbXGSAyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:54:38 -0400
Message-ID: <469EB604.50000@gmail.com>
Date: Thu, 19 Jul 2007 02:53:24 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@suse.de>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com> <20070717193308.GD25301@v2.random> <20070718133222.GM11781@holomorphy.com> <469E410C.50302@gmail.com> <20070718235035.GB29728@v2.random>
In-Reply-To: <20070718235035.GB29728@v2.random>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2007 01:50 AM, Andrea Arcangeli wrote:

> On Wed, Jul 18, 2007 at 06:34:20PM +0200, Rene Herman wrote:

>> It says that highmem is not an issue due to no such thing as highmem even 
>> existing on the machines with support for larger hard pagesizes, but this 
>> wouldn't hold for soft pages. Sort of went "damn" in an x86 context upon 
>> reading that.
> 
> Correct, but I'm not really sure if it worth worrying about x86
> missing this

Larger softpages would nicely solve the "1-page stacks are sometimes small" 
issue with 4KSTACKS on x86 that was discussed in another thread just now but 
without tail packing, the pagecache slack would be too high a price to pay 
given that loads that would actually benefit from it most definitely have 
moved to 64-bit (although I'd certainly still want to try 8K as well, and 
filesystems with larger blocksizes could be nice as well).

> furthermore it would still be possible to enable it on the very x86 low
> end (with regular 4k page size) that may worry to use up to the last byte
> of ram as cache for tiny files.

But, yes, that's true, and I wonder if !HIGHMEM x86 will in fact be "very 
low end" for long considering x86-64 is now _really_ here. Many people who 
want enough memory to need highmem have probably already made the switch, 
and in the embedded world, 896M (or 1G, or 2G with a adjusted split) is 
still decidely non-low end. Yet a PVR, say, could love 64K pages for VM and 
disk...

> To me using kmalloc for this looks quite ideal.

Certainly simplest...

Rene.

