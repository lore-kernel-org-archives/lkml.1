Return-Path: <linux-kernel-owner+w=401wt.eu-S932151AbXBVO4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbXBVO4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 09:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932152AbXBVO4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 09:56:18 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44245 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151AbXBVO4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 09:56:17 -0500
X-Sasl-enc: cqOjgq1AOo5cnmyOCgUk4XHMxJYajZEWVIrLFpRKGRkm 1172156263
Date: Thu, 22 Feb 2007 12:56:13 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
Message-ID: <20070222145613.GD25887@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com> <20070219000412.acad13de.akpm@linux-foundation.org> <1171876788.6046.3.camel@localhost.localdomain> <877iub9mu2.fsf@sycorax.lbl.gov> <1172097718.5790.29.camel@localhost.localdomain> <20070221231706.GA3336@khazad-dum.debian.net> <1172103159.5790.45.camel@localhost.localdomain> <20070222005122.GA7928@khazad-dum.debian.net> <20070222011017.GA8845@khazad-dum.debian.net> <1172138450.5837.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172138450.5837.34.camel@localhost.localdomain>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Richard Purdie wrote:
> > it to Len Brown for merging into 2.6.21, or NACK it if you'd rather do it in
> > the backlight class core.
> 
> We can't change the backlight class code since some hardware can't read
> from the device, only write to it. Initialisation in that case is a bit
> different.

Initializing stuff after registering is also racy as the device is not
locked but we are going to clobber data in its properties struct.  I don't
particularly care about that race, but...

Anyway, you have the 2.6.21-rc patch now, to ACK or NACK.  I still think the
class should be handling this.  If a device is write-only, it should have no
_get ops handler, which means that the class can easily differentiate the
two cases and do the right thing for both.  There's less code duplication
that way.

Howerver, I *do* strongly wish for a way to combine various drivers into a
single backlight device, where radeon/intelfb takes care of some stuff,
ibm-acpi/asus-laptop/sony-laptop takes care of other stuff, etc.  Also, a
standard naming for the builtin screen(s) would help, calling it "ibm",
"asus", "sony" is not good IMHO.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
