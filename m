Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbZLUI5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbZLUI5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 03:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZLUI5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 03:57:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51858 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZLUI5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 03:57:21 -0500
Date: Mon, 21 Dec 2009 09:57:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the
	Linux Kernel
Message-ID: <20091221085713.GA1622@ucw.cz>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Google is implementing power capping, a technology that improves the
> power efficiency of data centers. There are also some interesting
> applications of this technology for laptops and cell phones.  Google
> aims to send most of its Linux technology upstream. So, how can we get
> this feature into the mainline kernel?
...
> Aside from this, every cgroup has a new quantity added to the CPU
> component called "Power Capping Priority".  This quantity indicates
> the order in which the scheduler attributes the time spent injecting
> idle cycles to specific processes.  This allows us to discriminate
> among processes when it comes to accounting for the injected idle
> time.  There is also an indication of interactivity versus batch for
> the cgroup provided in the CPU component of the cgroup.
> 
> Basic Algorithm:
> 
> Rather than blindly blasting the machine with the minimum required
> idle cycles, our implementation keeps track of naturally occurring
> idle cycles as follows:

(Rather complex algorithm snipped)

Well.. having all this complexity just for forcing idle... And it
still will not work, right? Linux kernel is not real time, so you
can't guarantee anything.

OTOH realtime people already have tools you could make good use of:
your power capping approach looks like 'high priority idle task that
needs to run for 2 seconds every 5 seconds' or something...

Talk to rt people?
								Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
