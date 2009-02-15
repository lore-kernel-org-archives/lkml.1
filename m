Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZBOOX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZBOOX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZBOOXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:23:50 -0500
Received: from bu3sch.de ([62.75.166.246]:43373 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbZBOOXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:23:49 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Florian Fainelli <florian@openwrt.org>
Subject: Re: [OpenWrt-Devel] [PATCH] bcm47xx: Fix GPIO API return codes
Date: Sun, 15 Feb 2009 15:22:11 +0100
User-Agent: KMail/1.9.9
Cc: openwrt-devel@lists.openwrt.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200902142127.19521.mb@bu3sch.de> <200902151427.39196.florian@openwrt.org>
In-Reply-To: <200902151427.39196.florian@openwrt.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902151522.11291.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009 14:27:36 Florian Fainelli wrote:
> Hi Michael,
> 
> Le Saturday 14 February 2009 21:27:19 Michael Buesch, vous avez écrit :
> > The GPIO API is supposed to return 0 or a negative error code,
> > but the SSB GPIO functions return the bitmask of the GPIO register.
> > Fix this by ignoring the bitmask and always returning 0. The SSB GPIO
> > functions can't fail.
> 
> At some point we might want to convert the existing board code to use gpiolib. 
> I will try to come up with a patch for this later this afternoon.

Well, why? What's the advantage?
I think it would degrade performance even more, due to yet another few function
calls in the hotpath. And yes, performance does matter.

The only reason the optional inlined GPIO API exists is to avoid the gpiolib callbacks
on platforms where the GPIO numbers are written in stone anyway.
And that's the case for bcm47xx

-- 
Greetings, Michael.
