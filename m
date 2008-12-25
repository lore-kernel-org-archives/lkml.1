Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYLYOhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYLYOhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYLYOhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:37:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:15179 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbYLYOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:37:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V8ufyQ/KlJEqq5ICOzbj12IBEKEMTdt5e53rpMnZ7NgG7+u8XIuamHa5N9EHNAbeMI
         JMBPENbGflpy/7vU8NLIM9A+wxSxYH8WKLW8O3zswESBoX1CdOCHfh4/x6SlF+B3I7lQ
         5hAXGknf7Mgb3ySlLn72qnM/8u+/SPPAnAaZE=
Date: Thu, 25 Dec 2008 17:31:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Message-ID: <20081225143128.GA13388@localhost>
References: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225131000.GA7510@localhost> <2f11576a0812250545g1967467fy568099affdaa6c35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0812250545g1967467fy568099affdaa6c35@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[KOSAKI Motohiro - Thu, Dec 25, 2008 at 10:45:20PM +0900]
| > [KOSAKI Motohiro - Thu, Dec 25, 2008 at 09:41:54PM +0900]
| > ...
| > | Is this good idea?
| > | this patch also tested on above three architecture.
| > |
| > |
| > | ===
| > | Subject: [PATCH] irq: for_each_irq_desc() makes simplify
| > | Impact: cleanup
| > |
| > | all for_each_irq_desc() usage point have !desc check.
| > | then its check can move into for_each_irq_desc() macro.
| > |
| > |
| > | Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
| > | CC: Yinghai Lu <yinghai@kernel.org>
| > | CC: Ingo Molnar <mingo@elte.hu>
| > | ---
| > |  arch/x86/kernel/io_apic.c |   10 ----------
| > |  drivers/xen/events.c      |    3 ---
| > |  fs/proc/stat.c            |    3 ---
| > |  include/linux/irqnr.h     |    6 ++++--
| > |  kernel/irq/autoprobe.c    |   15 ---------------
| > |  kernel/irq/handle.c       |    3 ---
| > |  kernel/irq/spurious.c     |    5 -----
| > |  7 files changed, 4 insertions(+), 41 deletions(-)
| > ...
| >
| > Hi Kosaki,
| >
| > the idea is that good indeed but I wonder if it possible
| > to explain that we skip empty 'desk' in for_each_... name
| > itself. Maybe for_each_irq_desc_defined :) Or something
| > more convenient word instead of "defined"?
| 
| "if (!desc) " mean this irqno don't have irq description.
| so I think this name imply mean skipping no irq desctiption element.
| 
| Actually, on CONFIG_SPARSEIRQ, desc is filled in dynamically after booting.
| then "defined" is a bit misleading word.
| 

So if I would need to iterate over all descriptors including empty
I need to type all this long for(;;) form again? For me for_each_irq_desc
implies to iterate over each irq_desc allocated regardles of internal
descriptor data. For example in list_struct we have a special test if
entry is empty or not. So I think hiding details is not that good (and
that is why I was asking for more descriptive macro name). BUT if it
really supposed to behave like that then I don't object :)

		- Cyrill -
