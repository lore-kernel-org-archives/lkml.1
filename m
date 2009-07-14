Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZGNVUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZGNVUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 17:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbZGNVUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 17:20:19 -0400
Received: from gw1.transmode.se ([213.115.205.20]:40063 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511AbZGNVUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 17:20:18 -0400
MIME-Version: 1.0
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: <20090713222005.GA19859@oksana.dev.rtsoft.ru>
References: <20090713222005.GA19859@oksana.dev.rtsoft.ru>,
	<20090713151911.GA28114@oksana.dev.rtsoft.ru> <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se> <20090713173455.GA9866@oksana.dev.rtsoft.ru> <OF9378E65D.FBBCCFD5-ONC12575F2.006B28D5-C12575F2.006DDAE5@transmode.se>
Subject: Ang: Re: [PATCH 0/2] Setting GPIOs simultaneously
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
To: avorontsov@ru.mvista.com
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
X-MIMETrack: MIME-CD by HTTP Server on sesr04/Transmode(Release 8.5 HF407|May 07, 2009) at
 2009-07-14 23:20:13,
	MIME-CD complete at 2009-07-14 23:20:13,
	Serialize by Router on sesr04/Transmode(Release 8.5 HF407|May 07, 2009) at
 2009-07-14 23:20:13
Message-ID: <OF613F53BF.1FD77EDB-ONC12575F3.00753535-C12575F3.00753537@transmode.se>
Date: Tue, 14 Jul 2009 23:20:13 +0200
X-Mailer: Lotus Domino Web Server Release 8.5 HF407 May 07, 2009
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Anton Vorontsov <avorontsov@ru.mvista.com> skrev: -----
>Till: Joakim Tjernlund <joakim.tjernlund@transmode.se>
>Från: Anton Vorontsov <avorontsov@ru.mvista.com>
>Datum: 07/14/2009 00:20
>Kopia: David Brownell <dbrownell@users.sourceforge.net>,
>linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
>Ärende: Re: [PATCH 0/2] Setting GPIOs simultaneously
>
>
>On Mon, Jul 13, 2009 at 09:59:54PM +0200, Joakim Tjernlund wrote:
>[...]
>> > > While being at it, the reason for me needing this is that the spi_mpc83xx
>driver
>> > > was recently converted to a OF only driver so I have no way of defining
>my own
>> > > CS function anymore. While OF is good I don't feel that OF drivers
>should
>> > block the native
>> > > method, OF should be a layer on top of the native methods.
>> >
>> > Um, I don't get it. You have a mux, which is a sort of GPIO controller.
>> > All you need to do is to write "of-gpio-mux" driver, that will get all
>> > the needed gpios from the underlaying GPIO controller.
>>
>> Well, I already have a mux controller that is using the native spi methods.
>I
>> don't want to write a new one, far more complicated than what I got now.
>> While the OF system is very powerful and flexible I still think that
>> one should be able to use native SPI methods too. Why can they not
>> co-exist?
>
>I strongly believe that they can. You just need to post patches
>so that we could see them, and maybe discuss how to do things
>more generic. But if making things generic will be too hard (see
>below), I don't think anybody will object applying a non-generic
>solution (even permitting "legacy" bindings in the spi_8xxx driver).
>
>But any users of the legacy bindings should be in-tree.

ehh, it was working until you made it OF only. Why do call the native
way legacy?  It is the method all non OF arch uses.

>
>> > In the device tree it'll look like this:
>>
>> I must admit that I just started to look at the GPIO subsystem, but
>> I do wonder if mpc83xx_spi_cs_control() can do this muxing
>> without any change.
>>
>> Very good example BTW.
>
>Well, there is one caveat: the "GPIOs" aren't independent,
>so thinking about it more, I believe we should now discuss
>"chip-select framework", not gpio controllers (it could be
>that using gpio controllers for this purpose wasn't that
>good idea).
>
>http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg34738.html
>^^^ I'm dreaming about this framework. I.e. true addressing
>    for chip-selects. :-)

This is probably needed to support most SPI users out there, but until
such framework is in place I think the native methods need to stay, right?
As is now, SPI has regressed w.r.t earlier releases.

 Jocke
BTW, I will be offline for a few days as of now.

>
>--
>Anton Vorontsov
>email: cbouatmailru@gmail.com
>irc://irc.freenode.net/bd2

