Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab0CBCgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 21:36:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37342 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab0CBCgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 21:36:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=kYs0qFPYLb5ya0RbCys++vqGKqwlMhFnLJbQxAba+cqIhfnYeDn+XvD/A8+4ssfNQx
         YQbiYx9b71Y+42N5BgsSplpTFW0baMjvDZVhAkYup7M3lhz56jbJtFJ50ga2lC8zPYHc
         oYP0AfYA+8GPYoqudDxTJbF1mVbePPaC/YAT8=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 18:36:24 -0800
Message-ID: <43e72e891003011836x5c3d0336h6f0f99100b525b9@mail.gmail.com>
Subject: compat-wireless based on the 2.6.33 kernel release
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I kicked out a new release for compat-wireless based on 2.6.33 [1]. As
usual this ships the entire 802.11 and Bluetooth subsystems, the Sonic
Silicon Backplane, b44 (Broadcom Ethernet driver as it depends on the
ssb as being replaced for b43), and all Atheros Ethernet drivers as
are released on the 2.6.33 kernel.

This release also now has a directory for cherry picked patches we
think are important for 802.11 but not so critical for stable, the
only one I have added so far is Atheros Ethernet AR8152 and AR8152
support which won't get to users until 2.6.34 otherwise. If you have a
few important yet not stable mac80211/new-driver send me the
respective backported cherry pick from linux-next and we can add it;
the only requirement is it *must* be part of linux-next already.
Distributions could also potentially use the patches in this directory
as a guide for cherry picking some changes / new drivers / etc.

You can find the kernel ChangeLog for the driver/subsystem changes for
this release on orbit [2]. For the backport work you can review the
2.6.32.y branch via gitweb for both compat-wireless.git [3] and
compat.git [4]. Please help test it and report any issues [5].

Thanks to Pavel Roskin's backporting of debugfs_remove_recursive()
through the compat.git tree we can now take again the entire tree to
older kernels, so far tested are 2.6.25 with this and the new
Multiqueue backport work, but technically you can take kernel
compatibility further to older kernels by selecting individual
drivers. It should be possible to use ath5k and ath9k on >= 2.6.23
with this release so that is left enabled if you choose to select only
those drivers from compilation:

./scripts/driver-select ath5k
or
./scripts/driver-select ath9k

A few users reported issues with SSB and B43 not compiling on the last
release but I tested this myself and it does compile. Please be sure
to check that you have CONFIG_SSB enabled as a module on your current
kernel configuration, otherwise CONFIG_SSB does not get built. If you
are using a distribution kernel you should be fine.

[1] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/compat-wireless-2.6.33.tar.bz2
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/ChangeLog-2.6.33-wireless
[3] http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-wireless-2.6.git;a=shortlog;h=refs/heads/linux-2.6.33.y
[4] http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat.git;a=shortlog;h=refs/heads/linux-2.6.33.y
[5] http://wireless.kernel.org/en/users/Documentation/Reporting_bugs

  Luis
