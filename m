Return-Path: <linux-kernel-owner+w=401wt.eu-S1765295AbXFESta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765295AbXFESta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759850AbXFEStV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:49:21 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:37400 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759489AbXFEStU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:49:20 -0400
In-Reply-To: <1181058836.16089.23.camel@hades.cambridge.redhat.com>
References: <20070603183845.GA8952@lazybastard.org> <20070603184205.GE8952@lazybastard.org> <200706032342.27252.arnd@arndb.de> <20070604091245.GF14823@lazybastard.org> <1180964303.25232.358.camel@pmac.infradead.org> <18f622d94e9273fe6c93ef091fcec87c@kernel.crashing.org> <1181058836.16089.23.camel@hades.cambridge.redhat.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <db91817d295770e459727005108b05e2@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Kyle Moffett <mrmacman_g4@mac.com>, John Stoffel <john@stoffel.org>,
       Willy Tarreau <w@1wt.eu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       CaT <cat@zip.com.au>, Ondrej Zajicek <santiago@crfreenet.org>,
       linux-kernel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>, Dongjun Shin <djshin90@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Arnd Bergmann <arnd@arndb.de>,
       Albert Cahalan <acahalan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org,
       Artem Bityutskiy <dedekind@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Pavel Machek <pavel@ucw.cz>, Ulisses Furquim <ulissesf@gmail.com>,
       akpm@osdl.org, David Weinehall <tao@acc.umu.se>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [Patch 04/18] include/linux/logfs.h
Date: Tue, 5 Jun 2007 20:49:09 +0200
To: David Woodhouse <dwmw2@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> It would be better if GCC had a 'nopadding' attribute which gave us
>>> what we need without the _extra_ implications about alignment.
>>
>> That's impossible; removing the padding from a struct
>> _will_ make accesses to its members unaligned (think
>> about arrays of that struct).
>
> It _might_ make accesses to _some_ of its members unaligned.

It _will_ make accesses to _at least one_ of the members
unaligned, in the second array element.

> That's why I said 'without the __EXTRA__ implications about alignment'.
>
> Obviously the lack of padding has its own implications, but we don't
> necessarily need to assume that the struct may be at arbitrary
> locations.

The compiler does though, if it can't prove otherwise.

What would "nopadding" buy us, anyway?


Segher

