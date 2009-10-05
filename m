Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZJERWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZJERWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZJERWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:22:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1852 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbZJERWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:22:30 -0400
Subject: Re: [PATCH 02/21] ftrace.c: Add #define pr_fmt(fmt) KBUILD_MODNAME
 ": " fmt
From: Joe Perches <joe@perches.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
In-Reply-To: <1254748256.13160.0.camel@gandalf.stny.rr.com>
References: <cover.1254701151.git.joe@perches.com>
	 <9b377eefae9e28c599dd4a17bdc81172965e9931.1254701151.git.joe@perches.com>
	 <1254748256.13160.0.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Oct 2009 10:21:52 -0700
Message-Id: <1254763312.1799.507.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 09:10 -0400, Steven Rostedt wrote:
> On Sun, 2009-10-04 at 17:53 -0700, Joe Perches wrote:
> > Remove prefixes from pr_<level>, use pr_fmt(fmt)
> > No change in output.
> What does KBUILD_MODNAME give us in the core code? This file does not
> belong to any module and is only compiled into the core kernel.

Hi Steven.

KBUILD_MODNAME is basename(__FILE__), or if multiple files are
grouped in the Makefile, then it's the basename(group)

http://lkml.indiana.edu/hypermail/linux/kernel/0210.2/0325.html

For ftrace.c, it gives "ftrace", which is the same
as the prefix you were using, so there's no change
in the output.

For other entries in say kernel/power, there were
messages that did not have prefixes

I believe these are some of the +/-'s of each approach:

Current:

o Allows some messages to not have a prefix at all
o Prefixes can vary inside a specific compilation unit

Proposed:

o Consistent, smaller source code, with no typos
  for instance: acpi/apic typos were found/fixed
                kernel/power had messages without PM:
                mce used "MCE: " and "mce: " prefixes
o Compatible with KMSG_COMPONENT
o All logging messages should have a prefix so
  it could be easier to grep/categorize logs
o Future:
  - Doesn't require each compilation unit to #define pr_fmt
  - Smaller objects without duplicated prefixes
  - Extensible via some dynamic_debug like mechanism
    to hide or show modname/__func__/offset without
    significant overhead or any increase in object size
    (printk would emit the prefix via some insertion
     mechanism after "<level>")

cheers, Joe

