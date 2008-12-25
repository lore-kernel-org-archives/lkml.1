Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbYLYQBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbYLYQBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 11:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYLYQBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 11:01:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:32453 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYLYQBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 11:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I0XNimRxmpRqFmUgk+CQ5DEOvATcnz20FUH5H77dqkU0eSVrVWjmip3bVvY0kNViji
         89kc/5n08FHL8G6pbcPYBZ7b+ky9uqTARS11MARIVE1ugvS31ZC9nJfESZ8voHDcvdZ3
         8ggT1HfK4bWDpQPwuDetCRc3N86KSixr77I1s=
Date: Thu, 25 Dec 2008 19:01:09 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Message-ID: <20081225160109.GA5636@localhost>
References: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225131000.GA7510@localhost> <2f11576a0812250545g1967467fy568099affdaa6c35@mail.gmail.com> <20081225143128.GA13388@localhost> <2f11576a0812250643s25a79de6q205ae3b0a7d63f06@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0812250643s25a79de6q205ae3b0a7d63f06@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[KOSAKI Motohiro - Thu, Dec 25, 2008 at 11:43:45PM +0900]
| > | "if (!desc) " mean this irqno don't have irq description.
| > | so I think this name imply mean skipping no irq desctiption element.
| > |
| > | Actually, on CONFIG_SPARSEIRQ, desc is filled in dynamically after booting.
| > | then "defined" is a bit misleading word.
| > |
| >
| > So if I would need to iterate over all descriptors including empty
| > I need to type all this long for(;;) form again?
| 
| We already have for_each_irq_nr() for this purpose ;-)

Which is not shorter form of desc iterator in turn :-)

Since the original for_each_irq_desc didn't check for NULL
desc's I think the better would to name it like for_each_irq_desc_safe
or for_each_irq_desc_inuse then.

Nevermind, Kosaki, since it's only me who is confused I should
just shut up :-)

| 
| > For me for_each_irq_desc
| > implies to iterate over each irq_desc allocated regardles of internal
| > descriptor data. For example in list_struct we have a special test if
| > entry is empty or not. So I think hiding details is not that good (and
| > that is why I was asking for more descriptive macro name). BUT if it
| > really supposed to behave like that then I don't object :)
| 
		- Cyrill -
