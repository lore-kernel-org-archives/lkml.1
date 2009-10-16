Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZJPL2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZJPL2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 07:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbZJPL2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 07:28:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21714 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbZJPL2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 07:28:43 -0400
Message-ID: <4AD85842.9090800@nokia.com>
Date: Fri, 16 Oct 2009 14:25:54 +0300
From: Aaro Koskinen <aaro.koskinen@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: ext Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: "dedekind1@gmail.com" <dedekind1@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v10 4/5] core: Add kernel message dumper to call on oopses
 and panics
References: <20091015094057.7298e0d7@marrow.netinsight.se>	<20091015094805.754461fa@marrow.netinsight.se>	<20091015093133.GF10546@elte.hu>	<20091015161052.0752208e@marrow.netinsight.se>	<20091015154640.GA11408@elte.hu>	<20091016094601.4e2c2d3e@marrow.netinsight.se>	<20091016080935.GA3895@elte.hu>	<1255681467.32489.360.camel@localhost> <20091016112556.6902b2dc@marrow.netinsight.se>
In-Reply-To: <20091016112556.6902b2dc@marrow.netinsight.se>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 11:25:55.0766 (UTC) FILETIME=[6D5EC560:01CA4E53]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Simon Kagstrom wrote:
> +#ifndef _LINUX_KMSG_DUMP_H
> +#define _LINUX_KMSG_DUMP_H
> +
> +#include <linux/list.h>
> +
> +enum kmsg_dump_reason {
> +	KMSG_DUMP_OOPS,
> +	KMSG_DUMP_PANIC,
> +};
> +
> +/**
> + * struct kmsg_dumper - kernel crash message dumper structure
> + * @dump:	The callback which gets called on crashes. The buffer is passed
> + * 		as two sections, where s1 (length l1) contains the older
> + * 		messages and s2 (length l2) contains the newer.
> + * @list:	Entry in the dumper list (private)
> + * @registered:	Flag that specifies if this is already registered
> + */
> +struct kmsg_dumper {
> +	void (*dump)(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
> +			const char *s1, unsigned long l1,
> +			const char *s2, unsigned long l2);
> +	struct list_head list;
> +	int registered;
> +};
> +
> +void kmsg_dump(enum kmsg_dump_reason reason);
> +
> +int kmsg_dump_register(struct kmsg_dumper *dumper);
> +
> +int kmsg_dump_unregister(struct kmsg_dumper *dumper);
> +
> +#endif /* _LINUX_DUMP_DEVICE_H */

If you still make a new version of the patch, please correct the
"_LINUX_DUMP_DEVICE_H" comment.

A.
