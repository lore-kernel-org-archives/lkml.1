Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYD2Sjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYD2Sjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYD2Sjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:39:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbYD2Sjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:39:45 -0400
Date: Tue, 29 Apr 2008 14:39:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/3] dynamic_printk: new feature
Message-ID: <20080429183935.GA8717@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Add the ability to dynamically enable/disable pr_debug()/dev_dbg() in the
kernel. Yes, these calls could be converted to printk(KERN_DEBUG), but there
are enough to cause overhead. Additionally, the logs become difficult to read.
This work is dependent on the CONFIG_DYNAMIC_PRINTK, which when enabled adds
about 1% to the text size of the kernel. Mssages can be dynamically controlled
by module:

echo "add module_name" > /sys/kernel/debug/dynamic_printk/modules
echo "remove module_name" > /sys/kernel/debug/dynamic_printk/modules

There is also a special 'all' value that turns on all the debugging messages.
This 'all' value can also be enabled during boot by passing 'dynamic_printk' on
the kernel command line.

I hope that these patches are useful for people writing new kernel code, for
system debugging and testing. In enabling the 'all' feature on the kernel I was
running i got a bunch of messages...they are pretty interesting in and of
themselves...they could point to error conditions, or further optimizations.

If this patch is accepted, i'd like to convert the myriad 'debug' printks -
DEBUGP(), dprintk(), to a standard format, either pr_debug() or dev_dbg(), to
hook into this mechanism.

thanks,

-Jason


