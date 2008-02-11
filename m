Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYBKMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYBKMXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 07:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYBKMXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 07:23:06 -0500
Received: from qult.net ([82.238.217.46]:52157 "EHLO slartibartfast.qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbYBKMXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 07:23:03 -0500
Date: Mon, 11 Feb 2008 13:23:00 +0100
From: Ignacy Gawedzki <lkml@qult.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops with hostap_pci (?)
Message-ID: <20080211122300.GA13931@zenon.in.qult.net>
Mail-Followup-To: Ignacy Gawedzki <lkml@qult.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080211031935.GA12563@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211031935.GA12563@zenon.in.qult.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 04:19:35AM +0100, thus spake Ignacy Gawedzki:
> Hi,
> 
> A few days back I started having strange lockups on a gateway machine so I
> started looking at things.  Then I compiled the 2.6.24.1 kernel and started
> having oopses not long after upping the wlan0 (hostap_pci) interface.
> 
> So I enabled netconsole and got a few logs.  Now the sad point is that I'm
> getting an oops even with my older kernel which used to be fine (2.6.23.9).  I
> also checked with 2.6.24 and the effects are the same: I boot, I up the wlan0
> interface and a few seconds or minutes later, boom!  Sometimes only rmmod'ing
> hostap_pci triggers the oops.  I'm suspecting some hardware problem and have
> already checked the ram with memtest86+ and tested with only one memory module
> out of two plugged: same thing.
> 
> If anybody could take a look at these and shed some light on that issue...

Okay, false alarm... it's all my fault. :/

The cause of the problem was my previous tampering with udev rules.  The udev
rules as such (on Ubuntu Gutsy) were bad for hostapd, since persistent rules
were written for the wlan0ap interface name created by hostapd.  So I changed
a few things that had the unexpected effect of renaming the initial
hostap_pci's wifi0 into wlan0ap.  This in turn made hostap_pci oops in many
cases.

Anyway, I've modified my udev rules again and hopefully this will be it. =)

-- 
 "The whole problem with the world is that fools and fanatics are
   always so certain of themselves, and wiser people so full of doubts."
                                                 - Bertrand Russell
