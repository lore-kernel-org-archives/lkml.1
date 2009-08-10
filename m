Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZHJP23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZHJP23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZHJP21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:28:27 -0400
Received: from ru.mvista.com ([213.79.90.228]:11245 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755398AbZHJP2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:28:25 -0400
Date: Mon, 10 Aug 2009 19:28:25 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: power_supply class/framework question
Message-ID: <20090810152825.GA4624@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <a55d774e0908071919s7b365f84o3baa19c8d6fbe899@mail.gmail.com>
 <20090810150011.GA1471@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090810150011.GA1471@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 05:00:11PM +0200, Pavel Machek wrote:
> Hi!
> 
> > (feel free to redirect me to a different mailing list if there's a
> > more appropriate place to ask this question)
> > 
> > I'm working on cleaning up some code to more correctly use the power
> > supply framework (have the battery driver receive notification from
> > the wall/usb power supplies, etc), and ran into a slight snag.  For
> > mobile usb powered devices, we need to know how much current can
> > safely be consumed by the charge circuit -- generally this is one of:
> > none, <500mA or 1000mA, which correspond to "no power supply", "usb
> > power supply", or "wall power supply".
> 
> Actuallly, it is one of 'none', 100mA (min power USB has to supplly),
> 500mA (max powe USB can supply by spec), 1A (wall).
> 
> For example sharp zaurus can only supply cca 300mA out of its port.
> 
> > I can use power_supply_am_i_supplied() to determine if I'm receiving
> > power, but there's no way to determine either how much (if I have one
> > power supply that indicates max current available) or which supply (if
> > I define a separate "ac" and "usb" power supply).
> 
> Should am_i_supplied() just return miliamps?

Or enum power_supply_type, with the following priority:
mains (wall), usb, battery?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
