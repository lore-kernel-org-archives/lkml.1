Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0BVHjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 02:39:06 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35222 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0BVHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 02:39:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B823459.6020308@jp.fujitsu.com>
Date: Mon, 22 Feb 2010 16:38:01 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com>
In-Reply-To: <4B7B1C40.8070208@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/02/17 7:29), Andi Kleen wrote:
> This is for a different chip (xeon75xx)
> which has a completely different memory subsystem
> and reports memory errors in a completely different way
> than xeon75xx/core_i7.
> 
> For core_i7/xeon55xx there is no additional event interface needed;
> it's all supplied by the hardware on the existing interfaces.
> 
> The point of this code is to annotate the CE events on Xeon 75xx
> and to implement specific backend actions (page offlining, triggers)
> based on specific events. These backend actions are already implemented
> on 55xx without additional changes (no need for EDAC)

If my understanding is correct, your patch doesn't interact with xeon75xx
processor itself, but with the associated chip (I/O hub, aka Boxboro,
you abbreviated it to BXB) at least at first of all.

Then since MCE codes contain rather "generic, processor oriented" stuffs
while EDAC codes contain relatively "specific, chipset oriented" stuffs,
people can suppose that this "arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c"
could be implemented in different way and the file could have a different
name like "drivers/edac/i7500_edac.c" or so.

However the real issue is that I couldn't figure out why this code
requires new hook in the polling handler, what is PFA, and what kind of
restriction let you to do so.  You noted that "The act of retrieving
the DIMM/PA information can take some time" but I'm not sure it is safe
even if poll handler is called via CMCI.

Anyway, Andi, could you point proper specification or datasheet to
know/check what you are going to do here?
Otherwise I could not distinguish your work from black magic...


Thanks,
H.Seto



