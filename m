Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZK3K1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZK3K1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZK3K1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:27:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:57056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbZK3K1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:27:32 -0500
Subject: Re: [PATCH/RFC v5 4/5]: core: Add dump device to call on oopses
 and panics
From: David Woodhouse <dwmw2@infradead.org>
To: dedekind1@gmail.com
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1259576611.19465.374.camel@macbook.infradead.org>
References: <20091012131528.GC25464@elte.hu>
	 <20091012153937.0dcd73e5@marrow.netinsight.se>
	 <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	 <20091012110954.67d7d8d8.akpm@linux-foundation.org>
	 <20091012182346.GH17138@elte.hu>
	 <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	 <20091013151751.59e217a7@marrow.netinsight.se>
	 <20091013152235.188059d2@marrow.netinsight.se>
	 <20091126093657.GA25430@logfs.org> <1259566071.7518.48.camel@localhost>
	 <20091130074603.GA30911@logfs.org>  <1259571118.7518.56.camel@localhost>
	 <1259576611.19465.374.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 10:27:27 +0000
Message-ID: <1259576847.19465.376.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 (2.28.1-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 10:23 +0000, David Woodhouse wrote:
> +       /* Theoretically, the log could move on after we do this, but
> +          there's not a log we can do about that. The new messages
> +          will overwrite the start of what we dump. */
> +       spin_lock_irqsave(&logbuf_lock, flags);
> +       end = log_end & LOG_BUF_MASK;
> +       chars = logged_chars;
> +       spin_unlock_irqrestore(&logbuf_lock, flags); 

Actually that's not true -- we _could_ hold the logbuf_lock until the
end of the function. Not entirely sure we _want_ to though...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

