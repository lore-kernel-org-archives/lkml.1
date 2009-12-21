Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZLUOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZLUOdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZLUOdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:33:50 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:52191 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753257AbZLUOdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:33:49 -0500
Date: Mon, 21 Dec 2009 15:33:41 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Anders Grafstrom <anders.grafstrom@netinsight.net>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: mtdoops: mtdoops works with kexec correctly
Message-ID: <20091221153341.2bece1d3@marrow.netinsight.se>
In-Reply-To: <20091221191254.089E.A69D9226@jp.fujitsu.com>
References: <20091221191254.089E.A69D9226@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 19:20:35 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> commit 2e386e4ba(mtdoops: refactor as a kmsg_dumper) is very good patch.
> but unfortunately it doesn't works with kexec and few embedded user need
> to use kexec. there is no reason to don't implement it. it isn't so
> hard.
> 
> FAQ
> ---
>  Q. Why KMSG_DUMP_OOPS is insufficient?
>  A. Because crash_kexec() is called before KMSG_DUMP_OOPS if
>     panic_on_oops==1.
> 
>  Q. Why do you move KMSG_DUMP_PANIC call place?
>  A. Otherwise kmsg_dump() is called twice if kexec enabled.
>     it's annoy.

I think it would be better to describe these comments in text instead
of as FAQs. Because of the --- it's also removed from the git log.
Maybe something like

	kmsg_dump: Dump on crash_kexec as well

	crash_kexec gets called before kmsg_dump(KMSG_DUMP_OOPS) if
	panic_on_oops is set, so the kernel log buffer is not stored
	for this case.

	This patch adds a KMSG_DUMP_KEXEC dump type which gets called
	when crash_kexec() is invoked. To avoid getting double dumps,
	the old KMSG_DUMP_PANIC is moved below crash_kexec(). The
	mtdoops driver is modified to handle KMSG_DUMP_KEXEC in the
	same way as a panic.


Other than that, it looks fine to me. I've done basic testing against
2.6.33-rc1, but unfortunately without kexec support.

Acked-by: Simon Kagstrom <simon.kagstrom@netinsight.net>

// Simon

