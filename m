Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYGJBMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYGJBMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYGJBMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:12:09 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56811 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbYGJBMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:12:07 -0400
X-Sasl-enc: wffta3kwaZPief2ZqazG8NFMl96S0HBPQd5OITiHLla6 1215652326
Date: Wed, 9 Jul 2008 22:12:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ak@linux.intel.com, Len Brown <lenb@kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND] [PATCH -next 2/2] acpi,rfkill,backlight:
	comapl-laptop update - use rfkill switch subsystem
Message-ID: <20080710011201.GC15729@khazad-dum.debian.net>
References: <20080709231059.778d16f4@debian> <200807092333.01355.IvDoorn@gmail.com> <20080709234419.12d6eabc@debian> <200807092357.28013.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807092357.28013.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008, Ivo van Doorn wrote:
> It is not mandatory if you are writing rfkill support for a driver that does not
> come with a rfkill switch. Such drivers can make use of the rfkill events produced
> by the hardware which does have such a switch.
> 
> When the hardware does have the rfkill switch, then yes rfkill_force_state() is mandatory.
> The get_state() callback function is optional, and allows rfkill to differentiate
> between soft and hardblock.

Do you want me to mark rfkill_force_state() as mandatory in the docs?  It
*IS* the preferred way to deal with firmware/hardware-initiated state
changes, after all.

The rfkill subsystem will limp along without it, even when there are
hardware rfkill lines... but no OSD function will work, as the system will
pick up the change only when someone reads or writes to the state
attribute...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
