Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbYKUSs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbYKUSs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbYKUSsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:48:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:63524 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYKUSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:48:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [take 3] Use pid in inotify events.
Date: Fri, 21 Nov 2008 19:39:45 +0100
User-Agent: KMail/1.9.9
Cc: John McCutchan <john@johnmccutchan.com>, mtk.manpages@gmail.com,
       Christoph Hellwig <hch@lst.de>, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net>
In-Reply-To: <20081120230612.GB6536@ioremap.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811211939.46812.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX183Z/hWV58zTcA0vxlYUttroBmx4rEIAznVZSz
 yhjz0IdZUsUjl7vBnkTjBIVKMFOxVThGUqHyoMf4yyZxV0FHMG
 4Enqh8WP4/joyD/7wvoUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2008, Evgeniy Polyakov wrote:
> I have a network server, which gets IO requests from different clients
> and maintains coherency of the data between them, but if file is
> modified locally I want to flush or invalidate remote data. I decided
> not to dig into the kernel on the server node and use inotify to get
> notifications about events, but there is no way to determine if given IO
> was originated by server itself (and in this case nothing should be
> done), or by external application which accesses exported directory (and
> in this case I should send update messages to clients).

The how about an inotify_init1 flag telling the kernel to ignore
changes done by the current PID? That sounds like it is potentially
useful to other applications that want to monitor the whole file system
and also write to it. It also doesn't need to change the ABI in
incompatible ways or introduce a security relevant side channel.

	Arnd <><
