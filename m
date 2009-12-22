Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZLVADL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZLVADL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZLVADJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:03:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47546 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZLVADH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:03:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Subject: Re: [PATCH] mtd: mtdoops: mtdoops works with kexec correctly
Cc: kosaki.motohiro@jp.fujitsu.com,
       Anders Grafstrom <anders.grafstrom@netinsight.net>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091221153341.2bece1d3@marrow.netinsight.se>
References: <20091221191254.089E.A69D9226@jp.fujitsu.com> <20091221153341.2bece1d3@marrow.netinsight.se>
Message-Id: <20091222085508.1410.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 22 Dec 2009 09:03:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 21 Dec 2009 19:20:35 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > commit 2e386e4ba(mtdoops: refactor as a kmsg_dumper) is very good patch.
> > but unfortunately it doesn't works with kexec and few embedded user need
> > to use kexec. there is no reason to don't implement it. it isn't so
> > hard.
> > 
> > FAQ
> > ---
> >  Q. Why KMSG_DUMP_OOPS is insufficient?
> >  A. Because crash_kexec() is called before KMSG_DUMP_OOPS if
> >     panic_on_oops==1.
> > 
> >  Q. Why do you move KMSG_DUMP_PANIC call place?
> >  A. Otherwise kmsg_dump() is called twice if kexec enabled.
> >     it's annoy.
> 
> I think it would be better to describe these comments in text instead
> of as FAQs. Because of the --- it's also removed from the git log.
> Maybe something like
> 
> 	kmsg_dump: Dump on crash_kexec as well
> 
> 	crash_kexec gets called before kmsg_dump(KMSG_DUMP_OOPS) if
> 	panic_on_oops is set, so the kernel log buffer is not stored
> 	for this case.
> 
> 	This patch adds a KMSG_DUMP_KEXEC dump type which gets called
> 	when crash_kexec() is invoked. To avoid getting double dumps,
> 	the old KMSG_DUMP_PANIC is moved below crash_kexec(). The
> 	mtdoops driver is modified to handle KMSG_DUMP_KEXEC in the
> 	same way as a panic.
> 
> 
> Other than that, it looks fine to me. I've done basic testing against
> 2.6.33-rc1, but unfortunately without kexec support.
> 
> Acked-by: Simon Kagstrom <simon.kagstrom@netinsight.net>

Thanks. Your description is obviously better.



