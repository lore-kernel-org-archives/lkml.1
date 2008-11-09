Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYKIU2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYKIU2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755914AbYKIU2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:28:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:53669 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbYKIU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:28:33 -0500
Date: Sun, 9 Nov 2008 12:28:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109122835.10f410fa@infradead.org>
In-Reply-To: <20081109200918.GA4361@ics.muni.cz>
References: <20081104173300.GF6134@ics.muni.cz>
	<20081109105159.GA5867@joi>
	<20081109113304.GE4353@ics.muni.cz>
	<200811091424.10943.rjw@sisk.pl>
	<20081109200918.GA4361@ics.muni.cz>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 21:09:18 +0100
Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> On Sun, Nov 09, 2008 at 02:24:10PM +0100, Rafael J. Wysocki wrote:
> > > > Do you have NO_HZ enabled?
> > > > (Cc'ing Thomas)
> > > 
> > > indeed, I have. Should I try it without NO_HZ?
> > 
> > Yes, please.
> 
> I tried it, it is not better. I/O operations on /dev/sda1 often
> require a key hit. It is AHCI driver.

just as a status on this guy:

1) we know what to remove to make it go away and go back to 2.6.27
status.
However we think it just papers over a bug elsewhere
2) Thomas did a lot of work and has a set of bugfixes to hrtimers and
related that fix a bunch of cases and MIGHT fix this one too (we
haven't been able to reproduce it but there's several reports out for
this "wait until hitting a key")

for me, the plan is that we need to get Thomas' fixes tested by someone
who can reproduce this very reliably. If they fix it, great.
If they don't, time is running out and we need to remove the feature
for 2.6.28 (that is 1 line of change), realizing that this just papers
over stuff and isn't a real fix, and get back to it for 2.6.29.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
