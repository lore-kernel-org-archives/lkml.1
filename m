Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZB1Oih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZB1Oih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 09:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZB1Oi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 09:38:27 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50121 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbZB1Oi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 09:38:26 -0500
X-Sasl-enc: sSwj8iQ87L85QEexJ6LOcZMu/pWqUOhV6ggxKtis/fUK 1235831834
Date: Sat, 28 Feb 2009 11:37:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alexandre Rostovtsev <tetromino@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lenovo-sl-laptop : driver for review
Message-ID: <20090228143711.GB17541@khazad-dum.debian.net>
References: <20090216025918.66d7a466@leftboat.lan> <20090227132752.GG1482@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227132752.GG1482@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009, Pavel Machek wrote:
> > +module_param(debug_ec, bool, S_IRUGO);
> > +MODULE_PARM_DESC(debug_ec,
> > +	"Present EC debugging interface in procfs. WARNING: writing to the "
> > +	"EC can hang your system and possibly damage your hardware.");
> 
> Sounds dangerous and clearly does not belong to /proc. Please drop it.

ThinkPad ACPI also has one.  OTOH, we are fairly sure one cannot damage the
standard ThinkPad hardware through the "IBM thinkpad-style" EC firmware, the
EC sanity-checks things.  I suppose you could cause the box to go away for
lunch and don't come back until a complete hardware reset, or hit one of the
crash-the-EC-firmware bugs by accident, though.

It has been invaluable for debugging. I can well guess why the thinkpad-sl
driver would want to add it as well.

What I am heavily considering is to taint the kernel when it is used (plus
it is not enabled by default, requires a module parameter to enable, etc),
plus output a big warning to syslog.  That is probably enough to keep the
users from abusing it.

> > +/*************************************************************************
> > +    bluetooth sysfs - copied nearly verbatim from thinkpad_acpi.c
> > + *************************************************************************/
> 
> That's quite a lot of code for verbatim copy; create shared helper?

Yeah, I am game.  But let's do it later on and not delay anything because of
it, please.  I will start breaking thinkpad-acpi into multiple source files,
and after that is done (should take a while, thinkpad-acpi is a big module
with a LOT of subdriver interdependencies) we can look for the best way to
reduce code duplication.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
