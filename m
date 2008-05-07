Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbYEGVpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbYEGVpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYEGVpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:45:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:38172 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbYEGVpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:45:39 -0400
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
	drivers/video/aty/radeon_base.c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com>
References: <20080424043400.GS20457@bakeyournoodle.com>
	 <20080506143936.6357e578.akpm@linux-foundation.org>
	 <20080506.144301.233784820.davem@davemloft.net>
	 <1210121683.21644.194.camel@pasglop>
	 <20080506182006.4b4a3968.akpm@linux-foundation.org>
	 <1210134804.21644.202.camel@pasglop>
	 <20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 07:43:41 +1000
Message-Id: <1210196621.1421.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 10:23 +0200, Cornelia Huck wrote:
> 
> But they are often an indication that we messed up earlier (e. g. try
> to add something twice)...
>
> > mostly only compromise the user ABI, 
> 
> Which is bad enough in itself. Most people will want to avoid a
> crippled ABI.

You prefer a crippled ABI or a machine that doesn't boot with no console
at all to see what happened because the console driver refused to
initialize due to such a sysfs file conflict ?

Now, again, that's only part of what I'm talking about anyway.

What I'm saying is basically that rather than have a test & printk in
every bloody driver, we are better off having it once in the function
itself (bloat ?)

In addition, in most cases, failure of initializing the driver is -not-
the right solution, so the driver should probably just warn, which can
as well be done by ... having sysfs_create_file() itself do the warning.

> The first one is the one we really want to yell about, since we've
> messed up somewhere. The second one is not as likely, maybe we want to
> warn about it when we activate debug options?
> 
> Which of the current __must_check functions do you think should have
> the __must_check removed?

sysfs_create_file is a good candidate imho :-)

Ben.


