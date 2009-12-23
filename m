Return-Path: <linux-kernel-owner+w=401wt.eu-S1751930AbZLWD7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbZLWD7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 22:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZLWD7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 22:59:43 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55410 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZLWD7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 22:59:42 -0500
Subject: [RFC][PATCH 0/14] Convert remaining arches to
 read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 19:59:22 -0800
Message-ID: <1261540762.3508.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So as the timekeeping system has become more and more generic, folks
have been careful to allow a slow and steady evolution without breaking
all the arches at once, allowing each arch maintainer to convert over to
generic code when they're ready.

However, this slow conversion has forced us to keep multiple methods for
various functionality around, cluttering up the code and making
maintenance more difficult. Further, there's no central road-map or
notification to maintainers on when these new generic functions appear,
so its likely folks wouldn't notice until the old interfaces were
removed.

In this case the generic read_persistent_clock() and
update_persistent_clock() methods have been provided to allow the
generic timekeeping code to initialize xtime and set the persistent
clock when NTP is synced. However many arches haven't converted, so the
generic code has to handle the case where the arch is doing this
management itself.

This patch series tries to convert the following 14 architectures over
to use read_persistent_clock() and update_persistent_clock() as
applicable, killing off about 200 lines of arch specific code.

I'm posting this tonight in somewhat rough form (none of the code has
been compiled or tested) so I can get feedback tomorrow before I'm off
on vacation until the new year. I'd like to get these changes into
2.6.34 so further generic cleanups can be made.

Let me know what you think.

thanks
-john




