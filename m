Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbYEFScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbYEFScU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYEFScF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:32:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYEFScC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:32:02 -0400
Message-ID: <4820A401.1040105@zytor.com>
Date: Tue, 06 May 2008 11:31:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fixed mtrr change WP to WB
References: <200805041823.57198.yhlu.kernel@gmail.com>	 <200805061038.58023.yhlu.kernel@gmail.com>	 <200805061041.40047.yhlu.kernel@gmail.com>	 <482099E6.5060208@zytor.com> <86802c440805061124w630bc987k71c3c290fdfde773@mail.gmail.com>
In-Reply-To: <86802c440805061124w630bc987k71c3c290fdfde773@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>
>>  If the mptable should be modified, it should be copied to kernel memory and
>> modified there.  Modifying it in-place is both unsafe and, in general,
>> simply will not work.
> 
> but
> 
>          * 1) Scan the bottom 1K for a signature
>          * 2) Scan the top 1K of base RAM
>          * 3) Scan the 64K of bios
>          */
>         if (smp_scan_config(0x0, 0x400, reserve) ||
>             smp_scan_config(639 * 0x400, 0x400, reserve) ||
>             smp_scan_config(0xF0000, 0x10000, reserve))
>                 return;
> 
> and all these areas are reserved already.
> 
> wonder if we could only modify mpf->mpf_physptr to point to another
> mpc and reuse mpf?
> 

Obviously, if you have already modified a table, you should save a 
pointer to it, and not rely on the kernel scanning later.

	-hpa
