Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbXEOCfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbXEOCfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 22:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757069AbXEOCfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 22:35:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:58293 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbXEOCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 22:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ffjJ6RlkNruvOnoD3o0cuoVcjx+RHYeWOjwOF6QDp2lYeyXqGrkZUyG1gIusXhdMpDIQfqQWLYRiJxxmTpF7x9sWoCV0gxezZtNAyOxBIOS/hYrwJwKZiyqw62XqhSUxumiRW7E/zSQ2FZj3OubYwfbVg8euEBkgf+4ftAGolgc=
Message-ID: <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
Date: Tue, 15 May 2007 08:04:57 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: Linux 2.6.22-rc1
Cc: "Tilman Schmidt" <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	 <4647569D.7010709@imap.cc>
	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
	 <4648A3DF.7040004@imap.cc>
	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 5/15/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> [...]
> They are just a menu

Ok, so they don't really affect Makefiles / sources (and thus builds).
In that case I'd suggest that let's please change the names of such
menuconfig options from CONFIG_ to CONFIG_MENU_, otherwise
we really screw the text-based "make oldconfig" folks who think
that they're taking a build-related (and not presentation-related)
decision when confronted with a:

Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)

kind of option. OTOH:

Ethernet (1000 Mbit) (MENU_NETDEV_1000) [Y/n] (NEW)

taxes a make-oldconfig-using-person's intuition a little less, IMHO.
So this'll hopefully take care of Tilman's and Stefan's gripes:

On 5/15/07, Tilman Schmidt <tilman@imap.cc> wrote:
> (Except for the "this
> menu" part which might appear rather cryptic to users of the
> curses based interface who don't see any menu.)
> [...]
> Point is, without grepping through the Kconfig the user has no
> way of knowing that the question comes from a menuconfig in the
> first place ...
> ... s/he cannot be sure the option doesn't directly affect
> code generation.

and

On 5/15/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> One problem is, nobody can see easily whether saying Y is merely the
> ticket to get into the menu, or whether it on its own will cause
> something to be built.

?

On 5/15/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> that can be switched on or off.
> It is for those people that start with an arbitrary .config and
> work their way through menuconfig to disable all the parts they
> do not want. So, point no. 1:
>
>   * Disabling this menu disables all the fluff inside it,
>     without needing to enter the menu and disable each
>     option one by one (as was the case previously)

This kind of promise was really nice, and why I liked Jan's
menuconfig patches a lot.

But if:

On 5/15/07, Tilman Schmidt <tilman@imap.cc> wrote:
> Another essential piece of information. I seem to remember other
> menus which, when disabled, kept the selection status of the
> options inside and just hid them from view.

is true, then are we really gaining much from these configmenu's?

[unrelated]
I wish these new constructs were called "configmenu" and
_not_ "menuconfig". It causes confusion with the "menuconfig"
master Makefile rule which has nothing to do with these new
"configmenu"s.
[/unrelated]

> Then of course, one can also turn these menuconfig on (apparently!)
> to be able to descend into them and select some drivers they like.
> Point no. 2:
>
>   * Since Jens Axboe's stance ["default y idiocy"] is to have
>     these menus disabled by default, people should most likely
>     enable them first before they will be able to enter them.

I do agree that anything non-essential (even if it's just a presentation
menu that doesn't affect builds) must be default n.

>     (I would have wanted them to be always 'y' - it does not affect
>     the build, just opens all menus by default)

IMHO, the real problem with "default y" menuconfig's, is that they
cause unpleasant surprises to those folks that use the text-based
"make oldconfig". They get confronted with choices that they never
bothered about (or even knew existed) previously, and have no
idea how to answer them -- same problem faced by Tilman, when
he used oldconfig.

> >Seriously, it might be a tad more efficient if the help texts were
> >written by those who invented the options in the first place.
>
> menuconfig NETDEV_10000
>         bool "Ethernet (10GbE)"
>         ---help--
>         Say Y here to actually be able to go into this menu
>         and select some drivers that we think belong to the
>         "10 Gigabit Ethernet" family.
>
>         If unsure, it is unwise to say N!
>
> See, this looks so fundamentally basic to me that I find it
> almost funny. YMMV, hence I asked for suggestions from
> other people.

IMHO, those using "oldconfig" are often looking towards doing
things quickly ... doesn't help them if they have default y menu's
that they need to "?" upon then to see what they're really about.

> >For a start, it shouldn't require users to grep through Kconfigs
> >and Makefiles in order to find out what effects an option has.
>
> menuconfigs are some special kind in that they combine an option
> with a menu. Perhaps now that some ->menuconfig patches have gone
> in, more people will get to know these constructs.

I think what happened here is that Jan really only considered the
"make menuconfig" users with these new constructs (which makes life
really simple for them), but "oldconfig" users were unfortunately in for
unpleasant surprises ...

On 5/15/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> PS:  I still believe that Kconfigs shouldn't by overly burdened with
> presentation.  Presentation should mostly be left to the UIs.  And the
> UIs shouldn't be created by kernel hackers...  ;-)

Kernel dev's can still try, can't they ;-) I do agree that Kconfig is
primarily a build dependency language, but also, note that linking
Kconfig dependency rules with presentation isn't an idea that seems
to be fundamentally broken or anything.

Just my 2 paise,
Satyam
