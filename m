Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbYB1VTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbYB1VTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761082AbYB1VTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:19:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760149AbYB1VTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:19:10 -0500
Message-ID: <47C72432.3010606@zytor.com>
Date: Thu, 28 Feb 2008 13:14:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
 to 1MB
References: <20080224174605.GA21661@mailshack.com>	 <47C22568.1010405@zytor.com>	 <1203958478.20033.1239002461@webmail.messagingengine.com>	 <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com>	 <20080228131341.GA25213@mailshack.com>	 <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1204233131.28798.12.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Thu, 2008-02-28 at 14:28 +0100, Alexander van Heukelum wrote:
>> Instead of using early reservations inside the kernel code,
>> we could use the realmode code to modify the e820 memmap.
>> This patch shows what that would look like. I have not looked
>> at the case where the BIOS does not provide an e820 memmap
>> yet. Probably a full solution would need to create a fake
>> e820 memmap in that case.
> 
> An e820 is already faked up in machine_specific_memory_setup() if one
> doesn't already exist.
> 
>> Comments?
> 
> This won't work for Xen since the real-mode code never runs there. I
> think it could be fixed in xen_memory_setup() though if native goes down
> this route.
> 

s/could/should/.

You need to set up your memory map more sensibly; it's not just the 
kernel, user space tries to access these areas too.

	-hpa
