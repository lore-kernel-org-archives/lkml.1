Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbXEOISO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbXEOISO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbXEOISD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:18:03 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53507 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbXEOISA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:18:00 -0400
Date: Tue, 15 May 2007 10:16:26 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705151009400.9570@yvahk01.tjqt.qr>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
  <4647569D.7010709@imap.cc>  <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
  <4648A3DF.7040004@imap.cc>  <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
 <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15 2007 08:04, Satyam Sharma wrote:
> On 5/15/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>> that can be switched on or off.
>> It is for those people that start with an arbitrary .config and
>> work their way through menuconfig to disable all the parts they
>> do not want. So, point no. 1:
>> 
>> * Disabling this menu disables all the fluff inside it,
>> without needing to enter the menu and disable each
>> option one by one (as was the case previously)
>
> This kind of promise was really nice, and why I liked Jan's
> menuconfig patches a lot.
>
> But if:
>
> On 5/15/07, Tilman Schmidt <tilman@imap.cc> wrote:
>> Another essential piece of information. I seem to remember other
>> menus which, when disabled, kept the selection status of the
>> options inside and just hid them from view.
>
> is true, then are we really gaining much from these configmenu's?

If you transform a menu with hidden options (which do NOT "depend on"
the menu - they can't even) into a menuconfig (continuing not to
depend on the menuconfig), the presentation fucks up (especially in
ncurses-menuconfig). That is a good hint something should be taken
more seriously.

So, for menus with hidden options I had a number of options how to
go about them:

 - move the hidden options before the menuconfig or after, so
   the presentation does not bork;

 - leave the menu as-is because there's just so many hidden
   options and a menuconfig entry is detrimental

> [unrelated]
> I wish these new constructs were called "configmenu" and
> _not_ "menuconfig". It causes confusion with the "menuconfig"
> master Makefile rule which has nothing to do with these new
> "configmenu"s.
> [/unrelated]

Indeed.

>> Then of course, one can also turn these menuconfig on (apparently!)
>> to be able to descend into them and select some drivers they like.
>> Point no. 2:
>> 
>> * Since Jens Axboe's stance ["default y idiocy"] is to have
>> these menus disabled by default, people should most likely
>> enable them first before they will be able to enter them.
>
> I do agree that anything non-essential (even if it's just a presentation
> menu that doesn't affect builds) must be default n.
>
>> (I would have wanted them to be always 'y' - it does not affect
>> the build, just opens all menus by default)
>
> IMHO, the real problem with "default y" menuconfig's, is that they
> cause unpleasant surprises to those folks that use the text-based
> "make oldconfig". They get confronted with choices that they never
> bothered about (or even knew existed) previously, and have no
> idea how to answer them -- same problem faced by Tilman, when
> he used oldconfig.
>


> I think what happened here is that Jan really only considered the
> "make menuconfig" users with these new constructs (which makes life
> really simple for them), but "oldconfig" users were unfortunately in for
> unpleasant surprises ...

I can't tell, since I'd just say yes if it asks "Ethernet (10 GbE)?" -
either I have such an adapter or I don't.



So what do we need?

 * 'configmenu' option (with 'endconfigmenu') that works the same as
   'menu' and 'endmenu' (so we can have hidden options), but at the
   same time make the ---> and options inside it disappear when it is
   not selected. Currently, no other type seems to satisfy this.


	Jan
-- 
