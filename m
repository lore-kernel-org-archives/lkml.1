Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbYFBC1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbYFBC1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYFBC1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:27:42 -0400
Received: from mga06.intel.com ([134.134.136.21]:39581 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753438AbYFBC1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:27:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,575,1204531200"; 
   d="scan'208";a="389249135"
Message-ID: <48435A89.2090004@linux.intel.com>
Date: Sun, 01 Jun 2008 19:27:21 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Hugh Dickins <hugh@veritas.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
References: <48402DAA.60202@linux.intel.com> <Xine.LNX.4.64.0806020955570.8594@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0806020955570.8594@us.intercode.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Fri, 30 May 2008, Arjan van de Ven wrote:
> 
>> Rank 4: task_has_capability (warning)
>> 	Reported 181 times (202 total reports)
>> 	[out of tree] Bug in the proprietary firegl driver
>> 	warning only shows up in tainted kernels
>> 	This warning was last seen in version 2.6.25.3, and first seen in
>> 	2.6.25.
>> 	More info:
>> 	http://www.kerneloops.org/searchweek.php?search=task_has_capability
> 
> This is a shining example of why people should avoid binary drivers.  I'd 
> guess that the bug is related to the new 64-bit capability code.
> 
> It'd be really interesting to know what this driver is doing with 
> capabilities in the first place.

it's easy; it's making the user root via the following function:

void ATI_API_CALL KCL_PosixSecurityCapSetEffectiveVector(KCL_TYPE_Cap cap)
{
	capt_t(current->cap_effective) = cap;
}

