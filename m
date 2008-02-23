Return-Path: <linux-kernel-owner+w=401wt.eu-S1762924AbYBWUUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762924AbYBWUUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbYBWUUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:20:42 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39572 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756014AbYBWUUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:20:41 -0500
Message-Id: <1203798039.14328.1238633553@webmail.messagingengine.com>
X-Sasl-Enc: ZiHkGP2zw7lqUMIcp7A+QomOaGRv9kSyy0My5crvuj7Z 1203798039
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "lkml" <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080203172148.GA17875@mailshack.com>
   <20080218210115.GA24592@uranus.ravnborg.org>
   <Pine.LNX.4.64.0802190930320.25052@anakin>
   <20080223163058.GA11003@mailshack.com>
   <20080223175306.GA15186@uranus.ravnborg.org>
Subject: Re: Lump xxxinit together with init if possible (was Re: Solve section
   mismatch for free_area_init_core.)
In-Reply-To: <20080223175306.GA15186@uranus.ravnborg.org>
Date: Sat, 23 Feb 2008 21:20:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 18:53:06 +0100, "Sam Ravnborg" <sam@ravnborg.org>
said:
> Hi Alexander.
> > I more than less expected people to scream "ugly, ugly!".
> 
> That was my first thought and the reason why it stayed in my inbox
> for so long.
> But I could not find a better way to do it. We could do it in
> different ways but not better.
> 
> > Maybe you could consider the following patch, instead?
> > In non-HOTPLUG configurations, devinit and init sections in vmlinux
> > are lumped together during the final link. There is no good reason
> > to warn about section mismatches between them in this case, because
> > all code is discarded at the same time. This patch moves the lumping-
> > together to the compile stage, which makes the unnecessary warnings
> > go away. Same for MEMORY_HOTPLUG/meminit and HOTPLUG_CPU/cpuinit.
> 
> From the commit where the seperate section were introduced:
> 
>     Introducing separate sections for __dev* (HOTPLUG),
>     __cpu* (HOTPLUG_CPU) and __mem* (MEMORY_HOTPLUG)
>     allows us to do a much more reliable Section mismatch
>     check in modpost. We are no longer dependent on the actual
>     configuration of for example HOTPLUG.
> 
> I think that explains it.

I should have looked at that commit first. Indeed, it does explain
why it is better to keep the sections separate. Thanks.
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Choose from over 50 domains or use your own

