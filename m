Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXDPA5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXDPA5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 20:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbXDPA5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 20:57:43 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42644 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754132AbXDPA5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 20:57:42 -0400
X-Sasl-enc: Vf+5stqkDZPUiZuNAOgtxUAeVn67bveo+3m7kBihn2tF 1176685061
Date: Sun, 15 Apr 2007 21:57:22 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070416005722.GA6296@khazad-dum.debian.net>
References: <20070411232503.GC20095@zarina> <20070415220854.GA20373@localhost.localdomain> <20070415225049.GA27680@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415225049.GA27680@zarina>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Anton Vorontsov wrote:
> Current battery class assumes values are not averaged. I.e. momentary
> values. In general, it's userspace' job to collect statistics. Though,
> if hardware can report only average values, it's just okay to use
> usual attributes.

What about SBS-style battery firmware, which can report *both* ?  This
includes just about all ThinkPads in the last five years, so we are talking
about a damn big lot of machines...

I'd really appreciate if there is a standard way to communicate both.  And
it is probably a good idea to define what should be averaged, and what
should be instantaneous when that matters, that way userspace actually has a
chance at not doing something braindamaged.

Actually, IMHO, every attribute and alarm from SBS should be somehow
losslessly translatable to standard class attributes from day one, unless it
is something that makes no sense at all (and there is precious little of
that in the latest version of SBS, thankfully...).

> Also, if you your battery can collect and report its approximated values
> in additional to momentary values, you're free to add _AVG attributes
> to standard ones and use them.

No, that won't help much.  IMO, we want the sanest set of standard
attributes we can get, and weird as it might be, average reporting are
common properties of battery control firmware on laptops (maybe because of
SBS, but still...).

We don't have to get it perfect at the first try, but I really think we are
getting a bit too far from "as good as we can make it" at the first attempt
if we don't take the SBS into account properly, given the ammount of
circuits and firmware out there that are shaped along the SBS guidelines.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
