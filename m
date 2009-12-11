Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbZLKKiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbZLKKiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbZLKKiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:38:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57893
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610AbZLKKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:38:03 -0500
Date: Fri, 11 Dec 2009 02:38:08 -0800 (PST)
Message-Id: <20091211.023808.233094506.davem@davemloft.net>
To: mingo@elte.hu
Cc: jamie.iles@picochip.com, linux-kernel@vger.kernel.org,
       linux@arm.linux.org.uk, peterz@infradead.org
Subject: Re: [PATCH 1/2] perf tools: allow building for ARM
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091211102316.GB16882@elte.hu>
References: <1260523260-15694-1-git-send-email-jamie.iles@picochip.com>
	<20091211102316.GB16882@elte.hu>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 11 Dec 2009 11:23:16 +0100

> 
> * Jamie Iles <jamie.iles@picochip.com> wrote:
> 
>> +#ifdef __arm__
>> +#include "../../arch/arm/include/asm/unistd.h"
>> +#define rmb()		asm volatile("":::"memory")
>> +#define cpu_relax()	asm volatile("":::"memory")
>> +#endif
> 
> cpu_relax() looks fine, but rmb() seems not to match the one that can be 
> found in arch/arm/:

I think he did it this way so it can compile in the meantime,
and that doing it right requires runtime cpu detection to
select which barrier instruction is even available on the
current ARM cpu.
