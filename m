Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbYFHUQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbYFHUQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYFHUQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:16:38 -0400
Received: from mx.mips.com ([63.167.95.198]:41726 "EHLO dns0.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbYFHUQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:16:37 -0400
X-Greylist: delayed 1458 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jun 2008 16:16:37 EDT
Message-ID: <484C38A6.7080503@mips.com>
Date: Sun, 08 Jun 2008 21:53:10 +0200
From: "Kevin D. Kissell" <kevink@mips.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Luke -Jr <luke@dashjr.org>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
Subject: Re: bcm33xx port
References: <200806072113.26433.luke@dashjr.org> <200806072332.06460.luke@dashjr.org> <Pine.LNX.4.55.0806081332560.15673@cliff.in.clinika.pl> <200806081357.02601.luke@dashjr.org>
In-Reply-To: <200806081357.02601.luke@dashjr.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luke -Jr wrote:
> On Sunday 08 June 2008, Kevin D. Kissell wrote:
>   
>> and (b) control being transferred to a block of memory that isn't actually
>> code, as can happen if exception vectors or global pointers-to-functions
>> aren't set up correctly, or if the kernel stack is being corrupted.   When
>> you say "the instruction in question is a store word", how do you know that? 
>>     
>
> The RI error spits out a bunch of info, including epc which presumably points 
> to the instruction causing the problem: ac85ffc0; this is 'sw a1,-64(a0)'
>   
But unless the processor itself is actually defective, there is no way that
a  SW instruction can cause an RI exception.  Sometimes a kernel crash
is so violent that the kernel stack frame cannot be reliably decoded by
the crash dump code, and this would appear to be one of those cases.
I find the address of 0xac85ffc0 to be a bit suspicious, myself.  That's
a kseg1 (non-cacheable identity map) address for physical address
0x0c85ffc0, which would be legitimate (though suspicious) if you had
256MB of RAM, but the boot log quote you posted earlier suggests
that you've only got 16M.  Is there really memory of some kind at
that address?  Are you calling routines in a boot ROM from Linux?

Debugging Linux kernel crashes is probably not the best way to learn
the MIPS privileged resource architecture.  I'd strongly recommend
http://www.amazon.com/See-MIPS-Second-Dominic-Sweetman/dp/0120884216/

          Regards,

          Kevin K.
