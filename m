Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZA1MlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZA1MlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 07:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZA1MlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 07:41:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51383 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZA1MlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 07:41:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
Date: Wed, 28 Jan 2009 13:37:51 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <1233106614.3256.6.camel@localhost.localdomain>
In-Reply-To: <1233106614.3256.6.camel@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901281337.52294.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0R9DnUAxiP3pDzEfZX9BuWBz0IirK/RRcgxr
 n3C2FkoGu7Tep9X15YHd/PPfpcF5QFrcBpKQ42UNtZ2y1AInug
 utbnnttEPL4rSJ8u2qEAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009, Jaswinder Singh Rajput wrote:
> If we do not want to export __arch_swab32 and __arch_swab64 then we can
> put whole block in #ifdef __KERNEL__ then we will get rid of above
> solution.

For the specific x86 swab code, that would certainly be the simplest
way, user space should not be using those inline assemblies either
way.

I think the more interesting question is whether we want to export
*any* inline helpers that are not part of the ABI to user space.
We already killed most of them (spinlocks, atomics, ...) and what
remains is basically just the byteorder code. All that is required
for the ABI is the information whether the system is big- or
little-endian, but not all the rest.

	Arnd <><
