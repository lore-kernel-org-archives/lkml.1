Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbXCOT5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbXCOT5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933620AbXCOT5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:57:47 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39261 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933624AbXCOT5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:57:45 -0400
X-Sasl-enc: bD+tC33RgmNxHoOA/e6guqr7Rl/LP2T+0Hp3MFrkupqd 1173988664
Date: Thu, 15 Mar 2007 16:57:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Chris Wedgwood <cw@f00f.org>, linux-acpi@vger.kernel.org,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [ibm-acpi-devel] [PATCH] ACPI: ibm-acpi: allow module to load when acpi notifiers can't be set
Message-ID: <20070315195732.GG14394@khazad-dum.debian.net>
References: <20070315071019.GA22613@tuatara.stupidest.org> <20070315175113.GA6596@khazad-dum.debian.net> <20070315191721.GB2556@tuatara.stupidest.org> <20070315123732.2ac478a3.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315123732.2ac478a3.kristen.c.accardi@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Kristen Carlson Accardi wrote:
> I haven't followed the ibm_acpi development lately, but when I first
> wrote the bay driver, it had a couple features that ibm_acpi didn't have,
> and then of course, is missing some it does have.  What used to be the
> case is that if bay was inserted after the laptop was booted, the ibm_acpi
> driver would not capture the events because it would only install it's 
> notifier at driver load time on bay devices that existed.  The second

This is still true, I didn't bother fixing it because I'd rather expend "bay
time" trying to get the generic driver to work OK in thinkpads, but I have
been otherwise distracted with other ibm-acpi things, like a sysfs
conversion.

> as the X60, you need to have undock events sent to the bay device so that
> it can alert user space to unmount cd's etc (since the bay is on the ultrabase).

This is also still true.

BTW, currently the bay driver seems to have lost a lot of functionality, I
remember older incarnations of it (before it went platform-driver) caused
unplugs to be clean instead of driving libata nuts...  Am I recalling this
incorrectly?

> I think for now this is a good idea - the ibm_acpi solution should be
> preferred over the generic bay driver till it is more fully developed.
> I don't know how to ensure this is done wrt load order though.

Nor do I, and sincerely, if one is doing what some rpm distros are and
loading every ACPI module in a for loop at boot time, I don't want to know.
It is their mess to fix.  I just have ibm-acpi in my /etc/modules, and
arranged it to be loaded BEFORE any such distro crap (not that Debian has
it, but still...).

What we *can* do is to have DMI-based coldplug capabilities added, and work
from there to get udev to autoload devices.  And that still won't be 100%
failure-proof, but nothing is.

> I think this is a good idea.  It would certainly be less confusing for users.
> too late for this release though, perhaps this can be targetted at 2.6.22/23?

That's something I'd like to happen.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
