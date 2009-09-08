Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZIHEvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZIHEvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 00:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZIHEu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 00:50:59 -0400
Received: from bu3sch.de ([62.75.166.246]:49667 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZIHEu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 00:50:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: rostedt@goodmis.org
Subject: Re: Stop using tasklets for bottom halves
Date: Tue, 8 Sep 2009 06:50:41 +0200
User-Agent: KMail/1.9.9
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Matt Smith <Matt.Smith@atheros.com>, Kevin Hayes <kevin@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, ic.felix@gmail.com
References: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com> <20090907171406.6a4b6116@nehalam> <1252376254.21261.2052.camel@gandalf.stny.rr.com>
In-Reply-To: <1252376254.21261.2052.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909080650.43181.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 September 2009 04:17:34 Steven Rostedt wrote:
> > Process context is too slow.
> 
> Well, I'm hoping to prove the opposite. I'm working on some stuff that I
> plan to present at Linux Plumbers. I've been too distracted by other
> things, but hopefully I'll have some good numbers to present by then.

I recently converted the b43 driver to threaded interrupt handlers and
a workqueue based TX mechanism. (My motivation was porting b43 to the SDIO bus that
needs to sleep, so requires process context).

There are two things that I noticed. When looking at the "idle" percentage in "top"
it regressed quite a bit when using threaded IRQ handlers. It shows about 8% less
idle. This is with threaded IRQs patched in, but without WQ TX mechanism. Applying
the WQ TX mechanism does not show any noticeable effect in "top".

I'm not quite sure where the 8% slowdown on threaded IRQ handlers come from. I'm not
really certain that it's _really_ a regression and not just a statistics accounting quirk.
Why does threaded IRQs slow down stuff and threaded TX does not at all? That does not
make sense at all to me.

I think there's no real reason for process context being slow in general. It's just that
we have additional context switches. But these are fast on Linux.

-- 
Greetings, Michael.
