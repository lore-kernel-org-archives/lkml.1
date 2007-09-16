Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbXIPXig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbXIPXig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 19:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXIPXiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 19:38:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38138
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbXIPXiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 19:38:15 -0400
Date: Sun, 16 Sep 2007 16:38:14 -0700 (PDT)
Message-Id: <20070916.163814.77649402.davem@davemloft.net>
To: crquan@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: Re: [PATCH 3/3] netlink: use a statically allocated nl_table
 instead
From: David Miller <davem@davemloft.net>
In-Reply-To: <11886759772663-git-send-email-crquan@gmail.com>
References: <1188675959178-git-send-email-crquan@gmail.com>
	<11886759682348-git-send-email-crquan@gmail.com>
	<11886759772663-git-send-email-crquan@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>
Date: Sun,  2 Sep 2007 03:45:59 +0800

> if the table is always fixed size with MAX_LINKS entries, why not use a statically
> allocated table straightforwardly?
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

I made the explicit decision to dynamically allocate because
many systems have limits on how large the kernel image can
be and therefore the less we statically allocate huge tables
(constant size or not) the better.

Lockdep is the worst offender, for example, it's completely awful.  It
consumes 4MB of kernel BSS space when enabled on a 64-bit platform.

Patch not applied.
