Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbZJNMKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbZJNMKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbZJNMKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:10:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:58320 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZJNMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:10:36 -0400
Subject: Re: DMAR regression in 2.6.31 leads to ext4 corruption?
From: David Woodhouse <dwmw2@infradead.org>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Chris Wright <chrisw@sous-sol.org>, iommu@lists.linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091010014714.GG30557@hexapodia.org>
References: <20091009061729.GA31242@hexapodia.org>
	 <20091010000926.GA17547@sequoia.sous-sol.org>
	 <20091010014714.GG30557@hexapodia.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 13:09:26 +0100
Message-Id: <1255522166.4523.238.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 18:47 -0700, Andy Isaacson wrote:
> Well, we don't know for sure what happened on the previous boot where
> the filesystem corruption occurred.  I'm imagining a nightmare scenario
> where GPU erroneous writes cause DMAR faults and handling them somehow
> causes AHCI DMA requests to get lost.

Seems unlikely. The GPU faults happen whenever the GATT changes, because
it translates _every_ address in the GATT through the IOMMU right there
and then -- so if parts of the table are uninitialised, they'll cause
stray write faults. But no writes are actually _happening_.

> I'm going to go ahead on the theory that the BIOS needs an update.

I can't really imagine how that would help; how the BIOS would be
responsible for this. I'm more inclined to blame the drive. It's not an
SSD, is it?

-- 
dwmw2

