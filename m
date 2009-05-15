Return-Path: <linux-kernel-owner+w=401wt.eu-S1761480AbZEOGLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480AbZEOGLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759847AbZEOGK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:10:59 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:40762 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbZEOGK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:10:58 -0400
Date: Fri, 15 May 2009 08:10:58 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Kwangwoo Lee <kwangwoo.lee@gmail.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-kernel@vger.kernel.org,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH] TSC2007: private data for platform callbacks.
Message-ID: <20090515061058.GA31862@roarinelk.homelinux.net>
References: <20090514100909.GA23626@roarinelk.homelinux.net> <5d5443650905140328v319e673o2f7b865e21619486@mail.gmail.com> <483a38b80905142125l6f3be674m3b7ef9083cfcbdeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483a38b80905142125l6f3be674m3b7ef9083cfcbdeb@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 01:25:41PM +0900, Kwangwoo Lee wrote:
> Hi Manual,
> 
> On Thu, May 14, 2009 at 7:28 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> > Hi Manuel,
> >
> > CCing linux-input mailing list, so not deleting any code from this
> > e-mail while replying.
> >
> > On Thu, May 14, 2009 at 3:39 PM, Manuel Lauss
> > <mano@roarinelk.homelinux.net> wrote:
> >> Add a private data field to the tsc2007 platform data and pass this
> >> to the callbacks.
> >
> > I hope that you have created this patch on top of two recently posted
> > patches by Kwangwoo Lee
> > to merge changes from Thierry.
> >
> >>
> >> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
> >> ---
> >> ?drivers/input/touchscreen/tsc2007.c | ? 52 +++++++++++++++++++++++-----------
> >> ?include/linux/i2c/tsc2007.h ? ? ? ? | ? 10 ++++---
> >> ?2 files changed, 41 insertions(+), 21 deletions(-)
> >>
> >> diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
> >> index 948e167..5c4242d 100644
> >> --- a/drivers/input/touchscreen/tsc2007.c
> >> +++ b/drivers/input/touchscreen/tsc2007.c
> >> @@ -83,10 +83,35 @@ struct tsc2007 {
> >> ? ? ? ?unsigned ? ? ? ? ? ? ? ?pendown;
> >> ? ? ? ?int ? ? ? ? ? ? ? ? ? ? irq;
> >>
> >> - ? ? ? int ? ? ? ? ? ? ? ? ? ? (*get_pendown_state)(void);
> >> - ? ? ? void ? ? ? ? ? ? ? ? ? ?(*clear_penirq)(void);
> >> + ? ? ? struct tsc2007_platform_data *pd;
> 
> Why is this pd is contained in struct tsc2007?

It just seemed nicer to me to store a pointer to the platform data
instead of duplicating its members.

 
> >> +/* ask platform for pendown state */
> >> +static inline int ts_get_pendown_state(struct tsc2007 *ts)
> >> +{
> >> + ? ? ? return ts->pd->get_pendown_state(ts->pd->priv);
> 
> Is it required in get_pendown_state() function in your platform?
> The function just return true/false indicating the pendown state.

It enables me to reuse the same callbacks if more than one tsc2007 is
soldered on (different bits to fiddle with in external registers).

Thanks,
	Manuel Lauss
