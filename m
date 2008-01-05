Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYAESj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYAESj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 13:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbYAESjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 13:39:52 -0500
Received: from mga10.intel.com ([192.55.52.92]:32829 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756098AbYAESjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 13:39:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,249,1196668800"; 
   d="scan'208";a="273435176"
Message-ID: <477FCE61.5080606@linux.intel.com>
Date: Sat, 05 Jan 2008 10:37:21 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com> <477F2697.5050407@goop.org> <477FC613.7020807@linux.intel.com> <477FC78F.6060109@linux.intel.com>
In-Reply-To: <477FC78F.6060109@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>> So... call me unconvinced for now. There's 30 Kb on the table with the 
>> easy, obviously safe
>> transform, and maybe another 1Kb with the much more tricky trapping 
>> scenario, but only
>> for the vmlinux case; the module case seems to be a loss instead.
>>
>>
> Eh I have to retract my math here; I used a slightly older version of 
> the WARN_ON patch series.
> (before Ingo's suggestion)
> In the new model, even at 1024 the out of line WARN_ON function call is 
> smaller than the BUG_ON method.
> 
> So I think that at least for x86, it's a loss to do what you suggest....
> 


if people wonder where this comes from:
the BUG_ON code sequence is 13 bytes, the WARN_ON sequence
is 24 bytes, so 11 bytes longer. HOWEVER, the BUG_ON approach
also needs 12 bytes of data (20 on 64 bit) per bug, a nett loss
of 1 byte on 32 bit x86. (plus some general overhead for storing
sections as such, but that scales per ELF file, not per BUG_ON instance)

