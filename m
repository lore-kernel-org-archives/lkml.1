Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbXK3Tyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbXK3Tyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 14:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXK3Tyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 14:54:36 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:48344 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbXK3Tyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 14:54:35 -0500
Message-ID: <47506A4F.6010109@keyaccess.nl>
Date: Fri, 30 Nov 2007 20:53:51 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       "yakui.zhao" <yakui.zhao@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@osdl.org>,
       ALSA devel <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sound/isa: kill pnp_resource_change.
References: <474E1189.9030701@keyaccess.nl> <s5hsl2pf8lf.wl%tiwai@suse.de>	 <Pine.LNX.4.61.0711301050540.10769@tm8103.perex-int.cz>	 <s5hy7cgdmcx.wl%tiwai@suse.de>	 <Pine.LNX.4.61.0711301317240.10769@tm8103.perex-int.cz>	 <s5htzn3ewmx.wl%tiwai@suse.de>	 <Pine.LNX.4.61.0711301428241.10769@tm8103.perex-int.cz>	 <4750461E.2040104@keyaccess.nl> <1196444387.23251.332.camel@queen.suse.de>
In-Reply-To: <1196444387.23251.332.camel@queen.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-11-07 18:39, Thomas Renninger wrote:

> On Fri, 2007-11-30 at 18:19 +0100, Rene Herman wrote:

>> Thomas Renninger is making some haste with the deprecation of the removed 
>> functions by the way -- I just saw a patch of his entering my mailbox where 
>> he says he'd in fact like them deprecated in 2.6.24 already. The ALSA 
>> removal would not seem likely to be scheduled to go to 2.6.24 yet, so I 
>> guess that won't do?
>>
>> I have no opinion on the schedule -- but Thomas, if you do, I guess you'd 
>> need to convince Jaroslav to withstand The Wrath Of Linus and ask him to 
>> push it. We can't have it deprecated (on the "spew warnings" level) with 
>> ALSA still using them in 2.6.24.
> 
> Why not?
> The intend of __deprecated is to throw some compile warnings?
> In this case it would warn on the official 2.6.24 on functions which are
> known to be reverted already for the next cycle (this should not hurt?),

It does. A clean build is not about esthetics but about quality. Warnings 
that are to be ignored hide warnings that are not to be, not just in the 
sense of the output but due to humans actively tuning out the noise after 
just a few. I'd hate for sound/isa to add to the noise.

> it's more for drivers building against kernel headers getting noticed as
> soon as possible...
> 
> If this is not added to 2.6.24, the funcs should live there for another
> kernel cycle just to not print some irrelevant warnings at compile time
> things are slowed down...

This makes sense if someone told you that the deprecation period for 
exported symbols is one kernel cycle but who did?

Anyways, two things:

The number of out of tree users of these symbols is very close to zero and 
quite possibly if not likely _at_ zero after I've cleaned up the couple of 
half-hearted ALSA ISAPnP drivers that I keep in a few local branches here.

As such, and given that removing them apparently clears the path for a long 
overdue and welcome PnP cleanup, simply yanking them soon would get my ack.

Second, as said, speak to Jaroslav as well I guess.

> This is also in vanilla and lives there for some time?:
> kernel/power/pm.c:205: warning: ‘pm_register’ is deprecated (declared at kernel/power/pm.c:64)
> kernel/power/pm.c:205: warning: ‘pm_register’ is deprecated (declared at kernel/power/pm.c:64)
> kernel/power/pm.c:206: warning: ‘pm_send_all’ is deprecated (declared at kernel/power/pm.c:180)
> kernel/power/pm.c:206: warning: ‘pm_send_all’ is deprecated (declared at kernel/power/pm.c:180)

Exactly, and serves as a perfect reminder of why noone should ever be 
allowed to deprecate anything until after removing all in tree users.

Rene.
