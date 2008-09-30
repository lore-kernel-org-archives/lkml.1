Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYI3I2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYI3I2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYI3I2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:28:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:51156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbYI3I2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:28:31 -0400
Date: Tue, 30 Sep 2008 01:28:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task
 struct
Message-ID: <20080930012839.1bb8c2e1@infradead.org>
In-Reply-To: <20080930140930.ED5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161423.59ebf2fc@infradead.org>
	<20080930140930.ED5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 14:16:09 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> I wonder to why PR_SET_TIMERSLACK decreasing doesn't need root
> privilege.
> 
> example,
> nice() systemcall is
>   - nice increasing (pirority decreasing) doesn't need root privilege.
>   - nice decreasing (priority incriasing) need root privilege.
> 
> So, I think time slack setting need similar one.
> Otherwise, non-privilege user can increase power consumpsion easily
> by PR_SET_TIMERSLACK.
> 
> What do you think?

setting timerslack to 0 has no real negative effects on the system on
the one hand, on the other hand, it'll be multimedia apps and games who
want to do this.

Requiring this type of app to be root doesn't sound like a good idea,
especially since all you get by "cheating" is ... the exact behavior
you ask for anyway. "Increased power consumption" isn't a root
privilege, the app can consume much more power just by a "while (1);"
loop for example.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
