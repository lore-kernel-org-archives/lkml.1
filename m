Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbYFXVFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbYFXVFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYFXVFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:05:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:59824 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbYFXVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:05:12 -0400
Message-ID: <2ffbcf00806241405w5b757b56p84cd560166ea8f90@mail.gmail.com>
Date: Tue, 24 Jun 2008 23:05:11 +0200
From: william <william@waisse.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: strange freeze with VIA C7 dedicated server and libc 2.6.1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080624102129.19d79eb0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <2ffbcf00806232001o4bd314f4kc590e43b4ab27076@mail.gmail.com>
	 <20080624102129.19d79eb0@lxorguk.ukuu.org.uk>
X-Google-Sender-Auth: 8bb572d8f187750e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5OL6Ffq027860

> Except for bugs in glibc that trigger things happening as root which go> on to do stuff like power down the system (root is allowed to power> down/reboot/etc). That is a fairly unlikely case.
 yes, I know this is something really unbelievable, with nothing inthe logs . . . but it happens to at least 20 people, all the upgradedboxes have the problem, and all the downgraded boxes see the problemdisappear.
>> that is triggering the bug. Regardless of what that is and whether it should be>> doing it, it shouldn't completely hang the kernel."> The first thing is to find out which glibc version is the latest that> works, which is the earliest that fails. Yes, but I couldnt test it by myself on a production dedicated server.
 The nly thing whoich are 100% sure :gentoo : upgrade from glibc-2.5-r4  to glibc-2.6.1 makes the problem appear.debian : upgrade from  2.3.6.ds1-3 to 2.3.6.ds1-13etch5  makes theproblem appear.all the debian users who downgraded their libc to 2.3.6.ds1-3 see theproblem disappear.( I suppose the -13 in debian package name means 2.6.3+many patches,probably the  2.3.6.ds1-13etch5 is a 2.6.x ? )
( I coulldn't downgrade libc on gentoo, downgrading libc on gentoo isa nearly suicidal idea )
 But, now I have good news, dedibox.fr admins accepted to lend us abox for testing purpose.
 I can offer a testing shell with unlimited sudo to any kerneldevelopper, interested in investigating this mystery, and  having agnupg key and a web of trust ( mine ishttp://pgpkeys.mit.edu:11371/pks/lookup?op=vindex&search=0x690B4E07 weprobably have a trust path ).
> Second is to try and find out> what apps or event is the trigger for the fail (eg can you boot into text> mode with init s and then run 2 or 3 cpu hogs all day)
 I have have only some details on this point :
* my box freeze during morning sql updates ( updating 300 MB SQLduring 3 hours every morning ), but the scrpt is launched with nice-20* crontab could be related to the problem, it seems to me that I haveless freezes since I splitted one big crontab ( launching a 3 hourlong script ) in 4 smaller crontabs, some other users said thatdisabling big crontabs helped* the load is not so big , often between 1 and 2
 another thing it did not say in the first mail, after the problemappeared I installed lm_sensors and watchdog to try investigating theproblem :
* the temperature is never higher than 54Â°C which seems ok for a VIAC7, am I wrong ? some people say 54Â°c is ok, some other says its notnormal with a via C7 in a datacenter . . .
* the watchdog says nothing in the logs, but is able to reboot the box.
 Thank you very much for your answer Alan, I were hesitating onposting a report with no logs, no clues . . . your answer gives me alittle hope ;)

-- Cordialement
 William Waisse  http://waisse.org | http://neoskills.com   http://cahierspip.ww7.be | http://feeder.ww7.beÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
