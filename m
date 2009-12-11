Return-Path: <linux-kernel-owner+w=401wt.eu-S934943AbZLKIch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934943AbZLKIch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934829AbZLKIcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:32:33 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:54881 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934849AbZLKIcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:32:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=N01yETqHe9lU9UdwFedjliCFgeDuGdh1l/n1CyRPlsf2csPCyD3IBDoSCUhv01Lt6A
         54kdyc203jq3HUgG8dCKKaWGrtocoNNXcTz33p/wTKCYTfVbxRMFjfwZG6QZiFvZcE75
         HMoAxGPOcWy67PTb1r9N18PzhqO1KbaHL2aBs=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 11 Dec 2009 00:32:17 -0800
Message-ID: <43e72e890912110032q32ba456eqbc7752e36e00fa09@mail.gmail.com>
Subject: Changes to compat-wireless for 2.6.33
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Bala Shanmugam <sbalashanmugam@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compat-wireless [1] now relies on the linux-next git tree [2] as such
we are to add backports for the next kernel release as we move along
with the 802.11 subsystem while a stable linux-2.6.33.y branch will be
prepared that sticks to Linus' tree to iron out fixes for that release
along with the standard kernel release cycle. To be clear: we used to
keep the bleeding edge compat-wireless in synch only with the latest
rc kernel by using wireless-testing, bleeding edge compat-wireless
will now move along with the next kernel release and not stick to the
latest rc kernel. The main advantage here is the possibility add
backporting for other subsystems in one package using one single git
tree.

Thanks to Bala Shanmugam's patch compat-wireless now drags in the
bluetooth subsystem as well. Since two subsystems are now being
backported they now share a common rfkill backport module and a
general kernel compatibility module. Future patches to compat-wireless
then will just be for the patches/ directory and general build
updates. As before I continue to try to push most compatibility code
in the compat-2.6.*[ch] files while *only* things which cannot be
backported through code is left to the patches/*.patch files. Due to
the split to compat-wireless and compat.git please send compat patches
against the new compat.git tree [3], you can use the linux-wireless
mailing list for them.

I welcome others to use compat.git for other compatibility needs and
to send patches for it for more general kernel compatibility, even if
that is for other subsystems. For now the focus on compat-wireless
will just be 802.11 drivers and bluetooth drivers but I will likely
extend it to include some other network drivers and would be open to
other subsystems if someone commits to keeping them updated.

Part of the change to using linux-next meant addressing the 2.6.33
changes already but it also meant running into some items I did not
really care to backport like the PCMCIA changes. This meant disabling
the ssb module, and therefore the Ethernet b44, and 802.11 b43,
b43legacy. I also ran into some small snag with libertas so ended up
disabling it but it seems that one can be fixed easily. All other
drivers were kept enabled and backported. I have *not* tested the
bluetooth drivers since the change to linux-next nor building it
mainly due to the fact my current kernel had CONFIG_BT=y. I'll test
that out tomorrow, but welcome your help.

Enabling 802.11 or bluetooth is pretty easy through the top level
Makefile, should be intuitive. Perhaps using this sort of build
process will let us use our own mconf for our own options in the near
future -- I didn't update scripts/driver-select, that remains busted.
I noticed Ubuntu is shipping CONFIG_BT=y on 2.6.27..2.6.32 while
Fedora should have CONFIG_BT=m (haven't checked the kernel ranges).
Building the compat-bluetooth stuff requires the later so if you'd
like to take advantage of this stuff please consider a change.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git
[2] git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git

  Luis
