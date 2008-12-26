Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYLZBWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYLZBWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 20:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYLZBWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 20:22:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55151 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYLZBWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 20:22:47 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081225160109.GA5636@localhost>
References: <2f11576a0812250643s25a79de6q205ae3b0a7d63f06@mail.gmail.com> <20081225160109.GA5636@localhost>
Message-Id: <20081226101754.85DB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 26 Dec 2008 10:22:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [KOSAKI Motohiro - Thu, Dec 25, 2008 at 11:43:45PM +0900]
> | > | "if (!desc) " mean this irqno don't have irq description.
> | > | so I think this name imply mean skipping no irq desctiption element.
> | > |
> | > | Actually, on CONFIG_SPARSEIRQ, desc is filled in dynamically after booting.
> | > | then "defined" is a bit misleading word.
> | > |
> | >
> | > So if I would need to iterate over all descriptors including empty
> | > I need to type all this long for(;;) form again?
> | 
> | We already have for_each_irq_nr() for this purpose ;-)
> 
> Which is not shorter form of desc iterator in turn :-)
> 
> Since the original for_each_irq_desc didn't check for NULL
> desc's I think the better would to name it like for_each_irq_desc_safe
> or for_each_irq_desc_inuse then.

but before CONFIG_SPARSEIRQ feature age, for_each_irq_desc() guaranteed
to return !NULL value.
recently CONFIG_SPARSEIRQ break this assumption. I hope to restore it.

In addition, if we make both for_each_irq_desc() and for_each_irq_desc().
for_each_irq_desc() become unused macro.
from cleanup view, unused function/macro is not preferred.

> 
> Nevermind, Kosaki, since it's only me who is confused I should
> just shut up :-)




