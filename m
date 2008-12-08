Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbYLHJg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbYLHJg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 04:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYLHJgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 04:36:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56736 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYLHJgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 04:36:49 -0500
Message-ID: <493CEAA0.50201@jp.fujitsu.com>
Date: Mon, 08 Dec 2008 18:36:32 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>	 <493AE770.5030507@shaw.ca>	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>	 <493AF2EA.4030601@shaw.ca>	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>	 <493B4242.1040202@shaw.ca>	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>	 <20081207141337.588aede5@infradead.org>	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>	 <493CCFE4.2080802@jp.fujitsu.com> <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
In-Reply-To: <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giangiacomo Mariotti wrote:
> I still don't quite understand the logic behind this exception. It
> happens always only once per boot, right after booting always at [
> 301.7320xx], which clearly means that it's always triggered by the
> same instruction/s. It's about a "Generic CACHE Level-2 Data-Write
> Error", yet after that moment it never happens again until the next
> boot at the same relative time. The cache has an hardware problem, the
> process context is corrupted, but still after that single message I
> don't have any problem, my system works normally, even under very high
> pressure on cpu and memory. Is this normal? Should I try to limit the
> number of cpu used to only 1(cpu0) on bios and disable hyperthreading?
> That way I'd have a single physical and logical cpu, so probably if it
> has an hardware problem on the cache, the heaven will fall?

IIRC, this error is not what happen on the time [301.7320xx] during
boot, but happen before the boot.  Since the record says "Processor
context corrupt," MCE handler should call panic(or do something stop
the system) if the context actually corrupted during the boot.

In other words, it seems that 1) the error was recorded at last time
when your machine crashed unexpectedly(by cosmic-ray etc.) and not cleared
yet, or 2) your machine is doing something wrong in every reset/poweroff.

Could you try "mce=nobootlog" boot option?

Thanks,
H.Seto

