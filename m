Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbYEFTt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbYEFTt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907AbYEFTtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:49:43 -0400
Received: from mga06.intel.com ([134.134.136.21]:21234 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932123AbYEFTtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,445,1204531200"; 
   d="scan'208";a="278512446"
Message-ID: <4820B64D.4000805@linux.intel.com>
Date: Tue, 06 May 2008 12:49:33 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x54()
References: <4819078C.9080405@gmail.com>	<48190844.5080804@linux.intel.com>	<48190DBB.9020102@gmail.com>	<20080430002727.00db8e63@linux.intel.com>	<481A4636.8050209@gmail.com> <20080501043313.02205bbd@linux.intel.com> <481CF3B1.2020307@gmail.com>
In-Reply-To: <481CF3B1.2020307@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> Arjan van de Ven wrote:
>> \
>>> Does that help?
>>
>> somewhat. If you still have your source tree, can you do
>>
>> make kernel/panic.s and send that file to me as well?
>> (offlist is fine)
>>
> 
> I didn't have the source tree around, but I created the tree+config, and 
> here is what I get (I believe it is not too big for the list):
> 

interesting; somehow gcc does NOT put stack-protector in place despite it being
told so with -fstack-protector-all.

# -fno-common -funit-at-a-time -fstack-protector -fstack-protector-all
# -fno-asynchronous-unwind-tables -fno-omit-frame-pointer
# -fno-optimize-sibling-calls -fverbose-asm -fstack-protector
# -fstack-protector


this is weird; something is adding ANOTHER -fstack-protector to the (effective) gcc
flags.. which might be overriding the -fstack-protector-all setting.

I wonder if this is a distro special ;(
