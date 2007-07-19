Return-Path: <linux-kernel-owner+w=401wt.eu-S935121AbXGSBlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121AbXGSBlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXGSBlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:41:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849AbXGSBlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:41:23 -0400
Date: Wed, 18 Jul 2007 18:41:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [git patches] two warning fixes
Message-Id: <20070718184101.1d31db9c.akpm@linux-foundation.org>
In-Reply-To: <1184807945.25235.289.camel@localhost.localdomain>
References: <20070718235504.GA9601@havoc.gtf.org>
	<200707190159.22654.ak@suse.de>
	<469EAABD.4010504@garzik.org>
	<1184807945.25235.289.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 11:19:05 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> In general, I share paulus point of view here that forcing us to test
> all those result code from sysfs file creation functions is just a major
> PITA and adds bloat all over the kernel. There are many many cases where
> the "obvious" thing of erroring out is actually not good policy. In many
> cases, the failure to create some random sysfs file shouldn't prevent
> the driver from operating, because the consequences of doing the later
> are worse than the consequences of not having that sysfs file in the
> first place. 

The only reason why the sysfs creation would fail is a kernel bug,
so the consequence of your proposal is in fact unfixed kernel bugs.

Plus, of course, a driver which doesn't offer the interfaces which
it is supposed to offer.

Now, we can talk about making those sysfs core functions generate warnings
themselves, and we can talk about generating new wrappers around them which
generate warnings and which return void, then migrating code over to use
those.

And we can also talk about blithely ignoring these errors and not telling
anyone about our bugs, but nobody should listen to such scandalous ideas.
