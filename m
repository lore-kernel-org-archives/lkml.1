Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbYD3Reu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbYD3Reu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 13:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbYD3Rek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 13:34:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43602 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbYD3Rej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 13:34:39 -0400
Subject: Re: [rtc-linux] Re: [PATCH] RTC class driver for ppc_md RTC
	functions
From: David Woodhouse <dwmw2@infradead.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080430113933.14651edc@i1501.lan.towertech.it>
References: <18449.48370.434716.293552@cargo.ozlabs.ibm.com>
	 <20080428102629.6e702137@i1501.lan.towertech.it>
	 <1209371478.25560.114.camel@pmac.infradead.org>
	 <20080428105245.5c9fff85@i1501.lan.towertech.it>
	 <1209378191.25560.121.camel@pmac.infradead.org>
	 <20080428124033.70e78dcf@i1501.lan.towertech.it>
	 <1209380882.25560.127.camel@pmac.infradead.org>
	 <20080430113933.14651edc@i1501.lan.towertech.it>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 18:34:33 +0100
Message-Id: <1209576873.25560.398.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 11:39 +0200, Alessandro Zummo wrote:
> On Mon, 28 Apr 2008 12:08:02 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > 
> > I suspect that actually covers quite a lot of devices, but the RTC class
> > could happily cope with other types of devices too -- just giving an
> 
>  If we are talking about milliseconds I think a suspect is not enough.

Let me rephrase: This is how we're doing it for _every_ machine/platform
which supports update_persistent_clock(). It makes sense to let
individual RTC-class drivers do it differently if they need to, but it's
a damn good default behaviour until/unless someone actually shows that
they need it to be different. :)

>  The hardware RTC does not need to be updated every time the system
>  clock is. In fact, as long as the system is running, it's pretty useless.
> 
>  Most distributions update the RTC from the system timer on shutdown.

You're assuming that the machine will shut down in an orderly fashion. 

And the update from userspace, if enabled, will never be as accurate as
the one we do from the kernel. We currently go to great pains to ensure
that it happens at precisely the right time, and that's really only
feasible from within the kernel.

>  This kind of update will also be unreliable on any not-memory-mapped
>  RTC (think of SPI and I2C) .

It's still much more reliable from the kernel than it is from userspace.

>  My opinion is that such NTP mode could be removed from the kernel/not
>  implemented in rtc class without loosing anything.

Want to send a patch to lkml which removes update_persistent_clock() and
see what people think of that? :)

-- 
dwmw2

