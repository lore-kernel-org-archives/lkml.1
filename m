Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYGNRRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYGNRRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 13:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYGNRRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 13:17:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:39773 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757394AbYGNRRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 13:17:32 -0400
X-Authenticated: #429267
X-Provags-ID: V01U2FsdGVkX19V5uhyka9VFn00zbgT3j+bi8XSE2DQs/9w7TyaFm
	Em7InprNRJDxNL
Subject: Re: mac80211 : WARN at net/mac80211/rate.h:153
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200807141614.51628.mb@bu3sch.de>
References: <20080714075010.GA3559@darkstar>
	 <200807141614.51628.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 19:17:29 +0200
Message-Id: <1216055849.4435.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 16:14 +0200, Michael Buesch wrote:
> CCing PID guys.
> I've seen several people hitting this. What's the meaning of this warning?

It basically means the rate control cannot find any rate in
local->hw.wiphy->bands[local->hw.conf.channel->band] that is supported
by the sta in question. Normally this should not happen. I guess the
reason is that the supported rates bits in the sta info are all zero,
which would probably be a bug. I haven't seen this here, but I don't use
the IBSS code either. To further investigate this, you could the
following just before the WARN_ON:

printk(KERN_DEBUG "supported rates bitmask: %08x\n",
	sta->supp_rates[sband->band]);

Mattias

