Return-Path: <linux-kernel-owner+w=401wt.eu-S932610AbXBUVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbXBUVu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626AbXBUVu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:50:28 -0500
Received: from dev.kryptiva.com ([69.70.52.243]:18700 "EHLO mail.kryptiva.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932610AbXBUVu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:50:26 -0500
Message-ID: <45DCC24B.4040204@kryptiva.com>
Date: Wed, 21 Feb 2007 17:06:03 -0500
From: Karim Yaghmour <karim.yaghmour@kryptiva.com>
Reply-To: karim.yaghmour@kryptiva.com
Organization: Kryptiva Inc.
User-Agent: Thunderbird 1.5.0.8 (X11/20061107)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       systemtap@sources.redhat.com, ltt-dev@shafik.org
Subject: Re: [PATCH 05/05] Linux Kernel Markers, non optimized architectures
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <1171224209195-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231635.091c7169.akpm@linux-foundation.org> <20070215190919.GA31359@Krystal> <45D61361.6030200@kryptiva.com> <20070216233825.GB28087@Krystal> <45DCA6E1.7080903@kryptiva.com> <20070221204535.GA616@Krystal>
In-Reply-To: <20070221204535.GA616@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- KRYPTIVA PACKAGED MESSAGE -----
PACKAGING TYPE: SIGNED

Mathieu Desnoyers wrote:
 > The problem with your proposal, I guess, is that people will have to add a supplementary parameter to the macro.
 >
 > It is not uncommon to have two slightly versions of macros/functions in the kernel (preempt_enable()/preempt_enable_no_resched(), or macros starting with underscores). Normally, the underscore states that the macro does not do the proper locking itself (this is not our case). Therefore, I would suggest using a name that suggests against what the macro is protected. For instance, a marker
 > pointing to the generic version is only needed to protect against the debug trap handler and should only be used on x86 and x86_64.

I can see your point, to a degree. The difference here is that the
variants you mention are actually macros that do something, they
aren't stubs for code. IOW, you actually know what's happening
underneath a foo() vs. _foo() by its name only. Maybe this applies
the same to markers, I don't know. But maybe we want to make it
easy for those looking at markers that there's a master kill
switch somewhere that all markers go through and through which
they can all be disabled very simply (say by using a "#if 0").
While different names *may* be doing that, a same name *does* that.
But I don't feel too strongly either way, it's really up to those
who maintaining the code to say.

Karim

----- KRYPTIVA SIGNED MESSAGE -----
This email claims to have been packaged by Kryptiva.
To process this email and authenticate its origin, get
the free plugin from:
http://www.kryptiva.com/downloads

----- KRYPTIVA SIGNATURE START -----
AvWVqAAAAAIAAAABAAAAAAAATiACAQAAAAC3AQAIAAAAAgAAAAECABTXxT4xHdR4/1uU1hL2
+TaPrqNB0wMAFNa8GHXZWJH5Dz+D76vfh6JhvWLvBAAUpuIZcCAkCC+ldyaBuoAWxK50HiQF
ABRI38gc/foDHQsS6X3W0VP4xTukBwYAFB0lithGcxNZYBHaLDONjp6eo/LoBwAUpXC6F2jf
nElq3fnZQpGW97Fk/2QRABgAAAAAAABOIEXcvqAADJ5wAAAAAAAAAB4TAAQAAAAAAAAAggP/
RQ/W0H9H9bhrZyC67an//DbWC4D38PgLoeMG6Tjvx7jWTpEh79DeQ/+sbb9aYZvbwYwtaVaJ
VuPEiRnPZX0mqnOFm+GDzE9jB6202lR0Nzczh1WCifbrrXI7CSEjOwI3ve0jcCoGxTEzZRYj
LGxuubV8Hh5HU12zi3Mxgdz031Y=
----- KRYPTIVA SIGNATURE END -----
