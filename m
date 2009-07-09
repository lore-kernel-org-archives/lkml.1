Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZGIBJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZGIBJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 21:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbZGIBJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 21:09:31 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:44507 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054AbZGIBJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 21:09:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19029.17220.326485.724846@cargo.ozlabs.ibm.com>
Date: Thu, 9 Jul 2009 11:09:24 +1000
From: Paul Mackerras <paulus@samba.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: lib: Export generic atomic64_t functions
In-Reply-To: <ada63e221js.fsf@cisco.com>
References: <ada63e221js.fsf@cisco.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier writes:

> The generic atomic64_t implementation in lib/ did not export the
> functions it defined, which means that modules that use atomic64_t
> would not link on platforms (such as 32-bit powerpc).  For example,
> trying to build a kernel with CONFIG_NET_RDS on such a platform would
> fail with:
> 
>     ERROR: "atomic64_read" [net/rds/rds.ko] undefined!
>     ERROR: "atomic64_set" [net/rds/rds.ko] undefined!
> 
> Fix this by exporting the atomic64_t functions to modules.  (I export
> the entire API even if it's not all currently used by in-tree modules to
> avoid having to continue fixing this in dribs and drabs)
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Nice, thanks.

Acked-by: Paul Mackerras <paulus@samba.org>

Andrew, I think this should be safe to go in 2.6.31.  Could you
include it in your next batch for Linus, or should I send it to him
directly?

Paul.
