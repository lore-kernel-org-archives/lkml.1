Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYEFL5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYEFL5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYEFL5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:57:41 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:31387 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYEFL5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:57:40 -0400
Message-ID: <48204766.7020506@de.ibm.com>
Date: Tue, 06 May 2008 13:56:22 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ltp-list@lists.sourceforge.net, Rusty Russell <rusty@rustcorp.com.au>,
       ltp-coverage@lists.sourceforge.net, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] kernel: call constructors
References: <481F2694.5090601@de.ibm.com> <20080505211942.3945d01c.akpm@linux-foundation.org>
In-Reply-To: <20080505211942.3945d01c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 05 May 2008 17:24:04 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> --- linux-2.6.26-rc1.orig/arch/powerpc/kernel/vmlinux.lds.S
>> +++ linux-2.6.26-rc1/arch/powerpc/kernel/vmlinux.lds.S
>> @@ -193,6 +193,9 @@ SECTIONS
>>  		*(.toc)
>>  	}
>>  #endif
>> +	.data.gcov : {
>> +		CONSTRUCTORS
>> +	}
> 
> Why did powerpc (and only powerpc) need this touchup?  It already includes
> asm-generic/vmlinux.lds.h?

asm-generic/vmlinux.lds.h defines CONSTRUCTORS but it needs to be
referenced in the actual linker script to become active. For some reason
unknown to me, CONSTRUCTORS shows up in all arch/*/vmlinux.lds.S scripts
except for powerpc (see also my other reply about the CONSTRUCTORS
section).
