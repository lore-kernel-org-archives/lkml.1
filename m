Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYLYNSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYLYNSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbYLYNSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:18:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:65289 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYLYNSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:18:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SW0MTNa27DgiV59SD/5wPou7pgoIIja2+NFHdrDHelB/Je/yzwtaOdQE5Zl+PmfOci
         3XoqXmScdge3QTyf5mpDL/EC1lhBCUU7veFD496zv+uHABd0FuyrClihAI+aR4Uqq8WP
         dEcZDOgPTt6yqo2C0E+S1NaG7ub2SQWvviopY=
Date: Thu, 25 Dec 2008 16:10:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Message-ID: <20081225131000.GA7510@localhost>
References: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[KOSAKI Motohiro - Thu, Dec 25, 2008 at 09:41:54PM +0900]
... 
| Is this good idea?
| this patch also tested on above three architecture.
| 
| 
| ===
| Subject: [PATCH] irq: for_each_irq_desc() makes simplify
| Impact: cleanup
| 
| all for_each_irq_desc() usage point have !desc check.
| then its check can move into for_each_irq_desc() macro.
| 
| 
| Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
| CC: Yinghai Lu <yinghai@kernel.org>
| CC: Ingo Molnar <mingo@elte.hu>
| ---
|  arch/x86/kernel/io_apic.c |   10 ----------
|  drivers/xen/events.c      |    3 ---
|  fs/proc/stat.c            |    3 ---
|  include/linux/irqnr.h     |    6 ++++--
|  kernel/irq/autoprobe.c    |   15 ---------------
|  kernel/irq/handle.c       |    3 ---
|  kernel/irq/spurious.c     |    5 -----
|  7 files changed, 4 insertions(+), 41 deletions(-)
...

Hi Kosaki,

the idea is that good indeed but I wonder if it possible
to explain that we skip empty 'desk' in for_each_... name
itself. Maybe for_each_irq_desc_defined :) Or something
more convenient word instead of "defined"?

		- Cyrill -
