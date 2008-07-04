Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYGDX7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYGDX7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbYGDX6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:58:47 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56972 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757474AbYGDX6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:58:46 -0400
X-Sasl-enc: EZXJHpXhdwcWRzhlKRl6Kv5GTaGCYdmUyZIq4CazinV6 1215215924
Date: Fri, 4 Jul 2008 20:58:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Olivier Galibert <galibert@pobox.com>,
       David Woodhouse <dwmw2@infradead.org>, Hannes Reinecke <hare@suse.de>,
       Takashi Iwai <tiwai@suse.de>, Theodore Tso <tytso@mit.edu>,
       Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080704235839.GA5649@khazad-dum.debian.net>
References: <486D6DDB.4010205@infradead.org> <87ej6armez.fsf@basil.nowhere.org> <1215177044.10393.743.camel@pmac.infradead.org> <486E2260.5050503@garzik.org> <1215178035.10393.763.camel@pmac.infradead.org> <20080704141014.GA23215@mit.edu> <s5habgxloct.wl%tiwai@suse.de> <486E3622.1000900@suse.de> <1215182557.10393.808.camel@pmac.infradead.org> <20080704231322.GA4410@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704231322.GA4410@dspnet.fr.eu.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Jul 2008, Olivier Galibert wrote:
> On Fri, Jul 04, 2008 at 03:42:37PM +0100, David Woodhouse wrote:
> > It doesn't yet; that patch is in linux-next. The firmware is shipped as
> > part of the kernel source tree, and you currently need to run 'make
> > firmware_install' to put it in /lib/firmware, although we're looking at
> > making that easier because apparently having to run 'make
> > firmware_install' is too hard...
> 
> Won't that break multiple kernel installs on any binary packaging
> system that cares about file collisions?  Multiple kernel rpms
> providing the same /lib/firmware files would break things wouldn't
> they ?

Correct.

We will probably need per-kernel directories, exactly like what is done for
modules.  And since there are (now) both kernel-version-specific, and
non-kernel-version-specific firmware, this means the firmware loader should
look first on the version-specific directory (say, /lib/firmware/$(uname
-r)/), then if not found, on the general directory (/lib/firmware).

Nothing too dificult to pull off, but something that needs to be done before
this entire thing gets deployed on unsuspecting users.  It is bad enough
that it created such a commotion when deployed on unsuspecting developers...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
