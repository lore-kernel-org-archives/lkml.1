Return-Path: <linux-kernel-owner+w=401wt.eu-S934525AbXGRQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525AbXGRQfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932777AbXGRQfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:35:33 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49835 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761027AbXGRQfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:35:32 -0400
Message-ID: <469E410C.50302@gmail.com>
Date: Wed, 18 Jul 2007 18:34:20 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andrea Arcangeli <andrea@suse.de>, Dave Hansen <haveblue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com> <20070717193308.GD25301@v2.random> <20070718133222.GM11781@holomorphy.com>
In-Reply-To: <20070718133222.GM11781@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2007 03:32 PM, William Lee Irwin III wrote:

> On Tue, Jul 17, 2007 at 09:33:08PM +0200, Andrea Arcangeli wrote:

>> kmalloced 4k naturally aligned object into userland). I wouldn't call
>> it tail packing, it's more a fine-granular pagecache with the already
>> available kmalloc granularities. That will maximize pagecache
>> utilization with read syscall for hg/git compared to current 2.6.22
>> plus memory will be allocated faster in 64k chunks etc... Ideally it
>> should be possible to disable the finer-granular-kmalloc-pagecache on
>> the big irons with lots of memory and only working with big files.
> 
> In any event, that is a sound strategy for mitigating internal
> fragmentation of pagecache, though internal fragmentation of anonymous
> memory has more severe consequences and is less easily mitigated.

I suppose low/highmem is an issue on x86? I was reading the tail packing 
paper Dave posted a link to earlier:

http://kernel.org/pub/linux/kernel/people/shaggy/OLS-2006/kleikamp.pdf

It says that highmem is not an issue due to no such thing as highmem even 
existing on the machines with support for larger hard pagesizes, but this 
wouldn't hold for soft pages. Sort of went "damn" in an x86 context upon 
reading that.

Rene.

