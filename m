Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZA2Nie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZA2Nie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZA2NiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:38:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45334 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZA2NiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:38:20 -0500
Subject: Re: [PATCH v3] timer: implement lockdep deadlock detection
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1233166017.4811.9.camel@johannes.local>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
	 <1233079597.4755.2.camel@johannes.local> <1233081027.10992.21.camel@laptop>
	 <1233082650.4455.9.camel@johannes.local> <1233130815.10992.39.camel@laptop>
	 <1233136487.4151.5.camel@johannes.local> <1233137581.10992.44.camel@laptop>
	 <1233140081.3936.21.camel@johannes.local>
	 <1233166017.4811.9.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 14:38:07 +0100
Message-Id: <1233236287.4495.77.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 19:06 +0100, Johannes Berg wrote:

> +/*
> + * All the indirection here is required to build the
> + * "<file>:<line>" string and the pointer to it.
> + */
> +#define ___TIMER_INITIALIZER(_fn, _exp, _dat, _kn)			\
> +	____TIMER_INITIALIZER(_fn, _exp, _dat, (_kn), &(_kn))
> +#define __TIMER_INITIALIZER(_fn, _exp, _dat, _f, _c, _l)		\
> +	___TIMER_INITIALIZER(_fn, _exp, _dat, _f # _c # _l)
> +#define _TIMER_INITIALIZER(_fn, _exp, _dat, _f, _l)			\
> +	__TIMER_INITIALIZER(_fn, _exp, _dat, _f, :, _l)
> +#define TIMER_INITIALIZER(_function, _expires, _data)			\
> +	_TIMER_INITIALIZER(_function, _expires, _data, __FILE__, __LINE__)

The regular way to write that would be:

#define __STR(foo) #foo
#define STR(foo) __STR(foo)

__FILE__ ":" STR(__LINE__)

I'm sure I saw that stringify thing somewhere in the kernel before, but
can't find it. I recently added it to lockdep.c, maybe we should add it
to kernel.h ?

