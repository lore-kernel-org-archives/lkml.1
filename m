Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbXJYNoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbXJYNoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 09:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbXJYNnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 09:43:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:18267 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbXJYNnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 09:43:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=flAjZpJQIroC2DR3m6BSAZSS+UV0Ip2vp85D31ZDOK4asw5eVkzO8BGIN7xkrpBSEC9NIZAt/PqgklkUFd66/iikm5oK09tZCVwtUVj81YwIHFFsL8xEK8X+lCnV/nUMfUiiZfg66piHQzB0H2UCIXEqb3olWDBv+sEWOPGcAaE=
Message-ID: <7b9198260710250643k386119e0ga7dfe4ea518382f8@mail.gmail.com>
Date: Thu, 25 Oct 2007 14:43:49 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Sky2 Driver Issue
In-Reply-To: <7b9198260710241058o49a5eb93sf4fa8c22cc037a0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7b9198260710241058o49a5eb93sf4fa8c22cc037a0e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/2007, Tom Spink <tspink@gmail.com> wrote:
> Hi,
>
> A couple of kernels ago, I ran into an issue with the sky2 driver.
> Basically, I began getting repeated errors on my console of the
> following:
>
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0xc0000000
>
> Which eventually led to:
> Oct 21 16:33:49 holly kernel: printk: 92 messages suppressed.
>
> Here is a section of the log that may be useful:
> Oct 21 16:33:37 holly kernel: sky2 eth1: enabling interface
> Oct 21 16:33:38 holly dhclient: DHCPDISCOVER on eth1 to
> 255.255.255.255 port 67 interval 8
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000010
> Oct 21 16:33:39 holly kernel: sky2 eth1: Link is up at 1000 Mbps, full
> duplex, flow control both
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
> Oct 21 16:33:39 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0xc0000000
> Oct 21 16:33:40 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
> Oct 21 16:33:40 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0xc0000000
> Oct 21 16:33:41 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
> Oct 21 16:33:41 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0xc0000000
> Oct 21 16:33:42 holly kernel: sky2 0000:04:00.0: error interrupt
> status=0x80000000
>
> These messages are appearing on all the VTs, and because they keep
> popping up, I can't reasonably use the consoles to test if the network
> driver is working.
>
> The kernel I've got going at the moment is 2.6.23-rc9 with git
> revision g804b3f9a, and it's fine.  The error surfaced _sometime_
> after this.  Attached is my .config.
>
> I'll try rebooting and pinging the machine to see if the network
> driver is working, and this is just (unnecessary?) spew from the
> kernel.
>
> --
> Regards,
> Tom Spink
> University of Edinburgh
>
>

I bisected the kernel, with the following results:

git-bisect start
# bad: [c9927c2bf4f45bb85e8b502ab3fb79ad6483c244] Linux 2.6.24-rc1
git-bisect bad c9927c2bf4f45bb85e8b502ab3fb79ad6483c244
# good: [3146b39c185f8a436d430132457e84fa1d8f8208] Linux 2.6.23-rc9
git-bisect good 3146b39c185f8a436d430132457e84fa1d8f8208
# bad: [a9957449b08ab561a33e1e038df06843b8d8dd9f] sched: uninline scheduler
git-bisect bad a9957449b08ab561a33e1e038df06843b8d8dd9f
# bad: [038a5008b2f395c85e6e71d6ddf3c684e7c405b0] Merge branch
'master' of git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect bad 038a5008b2f395c85e6e71d6ddf3c684e7c405b0
# bad: [87bdc48d304191313203df9b98d783e1ab5a55ab] [IPSEC]: Get rid of
ipv6_{auth,esp,comp}_hdr
git-bisect bad 87bdc48d304191313203df9b98d783e1ab5a55ab
# bad: [1aafee265723818d903766212015b6116885bc6f] cxgb3 - Add T3C rev
git-bisect bad 1aafee265723818d903766212015b6116885bc6f
# good: [d6f2da5b33911a31eb61e1790ef8e555e9605837] [MAC80211]: Remove
bitfields from struct ieee80211_if_sta
git-bisect good d6f2da5b33911a31eb61e1790ef8e555e9605837
# good: [e2aa334bee4ae9fe27f26b0732c0443d2f11a8af] libertas: remove
adapter->scanprobes
git-bisect good e2aa334bee4ae9fe27f26b0732c0443d2f11a8af
# good: [64f222cce2605420470d7a1f678783bdc2754af6] zd1211rw:
consistent handling of ZD1211 specific rates
git-bisect good 64f222cce2605420470d7a1f678783bdc2754af6
# good: [c9a6ce500d78932c43361eae28c3de81b3660c77] cxgb3 - tighten
checks on TID values
git-bisect good c9a6ce500d78932c43361eae28c3de81b3660c77
# bad: [26fcfa95aef980cab4ff1ea55979c30e772dd0dd] pasemi_mac: RX
performance tweaks
git-bisect bad 26fcfa95aef980cab4ff1ea55979c30e772dd0dd
# bad: [555382cbfc6d2187b53888190755e56f52308cd6] sky2: advanced error reporting
git-bisect bad 555382cbfc6d2187b53888190755e56f52308cd6
# good: [3f61e4278c8489c1d026a45b0903cd4230d1ec07] cxgb3 - Update
internal memory management
git-bisect good 3f61e4278c8489c1d026a45b0903cd4230d1ec07
# good: [efcf6e2febbfe5b2ab497421e2f7f188e1741cf9] sky2: document GPHY_CTRL bits
git-bisect good efcf6e2febbfe5b2ab497421e2f7f188e1741cf9
# good: [8c4c00f3710f9e5653ed465e88271664f3163930] sky2: dont restrict
config space access
git-bisect good 8c4c00f3710f9e5653ed465e88271664f3163930


-- 
Regards,
Tom Spink
University of Edinburgh
