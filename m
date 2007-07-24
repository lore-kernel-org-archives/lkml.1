Return-Path: <linux-kernel-owner+w=401wt.eu-S1765779AbXGXOqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765779AbXGXOqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXGXOqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:46:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45725 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbXGXOqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:46:45 -0400
Subject: Re: [PATCH] LinuxPPS - definitive version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070724142050.GD4074@enneenne.com>
References: <20070717180550.GA24759@enneenne.com>
	 <1185197716.14697.244.camel@pmac.infradead.org>
	 <20070724080013.GA22171@gundam.enneenne.com>
	 <1185284942.14697.319.camel@pmac.infradead.org>
	 <20070724142050.GD4074@enneenne.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 15:46:42 +0100
Message-Id: <1185288402.14697.332.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 16:20 +0200, Rodolfo Giometti wrote:
> The problem is that we can have several PPS sources into a system and
> all these sources will arise their IRQ line (quasi)simultaneously and
> I don't wish a CPU may delay one of these IRQ handler due a spinlock
> into the pps_event().
> 
> That's why I'm trying to avoid any lock into pps_event().

The spinlock really wouldn't be held for long. It really shouldn't be a
problem, and it shouldn't hold up your timings at all. And presumably
you'd have a _different_ spinlock for each source, so they wouldn't
stomp on each other at all.

-- 
dwmw2

