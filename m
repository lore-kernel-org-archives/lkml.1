Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYFRDhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYFRDhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 23:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbYFRDhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 23:37:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43756
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757309AbYFRDhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 23:37:03 -0400
Date: Tue, 17 Jun 2008 20:37:03 -0700 (PDT)
Message-Id: <20080617.203703.254889774.davem@davemloft.net>
To: yanmin_zhang@linux.intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: IPF Montvale machine panic when running a network-relevent
 testing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1213759663.25608.33.camel@ymzhang>
References: <1213345160.25608.3.camel@ymzhang>
	<1213759663.25608.33.camel@ymzhang>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5I3bNfq009830

From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Date: Wed, 18 Jun 2008 11:27:43 +0800

> This issue is caused by tcp defer accept. Mostly, process context calls lock_sock
> to apply a sleeping lock. BH (SoftIRQ) context calls bh_lock_sock(_nested) to just apply
> for the sk->sk_lock.slock without sleeping, then do appropriate processing based on
> if sk->sk_lock.owned==0. That works well if both process context and BH context operate
> the same sk at the same time. But with ï»¿tcp defer accept, it doesn't, because
> process context(for example, in inet_csk_accept) locks the listen sk, while BH
> context (in tcp_v4_rcv, for example) locks the child sk and calls
> ï»¿tcp_defer_accept_checkï»¿ => inet_csk_reqsk_queue_add => reqsk_queue_add, so there is a race
> to access the listen sock.
> 
> Below patch against 2.6.26-rc6 fixes the issue.
> 
> ï»¿ï»¿Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

We reverted the guilty defer accept changes, please test Linus's
current tree.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
