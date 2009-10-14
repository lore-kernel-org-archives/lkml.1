Return-Path: <linux-kernel-owner+w=401wt.eu-S1761859AbZJNPNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761859AbZJNPNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbZJNPNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:13:35 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:14761 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753608AbZJNPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:13:34 -0400
Date: Wed, 14 Oct 2009 17:12:40 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: linux-mtd <linux-mtd@lists.infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro \(Nokia-D/Helsinki\)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6 5/5]: mtdoops: refactor as a kmsg_dumper
Message-ID: <20091014171240.49d0963f@marrow.netinsight.se>
In-Reply-To: <20091014154124.5d9c366e@marrow.netinsight.se>
References: <20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	<20091012110954.67d7d8d8.akpm@linux-foundation.org>
	<20091012182346.GH17138@elte.hu>
	<alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	<20091014153458.05e31db6@marrow.netinsight.se>
	<20091014154124.5d9c366e@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 15:41:24 +0200
Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> -static void __exit mtdoops_console_exit(void)
> +static void __exit mtdoops_exit(void)
>  {
>  	struct mtdoops_context *cxt = &oops_cxt;
>  
>  	unregister_mtd_user(&mtdoops_notifier);
> -	unregister_console(&mtdoops_console);
>  	kfree(cxt->name);

The kfree should go as well since cxt->name is no longer allocated. I'll
await further comments and send a new patch tomorrow.

// Simon
