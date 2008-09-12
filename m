Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbYILVRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbYILVRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYILVRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:17:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59815 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbYILVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:17:31 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
From: Andi Kleen <andi@firstfloor.org>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
	<20080912122031.eca8723e.akpm@linux-foundation.org>
	<86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com>
	<48CACD68.4050006@zytor.com>
Date: Fri, 12 Sep 2008 23:17:30 +0200
In-Reply-To: <48CACD68.4050006@zytor.com> (H. Peter Anvin's message of "Fri, 12 Sep 2008 13:13:28 -0700")
Message-ID: <87y71xqd1x.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Yinghai Lu wrote:
>> to see how wrong could be set by BIOS.
>>
>
> I'm starting to think that all this dumping of ACPI information needs
> to be put under a command-line option.

The majority of ACPI information at boot is related to interrupt
routing. While interrupt routing isn't that big a problem anymore
it used to be and when something goes wrong with it you often 
have a non booting system. I think it's safer to dump
it by default.

On the other hand there's quite some other information dumped
at boot that could be cut out. e.g. It doesn't really make 
much sense to dump the cache information of each CPU at boot
when that information can easily be gotten from user space
later.

I personally was also always sceptical of some of the
more detailed new memory map dumping, like those "nosave
memory" or the early reservation/early node/add_active_range output.
It's pretty much a direct function of the e820 map dumped earlier.
Also node information has now the dubious distinction to be 
the most redundantly dumped kernel information of all.

-Andi

---
ak@linux.intel.com
