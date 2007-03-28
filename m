Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbXC1Thd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbXC1Thd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXC1Thd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:37:33 -0400
Received: from main.gmane.org ([80.91.229.2]:39088 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbXC1Thd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:37:33 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Backlund <tmb@mandriva.org>
Subject: Why is arch/s390/crypto/Kconfig sourced when building for another
 arch ?
Date: Wed, 28 Mar 2007 22:36:38 +0300
Message-ID: <eueg41$j5t$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ndn243.bob.fi
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Why is arch/s390/crypto/Kconfig sourced when building for another arch ?

I'm trying to package a stripped down version of the kernelsource with 
only arch-specific code (/arch/$arch & /include/asm-$arch), the rest of 
/include, the whole KBuild setup & contents of /scripts to build 
3rdparty drivers against...

With the above files I can do a:
mv .config config.temp
make mrproper
mv config.temp .config
make oldconfig prepare scripts

and the tree stays intact ...

with 2.6.20.4 it works great, but when switching to 2.6.21-rcX it breaks 
with this:

drivers/crypto/Kconfig:55: can't open file "arch/s390/crypto/Kconfig"

I tried to fix drivers/crypto/Kconfig by changing the code to:

if S390
source "arch/s390/crypto/Kconfig"
endif

but it still gets sourced...

Now, since this is the only arch messing up (atleast on ix86 & x86_64),
shouldn't this be fixed somehow ?

--
Thomas

