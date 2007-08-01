Return-Path: <linux-kernel-owner+w=401wt.eu-S1759785AbXHAQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbXHAQ5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbXHAQ5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:57:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbXHAQ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:57:06 -0400
Date: Wed, 1 Aug 2007 09:55:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       bcm43xx-dev@lists.berlios.de, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, Gary Zambrano <zambrano@broadcom.com>,
       John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH FINAL] Merge the Sonics Silicon Backplane subsystem
Message-Id: <20070801095523.458e00c1.akpm@linux-foundation.org>
In-Reply-To: <200708011133.37214.mb@bu3sch.de>
References: <200707291324.58691.mb@bu3sch.de>
	<20070731202648.e1a8c45f.akpm@linux-foundation.org>
	<200708011133.37214.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 11:33:36 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> > 
> > yup, it's `select':
> > 
> > Selected by: B44 && NETDEVICES && NET_ETHERNET || BCM43XX_MAC80211 && NETDEVICES && !S390 && MAC80211 && WLAN_80211 && EXPERIMENTAL
> > 
> > 
> > Look.  Kconfig's `select' Just.  Does.  Not.  Work.  If you find yourself
> > contemplating using it, please, don sackcloth, take a cold shower and
> > several analgesics, then have another go, OK?
> > 
> > ho hum.
> 
> Ah, yeah. Crap select not caring about dependencies...
> The problem is that people will kill me, if they don't find
> bcm43xx in the kconfig anymore, as they have to enable ssb
> before that. Ya know the flame with Uwe Bugla going crazy
> about that? :D
> Same goes for b44. It was always there in kconfig without
> additional deps, but now (when we merge the b44 port) we would
> need ssb selected before we see b44.

We just don't have a good solution to this.

`select' is bust and it's unobvious how it can _not_ be bust.  If you're
selecting something whose dependencies aren't met, what can we do?  Maybe
select the thing it depends on as well?  What if it depends on (A||B)? 
Which one do we force on?  Screwed.

And hiding options from the users until theyve gone elsewher and selected
something else is most user-hostile.

At least we have menuconfig's "/" command, so if you know the option's name
you can work out why it isn't appearing.

I think what we should do is to continue to offer the unselectable option
in manuconfig and friends, only "greyed out" in some fashion.  So the user
can still navigate to it and select the "what do you depend on" button.

> Maybe default SSB to M?

People would complain about that too.  I don't know what to do, sorry. 
Muddle through :(
