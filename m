Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZAaBHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZAaBHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 20:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZAaBG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 20:06:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:55280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbZAaBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 20:06:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] kbuild: drop check for CONFIG_ in headers_check
Date: Sat, 31 Jan 2009 02:06:40 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1233342254.21493.8.camel@localhost.localdomain> <200901310127.03142.arnd@arndb.de> <20090131004111.GB13709@elte.hu>
In-Reply-To: <20090131004111.GB13709@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901310206.41053.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18j+x0W7YOprhlv7V9eAJ41ZeSz9vrBux6Uwh1
 x1lU0VVbFUyPoXM+BGvktog1uN5h35SWeZOr4rw6usSaqAmg0j
 Rrg3fnCJdgQtK7yVGpWWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 January 2009, Ingo Molnar wrote:
> hm, that looks quite ugly and unnatural. Could the usr/* exporting scripts 
> convert these types automatically to the __kernel_* versions?

It's possible, but there are some minor complications, e.g. linux/coda.h has
its own magic code that would likely break in the process, so it needs
to be skipped. Some other files conditionally include <sys/types.h> or
<stdint.h> in user space and would break in a similar way.

For the __kernel_ types, we have 87 instances in the tree, and 53 more that
would have to change. For the int types, there are over 4000 instances
of the correct __u32 style and about 800 that use the u_int32_t or
uint32_t style, most of them in netfilter and linux/pfkeyv2.h.

I'd probably leave at least the drm, netfilter and mtd headers alone,
as they are known to be working and consistently use the stdint.h types.

	Arnd <><
