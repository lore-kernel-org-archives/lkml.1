Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbYE0WZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbYE0WZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbYE0WZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:25:11 -0400
Received: from main.gmane.org ([80.91.229.2]:38177 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022AbYE0WZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:25:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [REGRESSION][BISECTED][X86] next-20080526 hangs on boot
Date: Tue, 27 May 2008 23:16:41 +0100
Message-ID: <g1i1ls$pkl$1@ger.gmane.org>
References: <g1eg2q$81q$1@ger.gmane.org> <20080526161623.GC7305@cvg> <g1f230$7bl$1@ger.gmane.org> <g1f3ht$b9g$1@ger.gmane.org> <aa79d98a0805262335lf5cd4e1p8f318d45dfe7ff92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Cc: kernel-testers@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<posted & mailed>

Cyrill Gorcunov wrote:

> Hi Sitsofe, actually I can't imagine how this revert have helped you
> from hang. Newly introduced nmi_watchdog_default() didn't change
> the logic of the code being used before this merge-series.

I've just retested again and I'm fairly sure it's that commit. I can do the
following:

git checkout -f 4039cbaacf7874ab1effd0e9fb6c60bf9217f373

(compiled kernel hangs during boot)

git revert 1798bc22b2790bf2a956588e6b17c36ef79ceff7
git revert fd5cea02de100197a4c26d9e103508cf09b50a82
git revert 4b82b277707a39b97271439c475f186f63ec4692

(compiled kernel boots normally)

The last thing I normally see is
ACPI: Sleep Button (CM) [SLPB
during a normal boot is followed by
ACPI: device:03 is registered as cooling_device0
input: Video Bus
as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input3

If you can give me a patch that reverts just
4b82b277707a39b97271439c475f186f63ec4692 again the current HEAD of
linux-next then I will try that too...

-- 
Sitsofe | http://sucs.org/~sits/

