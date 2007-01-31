Return-Path: <linux-kernel-owner+w=401wt.eu-S1750889AbXAaP1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889AbXAaP1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 10:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXAaP1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 10:27:24 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:16372 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXAaP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 10:27:23 -0500
Subject: Re: [PATCH 09/23] clocksource: add block notifier
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070131101710.GB22377@elte.hu>
References: <20070131033710.420168478@mvista.com>
	 <20070131033805.815147778@mvista.com>  <20070131101710.GB22377@elte.hu>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 07:25:52 -0800
Message-Id: <1170257152.9781.36.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 11:17 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Adds a call back interface for register/rating change events. This is 
> > also used later in this series to signal other interesting events.
> 
> This patch adds:
> 
> > +#define CLOCKSOURCE_NOTIFY_REGISTER	1
> > +#define CLOCKSOURCE_NOTIFY_RATING	2
> > +#define CLOCKSOURCE_NOTIFY_FREQ		4
> 
> and a later patch adds:
> 
> > +#define CLOCKSOURCE_NOTIFY_UNSTABLE	8
> 
> while i tentatively agree with the introduction of clocksource driver 
> notifications in general (given any actual real users of that 
> infrastructure), i can see three problems with your notifier changes:
> 
> firstly, with the full changes applied, CLOCKSOURCE_NOTIFY_RATING is 
> totally unused (and not even driven by the core clocksource code).

True, ratings are constant so the notification never happens (and never
needs to)

> secondly, CLOCKSOURCE_NOTIFY_REGISTER is only used by the core 
> clocksource code and no register-notifier interface is exposed: this 
> makes the whole thing an expensive NOP.

I don't know what you mean when you say "no register-notifier interface
is exposed" .. The timekeeping code doesn't use this notification , but
it really should. It's not that big of an issue since we don't have many
clocks in modules.. 

> thirdly, CLOCKSOURCE_NOTIFY_FREQ is totally unused as well.

Indeed . Consider it dropped.

> (there are tons of examples in the kernel of how to do driver 
> notification APIs properly.)

Are you referring to the comments above , or something else your seeing
in the code?

Daniel

