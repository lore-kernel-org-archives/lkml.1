Return-Path: <linux-kernel-owner+w=401wt.eu-S1764217AbXGXOpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764217AbXGXOpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXGXOpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:45:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44318 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbXGXOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:45:22 -0400
Subject: Re: [PATCH] LinuxPPS - definitive version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070724143147.GE4074@enneenne.com>
References: <20070717180550.GA24759@enneenne.com>
	 <1185197716.14697.244.camel@pmac.infradead.org>
	 <20070724080013.GA22171@gundam.enneenne.com>
	 <1185284942.14697.319.camel@pmac.infradead.org>
	 <20070724143147.GE4074@enneenne.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 15:45:19 +0100
Message-Id: <1185288319.14697.330.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 16:31 +0200, Rodolfo Giometti wrote:
> drivers/built-in.o: In function `sys_time_pps_fetch':
> (.text+0x5f05e): undefined reference to `__udivdi3' 

Hm, not sure. Maybe put it back to uint32_t and then add another
uint32_t of explicit padding, or maybe just cast it to uint32_t when you
divide:

	ticks += (uint32_t)to.nsec / (NSEC_PER_SEC/HZ);

-- 
dwmw2

