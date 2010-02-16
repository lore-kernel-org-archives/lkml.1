Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab0BPW32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:29:28 -0500
Received: from mga06.intel.com ([134.134.136.21]:64019 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933145Ab0BPW30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:29:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,486,1262592000"; 
   d="scan'208";a="493015170"
Message-ID: <4B7B1C40.8070208@linux.intel.com>
Date: Tue, 16 Feb 2010 23:29:20 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu>
In-Reply-To: <20100216204732.GA2301@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Please work with Mauro on the Nehalem EDAC bits, they seem rather advanced to
> me for v2.6.34, and _far_ cleaner and more capable as well. See those Intel
> support bits at:

Hi Ingo,

core_i7 and EDAC has nothing to do with this code and
it has nothing to do with the problem this patch is
solving.

This is for a different chip (xeon75xx)
which has a completely different memory subsystem
and reports memory errors in a completely different way
than xeon75xx/core_i7.

For core_i7/xeon55xx there is no additional event interface needed;
it's all supplied by the hardware on the existing interfaces.

The point of this code is to annotate the CE events on Xeon 75xx
and to implement specific backend actions (page offlining, triggers)
based on specific events. These backend actions are already implemented
on 55xx without additional changes (no need for EDAC)

EDAC does not provide an event interface that can
be polled, just counts, so this cannot be done with EDAC.
It's simply a topology enumeration with error counts.
mcelog is not a topology interface, it's a event
notification mechanism.

EDAC and mcelog are orthogonal, they don't solve the same
problem.

So your nack is based on incorrect assumptions and doesn't make
sense. What you're asking for cannot be done with current
EDAC as far as I know.

-Andi
