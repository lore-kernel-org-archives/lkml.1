Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYIRWB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYIRWB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 18:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYIRWBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 18:01:18 -0400
Received: from mail.atheros.com ([12.36.123.2]:39660 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYIRWBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 18:01:17 -0400
Date: Thu, 18 Sep 2008 15:01:02 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>, Ingo Molnar <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080918220102.GE7408@tesla>
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com> <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com> <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com> <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com> <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com> <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 02:49:45PM -0700, Steven Noonan wrote:
> 
> No, it's in hex. 0x17 = 23, 0x11 = 17. IRQ 17 is the one that pooped
> in my case, which is my wireless chipset.

Ah - boo.

> If I do, I'll need to know what precisely to do about it. What debug
> info should I collect before rebooting?

Sure, OK so in ath9k's core.h we have a macro used to indicate what
type of debugging stuff gets print out. By default we only leave
enabled the fatal stuff.

#define DBG_DEFAULT (ATH_DBG_FATAL )

You want to add to this ATH_DBG_INTERRUPT as follows:

#define DBG_DEFAULT (ATH_DBG_FATAL | ATH_DBG_INTERRUPT)

Then since the issue seems to come up when you rmmod, simply try to
download do some large RXing or TXing or both and then rmmod. Capture
the output and send along.

> > Patches speak more than words, but yeah sorry, we should have
> > addressed this there. I've personally have just been busy with
> > tackling aggregation.
> >
> 
> Which is far more important, I agree. It's annoying to get speeds
> <802.11b on my pre-802.11n capable chipset and network. ;)

Yeah exactly, I hope the work we do will get in for 27. We'll see.

 Luis
