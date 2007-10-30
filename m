Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbXJ3WHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbXJ3WHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXJ3WHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:07:36 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:56044 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751989AbXJ3WHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:07:36 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Date: Tue, 30 Oct 2007 15:04:35 -0700
User-Agent: KMail/1.9.7
Cc: Arjan van de Ven <arjan@infradead.org>, Robert Hancock <hancockr@shaw.ca>,
       Greg KH <greg@kroah.com>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <20071030094756.779ac5c0@laptopd505.fenrus.org> <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301504.36972.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2007 10:07 am Linus Torvalds wrote:
> (Where "screwed up badly" is the usual "left it to firmware people"
> thing, of course. Dammit, Intel *could* have just made it a real PCI
> BAR in the Northbridge, and specified it as such, and we wouldn't
> have these problems! But no, it had to be another idiotic "firmware
> tells where it is" thing)

The per-device flag is fine with me, but I should make something clear:

MMCONFIG IS NOT BROKEN!

Nor is finding mmconfig space.  We know how to do that too.

What's broken is our PCI probing with certain address space layouts that 
include MMCONFIG space.  Since MMCONFIG is in MMIO space (by 
definition) there will always be the potential for problems when we use 
MMCONFIG and don't disable decode while sizing BARs (probably a latent 
bug on many non-PC Linux platforms).

So we can either use I/O ports for sizing and only switch to MMCONFIG 
later, or we can just use it on an as-needed basis, or we can make our 
PCI probing safe if MMCONFIG is in use.

Jesse
