Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXEEQQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXEEQQn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbXEEQQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:16:42 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:58733
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbXEEQQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:16:41 -0400
Message-ID: <463C8D42.7020707@microgate.com>
Date: Sat, 05 May 2007 07:57:22 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt add compat_ioctl
References: <1178215277.4369.6.camel@amdx2.microgate.com> <20070503175305.e46ed8b7.akpm@linux-foundation.org> <463BA0D8.3050403@microgate.com> <200705051258.01743.arnd@arndb.de>
In-Reply-To: <200705051258.01743.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 04 May 2007, Paul Fulghum wrote:
>>> - It is fishy that apart from one outlier in kexec.h, synclink.h is the
>>>   only header file which uses compat_ulong_t.  Are we doing this right?
>> Arnd, do you have any comment on this?
> 
> I think most others just define the compat data structures in the
> same file that implements the headers, inside the same #ifdef that
> hides the functions using them.
> This makes sense, because the data structures here don't define
> an interface, but rather describe what the interface looks like
> in the 32 bit case.

OK, moving the compatible structure declarations from the header
to the individual source files will fix all the header mess and
the odd compilation errors on i386 when using the compat.h header
inside of another header.

That declaration will need to be duplicated in each driver that
uses it (4 drivers in my case). In that sense (a structure declaration
used by multiple code modules) it does seem like an interface definition.

If that is what is needed, I will do it.

--
Paul

