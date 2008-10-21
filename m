Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbYJUTdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbYJUTdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYJUTdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:33:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54881 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYJUTdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:33:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Date: Tue, 21 Oct 2008 21:37:56 +0200
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
References: <20081017171139.GA1792@elte.hu> <87r66ejqla.fsf@basil.nowhere.org> <20081021111716.GA4476@elte.hu>
In-Reply-To: <20081021111716.GA4476@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810212137.58020.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 21 of October 2008, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > >   *	acpi_pm_disable_gpes - Disable the GPEs.
> > >   */
> > > -static int acpi_pm_disable_gpes(void)
> > > +static inline int acpi_pm_disable_gpes(void)
> > 
> > Just to satisfy my curiosity, what compiler warning does marking 
> > functions inline fix?
> 
> the commit log below explains the situation. The warning exposed a maze 
> of #ifdefs in drivers/acpi/sleep/main.c. It's not the warning we need to 
> "fix" but that maze, obviously.

Thanks a lot for _not_ CCing me. :-(
 
> -------------------------------------------->
> From 6ddae344a73fcff60c840dd4e429bf55562b41f3 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 17 Oct 2008 15:44:22 +0200
> Subject: [PATCH]  #ifdef complications in drivers/acpi/sleep/main.c
> 
> this warning:
> 
>   drivers/acpi/sleep/main.c:67: warning: ‘acpi_pm_disable_gpes’ defined but not used
>   drivers/acpi/sleep/main.c:92: warning: ‘acpi_pm_prepare’ defined but not used
>   drivers/acpi/sleep/main.c:107: warning: ‘acpi_pm_finish’ defined but not used
>   drivers/acpi/sleep/main.c:128: warning: ‘acpi_pm_end’ defined but not used
> 
> Shows that this code has an identity crisis due to a maze of #ifdefs, in
> the PM_SLEEP && !SUSPEND && !HIBERNATION case for example.

This case is invalid, because PM_SLEEP == SUSPEND || HIBERNATION !
 
I don't know how you managed to get
(PM_SLEEP && !SUSPEND && !HIBERNATION), but _that_ shouldn'd be possible in the
first place.

If there are warnings in any other case, please let me know and I'll fix them,
but please don't mess up with that code like this without letting me know.

Thanks,
Rafael
