Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZCJLee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZCJLee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbZCJLeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:34:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39894 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573AbZCJLeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:34:24 -0400
X-Sasl-enc: KCtgHDAMsQnE1OoNZW67P5Q7+nTHbttcLhkLBZhiXaER 1236684861
Date: Tue, 10 Mar 2009 08:34:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alexandre Rostovtsev <tetromino@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lenovo-sl-laptop : driver for review
Message-ID: <20090310113419.GC371@khazad-dum.debian.net>
References: <20090216025918.66d7a466@leftboat.lan> <20090227132752.GG1482@ucw.cz> <20090228143711.GB17541@khazad-dum.debian.net> <20090310112209.GB1337@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310112209.GB1337@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Pavel Machek wrote:
> On Sat 2009-02-28 11:37:11, Henrique de Moraes Holschuh wrote:
> > On Fri, 27 Feb 2009, Pavel Machek wrote:
> > > > +module_param(debug_ec, bool, S_IRUGO);
> > > > +MODULE_PARM_DESC(debug_ec,
> > > > +	"Present EC debugging interface in procfs. WARNING: writing to the "
> > > > +	"EC can hang your system and possibly damage your hardware.");
> > > 
> > > Sounds dangerous and clearly does not belong to /proc. Please drop it.
> > 
> > ThinkPad ACPI also has one.  OTOH, we are fairly sure one cannot damage the
> > standard ThinkPad hardware through the "IBM thinkpad-style" EC firmware, the
> > EC sanity-checks things.  I suppose you could cause the box to go away for
> > lunch and don't come back until a complete hardware reset, or hit one of the
> > crash-the-EC-firmware bugs by accident, though.
> 
> Yeah but that interface still does not belong to /proc. Please drop it
> from merge version at least. 
> 
> > > > +/*************************************************************************
> > > > +    bluetooth sysfs - copied nearly verbatim from thinkpad_acpi.c
> > > > + *************************************************************************/
> > > 
> > > That's quite a lot of code for verbatim copy; create shared helper?
> > 
> > Yeah, I am game.  But let's do it later on and not delay anything because of
> > it, please.  I will start breaking thinkpad-acpi into multiple source files,
> > and after that is done (should take a while, thinkpad-acpi is a big module
> > with a LOT of subdriver interdependencies) we can look for the best way to
> > reduce code duplication.
> 
> Well,  this monolith is quite long/hard to review. IMO it should be
> split to make review easy. 

thinkpad-sl could be split, yes.  But if you guys are going to wait for
thinkpad-acpi to be split _as well_ to do some common-path merging, THAT is
going to take quite a while...

An alternative is to submit a minimal thinkpad-sl, then add features to it
patch-by-patch.  That makes reviewing it easier.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
