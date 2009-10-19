Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZJSLth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZJSLth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZJSLtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:49:36 -0400
Received: from smtp.nokia.com ([192.100.122.230]:61536 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZJSLtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:49:36 -0400
Subject: Re: [PATCH v11 4/5] core: Add kernel message dumper to call on
 oopses and panics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mtd <linux-mtd@lists.infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20091016140918.3981cfa2@marrow.netinsight.se>
References: <20091015094057.7298e0d7@marrow.netinsight.se>
	 <20091015094805.754461fa@marrow.netinsight.se>
	 <20091015093133.GF10546@elte.hu>
	 <20091015161052.0752208e@marrow.netinsight.se>
	 <20091015154640.GA11408@elte.hu>
	 <20091016094601.4e2c2d3e@marrow.netinsight.se>
	 <20091016080935.GA3895@elte.hu> <1255681467.32489.360.camel@localhost>
	 <20091016112556.6902b2dc@marrow.netinsight.se>
	 <20091016101045.GA3263@elte.hu>
	 <20091016140918.3981cfa2@marrow.netinsight.se>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Oct 2009 14:48:42 +0300
Message-Id: <1255952922.32489.505.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Oct 2009 11:48:44.0305 (UTC) FILETIME=[1C528010:01CA50B2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 14:09 +0200, Simon Kagstrom wrote:
> The core functionality is implemented as per Linus suggestion from
> 
>   http://lists.infradead.org/pipermail/linux-mtd/2009-October/027620.html
> 
> (with the kmsg_dump implementation by Linus). A struct kmsg_dumper has
> been added which contains a callback to dump the kernel log buffers on
> crashes. The kmsg_dump function gets called from oops_exit() and panic()
> and invokes this callbacks with the crash reason.
> 
> Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
> Reviewed-by: Anders Grafstrom <anders.grafstrom@netinsight.net>
> Reviewed-by: Ingo Molnar <mingo@elte.hu>
> ---
> The bikeshed paint is drying:
> 
> ChangeLog:
> 	* (Ingo Molnar): Flatten lock use
> 	* (Artem, Aaro): Fix style issues
> 
>  include/linux/kmsg_dump.h |   44 ++++++++++++++++++
>  kernel/panic.c            |    3 +
>  kernel/printk.c           |  112 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 159 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/kmsg_dump.h

I wonder, via which tree this should go in. We are going to have mtdoops
depend on this. Should we go one of these ways:

   * this patch goes to one of Ingo's tip trees, so we can pull it and
     work on top.
   * we have Ingo's / Linus' acks, and this goes via the MTD tree.
?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

