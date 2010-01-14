Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254Ab0ANHVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0ANHVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937Ab0ANHVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:21:38 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:54072 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0ANHVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=L3H7cA/MvP9sD66TxTgjH3JZBbNF9+d3KM9hbNhnHVxKW5pf0eEPOuIxeA9kEhnSRB
         tzeK5I1Kwpfu+kDSux9PRcOPbSGeTt/VT5NaHMaGH7MgSR0Nyji5PHpDTEKqHlm9SeTS
         H5J3D3uCP9vzxUFL+JpHFb5m0mH7AFrjeYFI0=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 13 Jan 2010 23:21:15 -0800
Message-ID: <43e72e891001132321qccde01cnd7002d1f94bee1c0@mail.gmail.com>
Subject: Compat / compat-wireless / bluetooth for 2.6.33-rc4 and 2.6.32.3
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.33-rc4 and 2.6.32.3 kernels came out a few days ago, along
with it comes the respective 2.6.33-rc4 [1] and 2.6.32.3 [2]
compat-wireless releases [3]. As noted previously the
compat-wireless-2.6.33 releases now also have bluetooth backported for
kernels >= 2.6.27.

A few release notes:

 * compat.git - generic kernel compatibility package. This is
currently used on bleeding edge compat-wireless and the 2.6.33
compat-wireless releases. Other external drivers are welcomed to take
advantage of this though.
  - gets pm-qos for kernels down to 2.6.23
  - gets the new 2.6.33 firmware_class backported for older kernels
which allows usage of
    drivers with thew new request_firmware_nowait(). Users of this for
802.11 right now are ar9170.
    This actually goes only compile tested, please let me know if this worked.

  * compat-wireless-2.6.32.3:
    - now goes all the way down to 2.6.23 for ath5k and ath9k, should
be easy to test/enable others
    - gets pm-qos backport as well

  * compat-wireless-2.6.33-rc4:
    - The new debugfs_remove_recursive(), added as of 2.6.26 but used
on 802.11 only until
      2.6.32-rc4 on both mac80211 and cfg80211 cannot be backported as
it relies on two
      static variables on fs/debugfs/inode.c, to enable backporting
for older kernels than
      2.6.26 we'll need to relabel CONFIG_CFG80211_DEBUGFS and
CONFIG_MAC80211_DEBUGFS
      and disable them for older kernels.

Due to the new multiqueue patch we only support kernels >= 2.6.27 on
bleeding edge compat-wireless. This patch is due to go into stable
down to 2.6.32 so both next releases 2.6.32.4 and 2.6.32-rc5 are
expected to have this and as such will have backporting disabled for
older kernels as well until we figure out how to properly backport
this.

The compat-wireless 2.6.32.3 release causes this harmless warning on
older kernels < 2.6.24, it can safely be ingored, I see no way of
avoiding it.

  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/rfkill/input.o
In file included from
/home/mcgrof/devel/compat-wireless-2.6/net/rfkill/input.c:16:
include/linux/input.h:933:1: warning: "BIT" redefined
In file included from include/asm-i386/cpufeature.h:11,
                 from include/asm/cpufeature.h:10,
                 from include/asm/alternative.h:43,
                 from include/asm/atomic.h:4,
                 from
/home/mcgrof/devel/compat-wireless-2.6/include/net/compat-2.6.24.h:11,
                 from
/home/mcgrof/devel/compat-wireless-2.6/include/net/compat.h:15,
                 from <command-line>:0:

 Luis

[1] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.33/compat-wireless-2.6.33-rc4.tar.bz2
[2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.32/compat-wireless-2.6.32.3.tar.bz2
[3] http://wireless.kernel.org/en/users/Download/stable
