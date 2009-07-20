Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZGTDV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZGTDV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 23:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZGTDVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 23:21:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847AbZGTDVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 23:21:25 -0400
Date: Sun, 19 Jul 2009 20:20:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhaolei" <zhaolei@cn.fujitsu.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <hirofumi@mail.parknet.co.jp>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add function to convert between calendar time
 andbroken-down time for universal use
Message-Id: <20090719202018.497f7ec1.akpm@linux-foundation.org>
In-Reply-To: <04e101ca08e5$be078fa0$808410ac@zhaoleiwin>
References: <4A5C3BC0.6020701@cn.fujitsu.com>
	<20090714151040.b7b3b26d.akpm@linux-foundation.org>
	<20090718115019.GH1433@ucw.cz>
	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 10:56:55 +0800 "Zhaolei" <zhaolei@cn.fujitsu.com> wrote:

> * From: "Pavel Machek" <pavel@ucw.cz>
> >> > +extern void gmtime(__kernel_time_t totalsecs,
> >> > +        unsigned int *year, unsigned int *mon, unsigned int *mday,
> >> > +        unsigned int *hour, unsigned int *min, unsigned int *sec,
> >> > +        unsigned int *wday, unsigned int *yday);
> >> > +extern void localtime(__kernel_time_t totalsecs,
> >> > +        unsigned int *year, unsigned int *mon, unsigned int *mday,
> >> > +        unsigned int *hour, unsigned int *min, unsigned int *sec,
> >> > +        unsigned int *wday, unsigned int *yday);
> > 
> > 
> > Should year/mon/.../yday be passed up as a structure?
> 
> Hello, Pavel
> 
> Thanks for your attention.
> 
> Actually, I considered to introduce a struct as your think, but finally I
> choose to use arguments list instead of a struct, because:
> 1: User can easy to call this function without define a struct
> 2: Get rid of adding a additional struct into kernel
> 
> In fact, I think both(use a struct or not) should be ok.

Using a struct will generate better code at caller sites and possibly
at the called site too.  The compiler doesn't need to marshal those
eight pointers on the stack (or wherever the architecture puts them),
possibly less registers will be consumed, etc.  And it'll use less
stack space.

So I do think it would be better from that point of view.

However it will probably require much more code change at the call
sites.  But those changes will be simple, and probably a good thing
regardless.


