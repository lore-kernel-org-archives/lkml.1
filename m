Return-Path: <linux-kernel-owner+w=401wt.eu-S1765374AbYEAVLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765374AbYEAVLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760631AbYEAVLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:11:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759539AbYEAVLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:11:36 -0400
Message-ID: <481A31E2.2020800@zytor.com>
Date: Thu, 01 May 2008 14:10:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect v2
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <200804292025.58268.yhlu.kernel@gmail.com>	 <200805010100.34751.yhlu.kernel@gmail.com>	 <200805011157.00693.yhlu.kernel@gmail.com>	 <481A1D3A.5040202@zytor.com> <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>
In-Reply-To: <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, May 1, 2008 at 12:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>
>>> loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal
>> value.
>>  Why stopping at 2 GB?
> 
> if you select 4g for chunk size, we don't need to convert that from
> continuous to discrete to make X server driver happen.
> 
> actually the code could support any chunk_size...
> 
> for example: 16 g system
> orginal:
> 0-4g WB
> 3.5g-4g UC
> 4g-8g WB
> 8g-16g WB
> 16g-16.5g WB
> 
> if you set chunk size to 16g, and gran size <= 512M
> you will get
> 0-16g WB
> 3.5g-4g UC
> 16g-16.5g WB
> 

Yes, 16 GB systems are already mainstream; 32 GB is common, so I don't 
see any reason to stop at 2 GB.  Instead, it should loop up to the 
physical address size.

	-hpa
