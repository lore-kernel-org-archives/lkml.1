Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYGaHnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYGaHnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYGaHm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:42:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYGaHm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:42:57 -0400
Subject: Re: [PATCH] typhoon: use request_firmware
From: David Woodhouse <dwmw2@infradead.org>
To: David Dillow <dave@thedillows.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, becker@scyld.com,
       davidpmclean@yahoo.com, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <1217475466.16202.15.camel@obelisk.thedillows.org>
References: <1217170232.3537.6.camel@jaswinder.satnam>
	 <1217209400.22789.47.camel@obelisk.thedillows.org>
	 <1217215009.2970.7.camel@jaswinder.satnam>
	 <1217248585.22789.58.camel@obelisk.thedillows.org>
	 <1217253260.17632.6.camel@jaswinder.satnam>
	 <1217295498.28682.16.camel@obelisk.thedillows.org>
	 <1217347786.2885.11.camel@jaswinder.satnam>
	 <1217395511.31350.6.camel@obelisk.thedillows.org>
	 <1217400251.2595.3.camel@jaswinder.satnam>
	 <1217475466.16202.15.camel@obelisk.thedillows.org>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 08:42:53 +0100
Message-Id: <1217490173.3454.47.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 23:37 -0400, David Dillow wrote:
> request_firmware()'s mutex is protecting against things inside of that
> subsystem, but offers no protection between the test on typhoon_fw !=
> NULL and the setting of it inside of the firmware loader. That
> requires locking at a higher level.
> 
> Anyways, probing is single threaded and I seem to recall it being
> unlikely to be made parallel due to the number issues exposed last
> time, so a minimal comment is fine.

An alternative approach is to make request_firmware() do the duplicate
avoidance for itself. Since we made fw->data const (as 'fw' itself
always was), no users should be changing anything in the requested
firmware. It can be safely reused by generic code.

That simplifies the logic in drivers -- they just request what they
want, as many times as they want it, and don't have to care about the
potential duplication.

-- 
dwmw2

