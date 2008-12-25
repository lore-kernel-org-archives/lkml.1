Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbYLYNpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbYLYNpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYLYNpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:45:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:44643 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYLYNpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:45:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WLnXmkoFacmsH6pE9beCAWkhKuTjsA/LBoiQ5bsP0th5ulLZ5YoWTTzyXCWZ+Q8Z5w
         IktUjX4293RVTGucZtb/bWrIltdPOb1sKFJGips5DBSXhQKSwCAs10evOsHAnEMBZDw/
         GG27TERvECDIRF3GTO7H70kWCfV66g51IRuDk=
Message-ID: <2f11576a0812250545g1967467fy568099affdaa6c35@mail.gmail.com>
Date: Thu, 25 Dec 2008 22:45:20 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH for -tip] irq: for_each_irq_desc() makes simplify
Cc: "Ingo Molnar" <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081225131000.GA7510@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081225200020.50F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081225213640.50F3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081225214057.50F6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081225131000.GA7510@localhost>
X-Google-Sender-Auth: 23489229758e5a77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [KOSAKI Motohiro - Thu, Dec 25, 2008 at 09:41:54PM +0900]
> ...
> | Is this good idea?
> | this patch also tested on above three architecture.
> |
> |
> | ===
> | Subject: [PATCH] irq: for_each_irq_desc() makes simplify
> | Impact: cleanup
> |
> | all for_each_irq_desc() usage point have !desc check.
> | then its check can move into for_each_irq_desc() macro.
> |
> |
> | Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> | CC: Yinghai Lu <yinghai@kernel.org>
> | CC: Ingo Molnar <mingo@elte.hu>
> | ---
> |  arch/x86/kernel/io_apic.c |   10 ----------
> |  drivers/xen/events.c      |    3 ---
> |  fs/proc/stat.c            |    3 ---
> |  include/linux/irqnr.h     |    6 ++++--
> |  kernel/irq/autoprobe.c    |   15 ---------------
> |  kernel/irq/handle.c       |    3 ---
> |  kernel/irq/spurious.c     |    5 -----
> |  7 files changed, 4 insertions(+), 41 deletions(-)
> ...
>
> Hi Kosaki,
>
> the idea is that good indeed but I wonder if it possible
> to explain that we skip empty 'desk' in for_each_... name
> itself. Maybe for_each_irq_desc_defined :) Or something
> more convenient word instead of "defined"?

"if (!desc) " mean this irqno don't have irq description.
so I think this name imply mean skipping no irq desctiption element.

Actually, on CONFIG_SPARSEIRQ, desc is filled in dynamically after booting.
then "defined" is a bit misleading word.
