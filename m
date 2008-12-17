Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755817AbYLQPzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYLQPzj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 10:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYLQPz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 10:55:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54786 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYLQPz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 10:55:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Evgeniy Polyakov <zbr@ioremap.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [4/7] dst: thread pool.
Date: Wed, 17 Dec 2008 16:55:04 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1229521998-7870-1-git-send-email-zbr@ioremap.net> <1229521998-7870-4-git-send-email-zbr@ioremap.net> <1229521998-7870-5-git-send-email-zbr@ioremap.net>
In-Reply-To: <1229521998-7870-5-git-send-email-zbr@ioremap.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812171655.05020.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18aK6rXQaVhIiHfMF2tZ1z1QtbqsinwbMi9NuD
 2y8wFmdnvSBE+YTXLOUa9ZxRACaZiN9zXxGzcXj0N7rzwIioRG
 lzc6h2zD6E4f+p+b1ECxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2008, Evgeniy Polyakov wrote:
> 
> Thread pool abstraction allows to schedule a work to be performed
> on behalf of kernel thread. One does not operate with threads itself,
> instead user provides setup and cleanup callbacks for thread pool itself,
> and action and cleanup callbacks for each submitted work.
> 
> Each worker has private data initialized at creation time and data,
> provided by user at scheduling time.
> 
> When action is being performed, thread can not be used by other users,
> instead they will sleep until there is free thread to pick their work.
> 
> Thread pool is used for crypto processing of incoming and outgoing IO
> requests to reduce the overall overhead.
> 
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

Have you looked at the last discussion involving thread pools in Linux?
BenH brought up the topic earlier this year, it is archived on
https://lists.linux-foundation.org/pipermail/ksummit-2008-discuss/2008-July/000213.html

So while it seems that there is clearly a use for such infrastructure,
my feeling is that it should not be part of dst, but rather live
in a location where it can be used by every subsystem.

Of course getting it there means another flame war^W^W discussion about what
the right interface should look like.

My personal feeling is that the interface should look a lot like
the existing work queues, to the point where you can easily convert
drivers between them, or even move all work queues over to thread pools.

	Arnd <><
