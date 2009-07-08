Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbZGHRfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbZGHRfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZGHRfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:35:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60519
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066AbZGHRfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:35:18 -0400
Date: Wed, 08 Jul 2009 10:35:20 -0700 (PDT)
Message-Id: <20090708.103520.193697491.davem@davemloft.net>
To: michal.simek@petalogix.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu,
       arnd@arndb.de, lethal@linux-sh.org, ltp-list@lists.sourceforge.net
Subject: Re: mmap hw behavior
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A54D14F.9090101@petalogix.com>
References: <4A54D14F.9090101@petalogix.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <michal.simek@petalogix.com>
Date: Wed, 08 Jul 2009 19:03:11 +0200

> When I call mmap for that open file with pointer to calloc place
> (first parameter, + length zero) it should be one tlb invalidation
> for calloc and new tlb which connect open file.  We check it and we
> don't have any tlb invalidation that's why I think that kernel do
> different thigs.  Or is it there any copying? Or anything different?

There is no need to tlb flush the calloc area unless that memory area
is actually touched by the user application and thus the page is
faulted in.
