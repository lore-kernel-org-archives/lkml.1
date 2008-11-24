Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbYKXHad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbYKXHad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 02:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYKXHaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 02:30:24 -0500
Received: from tservice.ru ([195.178.208.66]:46602 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbYKXHaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 02:30:24 -0500
Date: Mon, 24 Nov 2008 10:30:19 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: John McCutchan <john@johnmccutchan.com>
Cc: Arnd Bergmann <arnd@arndb.de>, mtk.manpages@gmail.com,
       Christoph Hellwig <hch@lst.de>, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081124073018.GC10119@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de> <20081122093749.GA12543@ioremap.net> <cfec22b10811232108u3ade8b66w58999054c03549fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfec22b10811232108u3ade8b66w58999054c03549fc@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John.

On Sun, Nov 23, 2008 at 09:08:05PM -0800, John McCutchan (john@johnmccutchan.com) wrote:
> At this point I don't really want to see changes made to inotify. But,
> for arguments sake, why not something like inotify_init1 that takes a
> flag EXTENDED_EVENT which causes a larger event structure to be used.
> Something like,
> 
> struct inotify_event_extended
> {
>   s32 wd;
>   u32 mask;
>   u32 cookie;
>   u32 data[4];
>   char path[0];
> }
> 
> The data array could be used to store arbitrary extra information,
> specified by flags.

What will happen when above array is not enough to store needed info?
Although I do not see any reason to send start/offset for the IO itself,
but if it will be decided to do so, above array already is not large
enough. I think I will cook up preliminary patch to add nested
attributes into event structure like I described previously in the
thread to get people involved with working example.

-- 
	Evgeniy Polyakov
