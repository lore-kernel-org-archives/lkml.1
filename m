Return-Path: <linux-kernel-owner+w=401wt.eu-S1763532AbYBOJmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763532AbYBOJmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbYBOJmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:42:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48971 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbYBOJmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:42:01 -0500
Message-ID: <47B55EAC.10002@firstfloor.org>
Date: Fri, 15 Feb 2008 10:43:08 +0100
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
References: <20080214131317.GA27769@basil.nowhere.org>	 <20080214161218.GA28152@elte.hu>	 <1203050886.30010.19.camel@caritas-dev.intel.com>	 <20080215084827.GB25949@one.firstfloor.org> <1203067262.30010.34.camel@caritas-dev.intel.com>
In-Reply-To: <1203067262.30010.34.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> On Fri, 2008-02-15 at 09:48 +0100, Andi Kleen wrote:
>> On Fri, Feb 15, 2008 at 12:48:06PM +0800, Huang, Ying wrote:
>>> This patch has been tested on Intel x86 platform with EFI 32/64.
>> Can EFI_PAGE_SIZE ever be < 4k? If yes you would need to round up
>> first to linux page size before shifting.
> 
> Yes. It is needed. And md->virt_addr should be processed as follow:
> 
> md->virt_addr & PAGE_MASK
> 
> before fed into set_memory_*.

If you do that you also need to add the old offset into the page
to the size.

I just mention it because ioremap_change_attr() did that wrong
before my patch yesterday :)

-Andi

