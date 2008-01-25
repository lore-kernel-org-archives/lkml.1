Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbYAYDeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbYAYDeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYAYDeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:34:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39125 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYAYDeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:34:10 -0500
Date: Fri, 25 Jan 2008 12:33:14 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: =?ISO-2022-JP?B?IkRhbmllbCBTcBskQmlPGyhCZyI=?= 
	<daniel.spang@gmail.com>
Subject: Re: [RFC][PATCH 3/8] mem_notify v5: introduce /dev/mem_notify new device (the core of this patch series)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "Marcelo Tosatti" <marcelo@kvack.org>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <cfd9edbf0801240419t669c9d9cl4cf0f821599fc7ad@mail.gmail.com>
References: <20080124132014.1769.KOSAKI.MOTOHIRO@jp.fujitsu.com> <cfd9edbf0801240419t669c9d9cl4cf0f821599fc7ad@mail.gmail.com>
Message-Id: <20080125121032.1AAE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel

> > +#define PROC_WAKEUP_GUARD  (10*HZ)
> [...]
> > +       timeout = info->last_proc_notify + PROC_WAKEUP_GUARD;
> 
> If only one or a few processes are using the system I think 10 seconds
> is a little long time to wait before they get the notification again.
> Can we decrease this value? Or make it configurable under /proc? Or
> make it lower with fewer users? Something like:

Oh, that is very interesting issue.
tank you good point out.

after deep thinking, I understand my current implementation is fully stupid.
current, worst case is below.

  1. low end
     - many process of used only a bit memory(sh, cp etc..) exist.
     - 1 memory eater process exist(may be, it is fat browser)
       and it watching /dev/mem_notify.

  2. high end
     - many process of used only a bit memory(sh, cp etc..) exist.
     - 1 memory eater process exist(may be, it is DB)
       and it watching /dev/mem_notify.

the point is "only 1 process watch /dev/mem_notify", but not a few processor.
I fix it with pleasure. 


> timeout = info->last_proc_notify + min(mem_notify_users, PROC_WAKEUP_GUARD);

I like this formula.
the rest problem is decide to default value when only 1 process watch /dev/mem_notify.

What do you think it?
and if my low end worst case situation doesn't match yours, 
Could you please explain your usage more?


BTW: 
end up, We will add /proc configuration the future.
but I think it is too early.
sometimes configrable parameter prevent the discussion of nicer default value.
Instead, I hope the default value changed by adjust your usage.


- kosaki


