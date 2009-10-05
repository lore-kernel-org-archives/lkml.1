Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZJER5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZJER5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 13:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZJER5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 13:57:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1855 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZJER5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 13:57:39 -0400
Subject: Re: [PATCH 16/21] kernel/kexec.c: use pr_<level> and add
 pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <m163auvylv.fsf@fess.ebiederm.org>
References: <cover.1254701151.git.joe@perches.com>
	 <cover.1254701151.git.joe@perches.com>
	 <40ffa7c5595f4afbba793919b397b5139cde901a.1254701151.git.joe@perches.com>
	 <m163auvylv.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Oct 2009 10:57:02 -0700
Message-Id: <1254765422.1799.542.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 05:01 -0700, Eric W. Biederman wrote:
> Joe Perches <joe@perches.com> writes:
> > Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > Converted printk(KERN_<level> to pr_<level>(
> > Added KERN_ERR to allocation failure message
> I'm dense and I haven't seen the discussions.  What
> is the point of adding a prefix string where none exists
> into a bunch of printks?

Hi Eric.

There have been a few messages on lkml with little comment,
so I thought I'd get a few more by submitting some patches.

There is a [0/21] message that you might have received directly.
http://lkml.org/lkml/2009/10/4/198

I believe these are some of the +/-'s of each approach:
(copy/pasted from an earlier response)

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


