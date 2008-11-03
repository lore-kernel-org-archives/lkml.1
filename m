Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbYKCQ6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbYKCQ6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 11:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbYKCQ6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 11:58:22 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:7951 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755938AbYKCQ6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 11:58:22 -0500
Date: Mon, 3 Nov 2008 19:58:20 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Dmitry <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] power_supply: only register tosa_battery driver on tosa
Message-ID: <20081103165820.GA8004@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com> <bc64b4640811021236t3458bf69vd1becc4ab1133be1@mail.gmail.com> <20081103145514.GA23466@oksana.dev.rtsoft.ru> <bc64b4640811030820j660b8386x39bf2285b1dba887@mail.gmail.com> <20081103162547.GA25546@oksana.dev.rtsoft.ru> <bc64b4640811030841h5bcc537fy4b645c6d293b7b46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <bc64b4640811030841h5bcc537fy4b645c6d293b7b46@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 07:41:47PM +0300, Dmitry wrote:
[...]
> >> >> diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
> >> >> index 2eab35a..4e52c22 100644
> >> >> --- a/drivers/power/tosa_battery.c
> >> >> +++ b/drivers/power/tosa_battery.c
> >> >> @@ -469,6 +469,9 @@ static struct platform_driver tosa_bat_driver = {
> >> >>
> >> >>  static int __init tosa_bat_init(void)
> >> >>  {
> >> >> +     if (!machine_is_tosa())
> >> >> +             return -EINVAL;
> >> >> +
> >> >
> >> > I tend to reject this approach. You should rename the driver instead.
> >> >
> >> > I.e.
> >> > -.driver.name    = "wm97xx-battery",
> >> > -.driver.name    = "tosa-battery",
> >> >
> >> > And make sure that this won't break users of that driver (though
> >> > I don't see any).
> >>
> >> The wm97xx-battery device is registered by
> >> drivers/input/toucscreen/wm97xx-core.c
> >
> > Hmm.. So you can't rename the tosa driver, because then it won't
> > work, correct?
> 
> Yup.
> I see few ways to resolve this:
> * write better wm97xx interface. Dunno if that is feasible or possible.
>   One of the possible solutions is to pass battery and ts device names
>   and data from within board data via ac97 layer to wm97xx-core. This
>   will provide several benefits (e.g. then we can drop lots of parameters
>   from wm97xx-core, which are really board parameters).

That would be great indeed. But for now, just don't compile the two
drivers on the tosa platform. No need for machine_is_*() hacks...

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
