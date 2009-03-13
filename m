Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbZCMS70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbZCMS70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 14:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZCMS7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 14:59:18 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:40923 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZCMS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 14:59:17 -0400
X-Greylist: delayed 1773 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 14:59:17 EDT
Message-ID: <49BAA601.2040605@grupopie.com>
Date: Fri, 13 Mar 2009 18:29:21 +0000
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: =?UTF-8?B?TWljaGFlbCBCw7xrZXI=?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <20090304224310.GA29043@electric-eye.fr.zoreil.com> <49B5066D.1030309@grupopie.com>
In-Reply-To: <49B5066D.1030309@grupopie.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rui Santos wrote:
> I'm performing a git bisect to try to find the patch that caused it.
> Here is the current status:
> git bisect start
> # bad: [fec6c6fec3e20637bee5d276fb61dd8b49a3f9cc] Linux 2.6.29-rc7
> git bisect bad fec6c6fec3e20637bee5d276fb61dd8b49a3f9cc
> # good: [0215ffb08ce99e2bb59eca114a99499a4d06e704] Linux 2.6.19
> git bisect good 0215ffb08ce99e2bb59eca114a99499a4d06e704
> # good: [836341a70471ba77657b0b420dd7eea3c30a038b] mac80211: remove sta
> TIM flag, fix expiry TIM handling
> git bisect good 836341a70471ba77657b0b420dd7eea3c30a038b ( This is a
> 2.6.25-rc3-master_20090221181736_632072f6 )
>
> The bisect will take a while as the system is a dual core Atom...
> This bisect will take a while as my machine usually will not boot on
> 2.6.27 kernels...
> If I get any further I'll let you know.
>
>   
Hi. Just to add a few extra data that may help to find the problem. I
was ( still ) not able to fully complete the git bisect but, here is the
current status:
~# git bisect log
git bisect start
# bad: [d2f8d7ee1a9b4650b4e43325b321801264f7c37a] Linux 2.6.29-rc5
git bisect bad d2f8d7ee1a9b4650b4e43325b321801264f7c37a
# good: [3fa8749e584b55f1180411ab1b51117190bac1e5] Linux 2.6.27
git bisect good 3fa8749e584b55f1180411ab1b51117190bac1e5
# bad: [759ef89fb096c4a6ef078d3cfd5682ac037bd789] iwlwifi: change email
contact information
git bisect bad 759ef89fb096c4a6ef078d3cfd5682ac037bd789
# bad: [bdbf0ac7e187b2b757216e653e64f8b808b9077e] Merge branch
'hwmon-for-linus' of git://jdelvare.pck.nerim.net/jdelvare-2.6
git bisect bad bdbf0ac7e187b2b757216e653e64f8b808b9077e
# skip: [5c3c4d9b5810c9aabd8c05219c62ca088aa83eb0] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6
git bisect skip 5c3c4d9b5810c9aabd8c05219c62ca088aa83eb0
# skip: [ead9d23d803ea3a73766c3cb27bf7563ac8d7266] Merge phase #4
(X2APIC, APIC unification, CPU identification unification) of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect skip ead9d23d803ea3a73766c3cb27bf7563ac8d7266
# skip: [fd048088306656824958e7783ffcee27e241b361] Merge branch
'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
git bisect skip fd048088306656824958e7783ffcee27e241b361
# skip: [14835a3325c1f84c3ae6eaf81102a3917e84809e] [CIFS] cifs: remove
pointless lock and unlock of GlobalMid_Lock in header_assemble
git bisect skip 14835a3325c1f84c3ae6eaf81102a3917e84809e
# skip: [1efd325fbadc02c1338e0ef676f0a6669b251c7a] Fix RTC wakealarm
sysfs interface breakage.
git bisect skip 1efd325fbadc02c1338e0ef676f0a6669b251c7a
# skip: [325af5fb1418c79953db0954556de048e061d8b6] x86: ioperm user_regset
git bisect skip 325af5fb1418c79953db0954556de048e061d8b6
# skip: [77e841de8abac4755cc83ca224fdf71418d65380] jbd2: abort when
failed to log metadata buffers
git bisect skip 77e841de8abac4755cc83ca224fdf71418d65380
# skip: [7d3c6f8717ee6c2bf6cba5fa0bda3b28fbda6015] md: Fix
rdev_size_store with size == 0
git bisect skip 7d3c6f8717ee6c2bf6cba5fa0bda3b28fbda6015

ALSO AN IMPORTANT NOTE: If I disable CONFIG_PCI_MSI this problem will
not occur on my machine in any of the Kernels. Can anyone corroborate ?

Regards,
Rui Santos

