Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYCXCTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYCXCTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 22:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbYCXCTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 22:19:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:52106 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbYCXCTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 22:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=euuqwRe+INUCdSQubqvjXtyda7qks4+ITmb8u6gwdgLvVF79nfsjLIWSYhb1WFZvLMaKV6nY/X+64tyIJyd5lY3s+MTHaUgPbsFh8l03LhULFmSyhQI+KgSTvZsjvUSjLKKdiCTw+uXUG1jRGdB1RzgqShVGslVzlfaOuMIR2g8=
Message-ID: <47E70FB4.4010802@gmail.com>
Date: Mon, 24 Mar 2008 11:19:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: jeff@garzik.org, kurt@roeckx.be, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.25-rc6] sata_promise: fix hardreset hotplug events,
 take 2
References: <200803221421.m2MEL1oY021558@harpo.it.uu.se> <18406.38445.717175.664615@harpo.it.uu.se>
In-Reply-To: <18406.38445.717175.664615@harpo.it.uu.se>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> A Promise SATA controller will signal hotplug events when a hard
> reset (COMRESET) is done on a port. These events aren't masked by
> the driver, and the unexpected interrupts will cause a sequence
> of failed reset attempts util libata's EH finally gives up.
> 
> This has not been a common problem so far, but the pending libata
> hardreset-by-default changes makes it a critical issue.
> 
> The solution is to disable hotplug events before a reset, and to
> reenable them afterwards. (Promise's driver does this too.)
> 
> This patch adds SATA-specific versions of ->freeze() and ->thaw()
> that also disable and enable hotplug events. PATA ports continue
> to use the old versions of ->freeze() and ->thaw().
> 
> Accesses to the hotplug register must be serialised via host->lock.
> We rely on ap->lock == &ap->host->lock and that libata takes this
> lock before ->freeze() and ->thaw(). Document this requirement.
> The interrupt handler is adjusted so its hotplug register accesses
> are inside the region protected by host->lock.
> 
> Tested on various chips (SATA300TX4, SATA300TX2plus, SATAII150TX4,
> FastTrack TX4000) with various combinations of SATA and PATA disks,
> with and without the pending hardreset-by-default changes.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

Acked-by: Tejun Heo <htejun@gmail.com>

Jeff, do you want to merge this first?  If so, I'll update the
prefer-hardreset and cleanup-sht-ops patchsets; otherwise, I'll massage
this patch a bit so that it fits on top of those two patchsets.

-- 
tejun
