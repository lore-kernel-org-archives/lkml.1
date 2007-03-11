Return-Path: <linux-kernel-owner+w=401wt.eu-S933149AbXCKLjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149AbXCKLjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933264AbXCKLjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:39:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:47400 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933149AbXCKLjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:39:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/sRzcWSA3sL8bohpAV0B2X8wMvOKtbIbRcUeX/Eu
	Cj5P/3gMwkg/6o
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200703111457.17624.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 12:39:09 +0100
Message-Id: <1173613149.6927.29.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Con,

On Sun, 2007-03-11 at 14:57 +1100, Con Kolivas wrote:
> What follows this email is a patch series for the latest version of the RSDL 
> cpu scheduler (ie v0.29). I have addressed all bugs that I am able to 
> reproduce in this version so if some people would be kind enough to test if 
> there are any hidden bugs or oops lurking, it would be nice to know in 
> anticipation of putting this back in -mm. Thanks.
> 
> Full patch for 2.6.21-rc3-mm2:
> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.29.patch

I'm seeing a cpu distribution problem running this on my P4 box.

Scenario:
listening to music collection (mp3) via Amarok.  Enable Amarok
visualization gforce, and size such that X and gforce each use ~50% cpu.
Start rip/encode of new CD with grip/lame encoder.  Lame is set to use
both cpus, at nice 5.  Once the encoders start, they receive
considerable more cpu than nice 0 X/Gforce, taking ~120% and leaving the
remaining 80% for X/Gforce and Amarok (when it updates it's ~12k entry
database) to squabble over.

With 2.6.21-rc3,  X/Gforce maintain their ~50% cpu (remain smooth), and
the encoders (100%cpu bound) get whats left when Amarok isn't eating it.

I plunked the above patch into plain 2.6.21-rc3 and retested to
eliminate other mm tree differences, and it's repeatable.  The nice 5
cpu hogs always receive considerably more that the nice 0 sleepers.

	-Mike

