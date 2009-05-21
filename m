Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZEUXl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZEUXl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZEUXlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:41:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40536 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754937AbZEUXlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:41:20 -0400
Date: Fri, 22 May 2009 00:41:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, x86@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/3] kernel.h: Add DO_ONCE statement expression macro
Message-ID: <20090522004127.1a91056b@lxorguk.ukuu.org.uk>
In-Reply-To: <1242948762.3373.143.camel@Joe-Laptop.home>
References: <cover.1242943463.git.joe@perches.com>
	<7b063fda0675875d51a5da49f59e89520d025eee.1242943463.git.joe@perches.com>
	<4A15E36E.9080501@oracle.com>
	<1242948762.3373.143.camel@Joe-Laptop.home>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add a DO_ONCE statement expression analogous to printk_once
> that executes any arbitrary statement exactly once.

Your implementation is racy. Its also hiding stuff in macro magic which
is asking for accidents to happen.

The natural kernel way to write this is

	if (!test_and_set_bit(....))

which is a lot more obvious than a magic macro, doesn't race and can use
other bits in an existing set of flags and be used as a
"do-once-for-this-object-instance" - which is almost always want you want.

Alan
