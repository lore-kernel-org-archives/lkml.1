Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbXFAANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbXFAANZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756251AbXFAANR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:13:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41934 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178AbXFAANQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:13:16 -0400
X-Sasl-enc: iMo/Ancrh05lHUIsDbA5rE8rzlQ/Lcw80au/+2QFa+gW 1180656794
Date: Thu, 31 May 2007 21:13:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dtor@insightbb.com>, Richard Hughes <hughsient@gmail.com>,
       linux-acpi@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: document the proper usage of EV_KEY and KEY_UNKNOWN
Message-ID: <20070601001304.GB5407@khazad-dum.debian.net>
References: <11802004861625-git-send-email-hmh@hmh.eng.br> <d120d5000705301325yf76d062vefbc79873d23e602@mail.gmail.com> <20070531005305.GC6883@khazad-dum.debian.net> <200705310033.51230.dtor@insightbb.com> <20070531222814.GB4076@khazad-dum.debian.net> <20070531233326.GA1947@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531233326.GA1947@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007, Matthew Garrett wrote:
> On Thu, May 31, 2007 at 07:28:14PM -0300, Henrique de Moraes Holschuh wrote:
> > We have all the pieces needed to have sane, generic userland keyboard handling
> > in place for a while now, but it was not sufficiently documented (or used!).
> > 
> > If EV_KEY input drivers always generate scan codes that can be used to
> > reprogram their keycode maps, and always generate EV_MSC MSC_SCAN events when
> > they output an EV_KEY KEY_UNKNOWN event, userspace can trap those and feed it
> > to a generic helper that can ask the user to assign a key code and function to
> > that key.
> 
> I still disagree that this is the best approach. Userspace already has 
> the functionality to map keys if they produce a keycode. Producing 
> KEY_UNKNOWN would require the implementation of a stack of extra code.

Well, we already produce KEY_UNKNOWN anyway, and the stuff you quoted above
just makes KEY_UNKNOWN useful for something instead of keeping it as an
useless notice to the user that some key (which one? who knows!) was
pressed.

Drivers already have KEY_RESERVED to mark positions in the keycode map for
keys that should generate no events, so we are not forcing anyone to always
generate useless events, either.

Perhaps what you dislike re. KEY_UNKNOWN is the part where KEY_UNKNOWN+scan
code is declared to be the prefered way to report keys that do not have a
specific function?  Your reply seems to indicate this, but I am not sure I
really understood what you meant.

I am not exactly in love with the idea of using KEY_UNKNOWN in place of
stuff like KEY_FN_F1 either (I'd prefer to just bump up KEY_MAX and have
more posicional keycodes), but Dmitry is being quite clear that he does not
want to increase KEY_MAX to add more positional keycodes.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
