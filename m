Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZJLMQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZJLMQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZJLMQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:16:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:55884 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZJLMQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:16:38 -0400
Subject: Re: [PATCH] panic.c: export panic_on_oops
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091012120951.GA16799@elte.hu>
References: <1255241458-11665-1-git-send-email-dedekind1@gmail.com>
	 <20091012111545.GB8857@elte.hu> <1255346731.9659.31.camel@localhost>
	 <20091012113758.GB11035@elte.hu>
	 <20091012140149.6789efab@marrow.netinsight.se>
	 <20091012120951.GA16799@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 13:15:48 +0100
Message-Id: <1255349748.10605.13.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 14:09 +0200, Ingo Molnar wrote:
> Also, would it be possible to just simplify the thing and not do any 
> buffering at all? Extra buffering complexity in a console driver is only 
> asking for trouble. Or is flash storage write cycles optimization that 
> important in this case?

That and the fact that on NAND flash you have to write full pages at a
time -- that's 512 bytes, 2KiB or 4KiB depending on the type of chip. So
we really do want to buffer it where we can.

We don't want to write a 2KiB page for every line of printk output.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

