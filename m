Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbXFBATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbXFBATi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbXFBATb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:19:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56580 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885AbXFBATa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:19:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Emmanuel =?iso-8859-1?Q?Fust=E9?= <emmanuel.fuste@laposte.net>
Cc: "djwong" <djwong@us.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
References: <JIZ905$469B6EF277FE655A66C9ACE2321FC036@laposte.net>
Date: Fri, 01 Jun 2007 18:18:32 -0600
In-Reply-To: <JIZ905$469B6EF277FE655A66C9ACE2321FC036@laposte.net> (Emmanuel
	=?iso-8859-1?Q?Fust=E9's?= message of "Fri, 1 Jun 2007 23:57:41 +0200")
Message-ID: <m1sl9bxl7r.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> As a side note, on my very old SMP machine, 2.6.20 correctly
> load-balance IRQs across CPU but 2.6.21 not. I know that
> in-kernel IRQ load balancer is marked as deprecated and
> somewhat broken, but with your report it make me think it
> could be a bug in the IRQ rerouting part in my case too and
> not necessary in the load-balancer (decision) part.

I doubt it.  The practical problem is that cpu_down does not
and by design can not call the irq balancing part properly
and I haven't yet seen anything to suggest that we don't migrate
irq properly.

So I'm guessing it was the decision part.

Eric
