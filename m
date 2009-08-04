Return-Path: <linux-kernel-owner+w=401wt.eu-S932891AbZHDPdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbZHDPdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932874AbZHDPdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:33:10 -0400
Received: from ru.mvista.com ([213.79.90.228]:46604 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932808AbZHDPdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:33:10 -0400
Date: Tue, 4 Aug 2009 19:33:07 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: Ang: Re: [PATCH 0/2] Setting GPIOs simultaneously
Message-ID: <20090804153307.GA27107@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090713222005.GA19859@oksana.dev.rtsoft.ru>
 <20090713151911.GA28114@oksana.dev.rtsoft.ru>
 <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@transmode.se>
 <20090713173455.GA9866@oksana.dev.rtsoft.ru>
 <OF9378E65D.FBBCCFD5-ONC12575F2.006B28D5-C12575F2.006DDAE5@transmode.se>
 <OF613F53BF.1FD77EDB-ONC12575F3.00753535-C12575F3.00753537@transmode.se>
 <20090714220931.GA11378@oksana.dev.rtsoft.ru>
 <OF9A2BDEDE.DC0DE0D4-ONC1257608.004A7A59-C1257608.004AF3BF@transmode.se>
 <20090804142250.GA17398@oksana.dev.rtsoft.ru>
 <OFC7025845.8BE60C98-ONC1257608.0051D318-C1257608.00525388@transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <OFC7025845.8BE60C98-ONC1257608.0051D318-C1257608.00525388@transmode.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 04:59:13PM +0200, Joakim Tjernlund wrote:
[...]
> hmm, this looks promising. Can I write my own board-specific-csm
> and attach it to the SPI CS engine?

Yes, you'd able to do it, but there is no such thing as SPI CS
engine, yet.

See the two options of how we can implement it:
http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg34738.html

Grant said that he like option "2.", but also said that we might
want to modify SPI requests (messages) before sending the data to
the outside world. I think that the option "1." fits better for
this task. Which means that implementation should be quite
trivial -- just another spi master driver.

> [...] the 8xxx SPI driver only looks for gpio functions.

Yes, and we should consider removing the gpio stuff too.

> Perhaps this is something that you are working on?

No, I don't need the feature right now (i.e. no board that I'm
working on needs this). But I know how to implement it (see the
link above).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
