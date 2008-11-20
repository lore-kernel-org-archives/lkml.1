Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYKTXGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYKTXGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKTXGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:06:16 -0500
Received: from cet.com.ru ([195.178.208.66]:33828 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbYKTXGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:06:15 -0500
Date: Fri, 21 Nov 2008 02:06:12 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: John McCutchan <john@johnmccutchan.com>
Cc: mtk.manpages@gmail.com, Christoph Hellwig <hch@lst.de>,
       Robert Love <rlove@rlove.org>, linux-api@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [take 3] Use pid in inotify events.
Message-ID: <20081120230612.GB6536@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081118131937.GC16944@lst.de> <20081119140500.GA25968@ioremap.net> <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222@mail.gmail.com> <20081119145351.GA2652@ioremap.net> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John.

On Thu, Nov 20, 2008 at 02:34:11PM -0800, John McCutchan (john@johnmccutchan.com) wrote:
> I really don't like the idea of overloading the cookie field to store
> the pid for only the events that don't already use the cookie field.

Adding PID or whatever else will not be used most of the time either.
I agree, that having new protocol (which so far did not get any
extensions except what I described for my own application) looks
cleaner, but if no one will use it, and existing extension works for
everyone (nothing breaks), I'm trying to push this idea up.

So, except theoretical clearness of the unused-by-everyong idea,
what forces you to think, that new inotify should be implemented?

> Coming into this late, maybe I missed it but can you explain why you
> need the pid that caused the event?

I have a network server, which gets IO requests from different clients
and maintains coherency of the data between them, but if file is
modified locally I want to flush or invalidate remote data. I decided
not to dig into the kernel on the server node and use inotify to get
notifications about events, but there is no way to determine if given IO
was originated by server itself (and in this case nothing should be
done), or by external application which accesses exported directory (and
in this case I should send update messages to clients).

-- 
	Evgeniy Polyakov
