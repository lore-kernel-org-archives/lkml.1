Return-Path: <linux-kernel-owner+w=401wt.eu-S1422656AbXDCTDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656AbXDCTDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422658AbXDCTDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:03:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422656AbXDCTDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:03:40 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, davem@davemloft.net
Subject: Re: [PATCH] make csum_partial obj-y
References: <20070403112604.129610b1.randy.dunlap@oracle.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 03 Apr 2007 22:02:12 +0200
In-Reply-To: <20070403112604.129610b1.randy.dunlap@oracle.com>
Message-ID: <p731wj1z0or.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fixes kernel bugzilla #8242:
> 
> Move csum_partial() from lib-y to obj-$(CONFIG_CSUM_PARTIAL)
> so that modules can use it.
> 
> CONFIG_BLK_DEV_MD (md/raid driver) needs csum_partial(),
> even when CONFIG_NET=n and BLK_DEV_MD=m, so build it as an
> object to force it being built and available.
> 
> REISERFS with XATTR=y also needs csum_partial(), so that
> is enforced here.

They are all broken because csum_partial gives different values
on different architectures.   You're just extending that to
possibly more subsystems.

-Andi
