Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYI3Iyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYI3Iyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 04:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYI3Iyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 04:54:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34467 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYI3Iyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 04:54:38 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task struct
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
In-Reply-To: <20080930012839.1bb8c2e1@infradead.org>
References: <20080930140930.ED5B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080930012839.1bb8c2e1@infradead.org>
Message-Id: <20080930173528.6132.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 30 Sep 2008 17:54:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Thank you for quick responce.

> > I wonder to why PR_SET_TIMERSLACK decreasing doesn't need root
> > privilege.
> > 
> > example,
> > nice() systemcall is
> >   - nice increasing (pirority decreasing) doesn't need root privilege.
> >   - nice decreasing (priority incriasing) need root privilege.
> > 
> > So, I think time slack setting need similar one.
> > Otherwise, non-privilege user can increase power consumpsion easily
> > by PR_SET_TIMERSLACK.
> > 
> > What do you think?
> 
> setting timerslack to 0 has no real negative effects on the system on
> the one hand, on the other hand, it'll be multimedia apps and games who
> want to do this.
> 
> Requiring this type of app to be root doesn't sound like a good idea,
> especially since all you get by "cheating" is ... the exact behavior
> you ask for anyway. "Increased power consumption" isn't a root
> privilege, the app can consume much more power just by a "while (1);"
> loop for example.

Right.

But I worry about an end user can't find a application which 
spent large power comsumption.
Many laptop users think battery life is really really important.

end user can find "while(1)" app easily by top command.
but they can't find timerslack==0 app easily.

So, I can drop my proposal. but I hope you explain your expected end user usages.



