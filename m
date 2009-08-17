Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbZHQWEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbZHQWEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZHQWEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:04:10 -0400
Received: from solitude.tty.gr ([95.154.208.37]:56282 "EHLO mx.tty.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZHQWEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:04:09 -0400
X-Greylist: delayed 2175 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Aug 2009 18:04:09 EDT
Message-ID: <4A89CB52.4030008@debian.org>
Date: Tue, 18 Aug 2009 00:27:46 +0300
From: Faidon Liambotis <paravoid@debian.org>
Organization: Debian
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Weidong Han <weidong.han@intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       iommu@lists.linux-foundation.org, allen.m.kay@intel.com,
       fenghua.yu@intel.com
Subject: [regression, bisected] fails to boot on Dell Optiplex 760 with VT-d
 enabled
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am experiencin a bug on an Dell Optiplex 760 with a configuration that
has an Intel Core2 Q9550 CPU and with an up-to-date BIOS, version A03.

When "VT for Direct I/O" is enabled in the BIOS, v2.6.30 boots and works
perfectly, while v2.6.31-rc1..rc6 fail (both of them x86-64).

More specifically, I get an endless loop of printing the following
messages in
the screen:
        DMAR: [DMA Read] Request device [ff:1f.7] fault addr
              fffffffffffff000
        DMAR: [fault reason 255] Unknown
and the boot process doesn't move on from there.

I ran git bisect good v2.6.30/bad v2.6.31-rc1 and I was pointed to the
following commit:
	937582382c71b75b29fbb92615629494e1a05ac0
	x86, intr-remap: enable interrupt remapping early

I have no idea if VT-d is functioning on v2.6.30; I just had the option
enabled in the BIOS and noticed the problem when I tried to upgrade to
2.6.31-rcX.

I've read a similar bug report against a Mandriva kernel and another
VT-d related bug for the same hardware against Xen and in both threads
they were finger-pointing the BIOS.

I'm not sure if that's the case but, even if it is, I'd expect the
system to boot, like previous versions did, perhaps printing a warning
about VT-d functionality.

Thanks,
Faidon
