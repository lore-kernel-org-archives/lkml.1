Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYKCRcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYKCRcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYKCRcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:32:39 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:8060 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751374AbYKCRci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:32:38 -0500
Date: Mon, 3 Nov 2008 20:32:37 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] power_supply: only register tosa_battery driver on tosa
Message-ID: <20081103173237.GA13733@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com> <bc64b4640811021236t3458bf69vd1becc4ab1133be1@mail.gmail.com> <20081103145514.GA23466@oksana.dev.rtsoft.ru> <bc64b4640811030820j660b8386x39bf2285b1dba887@mail.gmail.com> <20081103162547.GA25546@oksana.dev.rtsoft.ru> <bc64b4640811030841h5bcc537fy4b645c6d293b7b46@mail.gmail.com> <20081103165820.GA8004@oksana.dev.rtsoft.ru> <bc64b4640811030909s5bbb05dao9f83523aac9dd8ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <bc64b4640811030909s5bbb05dao9f83523aac9dd8ef@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 08:09:14PM +0300, Dmitry wrote:
[...]
> >> Yup.
> >> I see few ways to resolve this:
> >> * write better wm97xx interface. Dunno if that is feasible or possible.
> >>   One of the possible solutions is to pass battery and ts device names
> >>   and data from within board data via ac97 layer to wm97xx-core. This
> >>   will provide several benefits (e.g. then we can drop lots of parameters
> >>   from wm97xx-core, which are really board parameters).
> >
> > That would be great indeed. But for now, just don't compile the two
> > drivers on the tosa platform. No need for machine_is_*() hacks...
> 
> That is a bit strange requirement. During several past months there was
> a lot of efforts put into supporting multi-machine PXA kernel images.

Yes, I know this.

But you're implementing hacks instead of fixing the problem.

Btw, you inserted the machine_is() into the tosa driver, but
wm97xx driver registers unconditionally. That could be a problem
when wm97xx loads first, and then you try to load the tosa_battery
module on tosa machine.

Let's insert machine_is() hack into the wm97xx driver as well?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
