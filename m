Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbXHASCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbXHASCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932200AbXHASCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:02:01 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52048 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765940AbXHASB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:01:58 -0400
X-Sasl-enc: w/0eI83tFaRoMQm2jk7tQJULo5I1Lqib8jHn7huirOT1 1185991314
Date: Wed, 1 Aug 2007 15:01:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Hugh Dickins <hugh@veritas.com>
Cc: Len Brown <len.brown@intel.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Richard Hughes <hughsient@gmail.com>, linux-kernel@vger.kernel.org,
       ibm-acpi-devel@lists.sourceforge.net,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: Re: [ibm-acpi-devel] THINKPAD_ACPI_INPUT_ENABLED seems regressive
Message-ID: <20070801180151.GB4516@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0708011327200.4615@blonde.wat.veritas.com> <20070801153602.GJ23111@khazad-dum.debian.net> <20070801160805.GB11758@mellanox.co.il> <20070801162442.GO23111@khazad-dum.debian.net> <Pine.LNX.4.64.0708011754560.7866@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011754560.7866@blonde.wat.veritas.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007, Hugh Dickins wrote:
> While I had CONFIG_THINKPAD_ACPI_INPUT_ENABLED=y and was trying
> to get Fn+F4 to give me Suspend to RAM somehow, I did try setting
> /sys/blah/blah/blah/hotkey_enable to 0.

That immediately tells the firmware to process hot keys at it would see fit.
You could call it "enter DOS mode for hot keys" if you want.

In that mode, it can and will do some stuff by itself, and Fn+F4 may
generate a sleep button event, for example.

The firmware can also report the hot key anyway, in which case
ibm-acpi/thinkpad-acpi lets it through.  I can probably filter off some, but
it would be unsafe to filter out the whole lot.

> That caused the Fn+F4 key to become active, except that it wanted
> to do Hibernation to Disk instead: a window popped up to tell me
> (IIRC) that my kernel command line didn't have a good resume=

Something in your user space reacted to the ACPI event the firmware
generates by default for FN+F4, and tried to do sleep-to-disk.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
