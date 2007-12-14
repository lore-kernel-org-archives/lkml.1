Return-Path: <linux-kernel-owner+w=401wt.eu-S1764904AbXLNTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764904AbXLNTlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXLNTlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:41:12 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:45912 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbXLNTlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:41:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 20:38:57 +0100
User-Agent: KMail/1.9.6
Cc: "Ingo Molnar" <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       "Daniel Walker" <dwalker@mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com, kjwinchester@gmail.com,
       "John Linville" <linville@tuxdriver.com>,
       "Larry Finger" <Larry.Finger@lwfinger.net>
References: <20071213003028.676998182@mvista.com> <200712142005.21375.mb@bu3sch.de> <2c0942db0712141125g65422bc5r83c83a2ce81cc58a@mail.gmail.com>
In-Reply-To: <2c0942db0712141125g65422bc5r83c83a2ce81cc58a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712142038.58400.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 20:25:39 Ray Lee wrote:
> > I'm sorry. The patch that _you_ quoted fixes a blinking LED
> > and nothing else.
> 
> Well, you're wrong. Sorry, but that's just the way it is. See below.
> 
> > It does _not_ fix loading of rfkill or b43 in any way.
> > It does, however, fix loading of rfkill-input. But the b43 module
> > operation does _not_ depend in any way on the rfkill-input module, except
> > the tiny LED that doesn't blink if it's not loaded.
> > I hope you understood now that the thread on bcm43xx-dev was NOT about
> > your requirement to load rfkill before b43.
> 
> *AGAIN*, please read your message here, in particular item number
> seven on Larry's list:
> 
> https://lists.berlios.de/pipermail/bcm43xx-dev/2007-December/006472.html
> 
> For the last fscking time, if rfkill and rfkill-input are not loaded,
> not one line comes out in dmesg when b43 and ssb are loaded. In
> particular, your pretty little message about needing newer firmware
> also does not print. So, yeah, not loading rfkill{,-input} *does*
> cause issues with b43 working, as there's no damn way to find out
> what's broken!

Guy... .
I KNOW what the patch above does.
What do you think does the following line?
	err = request_module("rfkill-input");
Does it load the "rfkill-input" or the "rfkill" module.
That's the million dollar question. You only have one try.

This patch is NOT about the "rfkill" module. I don't know how
often I have to say that. It is _obvious_.

Let's also quote Larry's sevenths point here, that you referred to
now for the second time:
" (7) If rfkill-input is built as a module, it is not automatically loaded."

I am not sure how I can make this any more clear.
It does load the "rfkill-input" module from within b43.
It does NOT load "rfkill"
It does NOT load "rfkill-input" BEFORE b43 was loaded.

This patch does exactly ONE thing. It does make sure a LED does blink.
Nothing more.
I signed this patch off. So you can be 100% sure I know what it does.
I do NOT sign off patches for which I don't know what they do.

> > > I have complete current userspace as of yesterday's Ubuntu Hardy Heron
> > > development archives.
> >
> > Ok. I will install a copy of Ubuntu Hardy Heron and check if I can
> > reproduce this.
> 
> I'm not asking you to do that, this particular bug will be fixed by
> Larry's patch, whether you believe that or not.

Did you try that?
How can b43 load get fixed by a patch that adds a request_module()
to the b43 module? That is a chicken and egg problem!

> > However the fact that this does not happen on older Ubuntu platforms
> > and does not happen on Fedora leads to the conclusion that it
> > is a bug in Hardy Heron that I am not responsible for.
> 
> The kernel does not exist in a vacuum. It's the kernel's job to make
> sure it works with properly written userspace. Broken userspace, sure,
> then we can talk about breaking it.

yes properly written userspace.

> > And you also do realise that Hardy Heron is the current development
> > version of Ubuntu? Development versions have bugs.
> 
> Oy vay. I'm not an idiot. Yes, it's the current develoment version.
> But tracking the latest kernel.org kernel has in the past required the
> latest develoment version of the distribution, so I upgrade it as
> well.

I am running wireless-2.6 on feisty. So the kernel does _not_ require
an update of the distribution.
q.e.d.

> I'm not blaming it on you. I'm merely reporting a fucking
> incompatibility. Read my messages again from the top, and stop taking
> this all so damn personally, will you?

You are telling me that I don't understand patches that I sign off
and I should not take this personally?
That is challenging.

-- 
Greetings Michael.
