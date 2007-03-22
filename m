Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXCVPCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXCVPCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbXCVPCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:02:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44432 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051AbXCVPCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:02:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 0/21] MSI rework
References: <1174560686.307511.956605711793.qpush@cradle>
Date: Thu, 22 Mar 2007 09:01:10 -0600
In-Reply-To: <1174560686.307511.956605711793.qpush@cradle> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:26 +1100")
Message-ID: <m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> This is my series to rework the generic MSI code into something we can use
> on powerpc[1].
>
> I've tried as much as possible not to change the semantics for other archs,
> but there's a few little changes. I think they're all OK in their own right.
>
> I don't have any serious hardware to test on, but my little x86_64 box with
> an e1000 using MSI still works with these changes. I've also got MSI working
> on a powerpc blade with a tg3. I haven't tested MSI-X _at all_.
>
> I've also tested on the blade with a debug hack to make the MSI case
> allocate/free 8 MSIs, but only use the last one, just to exercise the n > 1
> case a little. All seems to work fine.

Generally I think this looks good.  However there is a lot here, and some
of it potentially at least has some pretty subtle side effects.

So reviewing all of these patches at once is almost certain to cause
something important to be missed :(

Can we slow this process down a few days by taking this one logical chunk
at a time?

i.e.  First the simple bug fixes that should purely be restructure of
msi.c with no affect on anything outside of it.

And then get into the architecture enhancements.

Eric
