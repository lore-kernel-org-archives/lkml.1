Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbZHRE76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbZHRE76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 00:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZHRE75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 00:59:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36822
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbZHRE75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 00:59:57 -0400
Date: Mon, 17 Aug 2009 22:00:08 -0700 (PDT)
Message-Id: <20090817.220008.26173943.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: tim.bird@am.sony.com, r.schwebel@pengutronix.de,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       arjan@linux.intel.com, kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: new ipdelay= option for faster netboot
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908180656.54011.vda.linux@googlemail.com>
References: <4A8A02CA.7040305@am.sony.com>
	<20090817.182754.50348941.davem@davemloft.net>
	<200908180656.54011.vda.linux@googlemail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 18 Aug 2009 06:56:53 +0200

> Since DHCP and any other networking activity like TCP connects
> accomodate packet loss, things should work even without any delay
> in kernel IP config code. The delay will be just shifted to the
> moment when first DHCP/TCP/whatever negotiation happens.

Until the link is up, the packet scheduler just holds onto packets
and queued them up.

When the link comes up, this queue is released and the packets
sent out.

That's why it's beneficial to wait some time until the link
comes up before we start sending stuff out.  Because otherwise
any timeouts used will be inaccurate.

This could code be spiffed up to wait for the link up indication
on devices it cares about.  Feel free to code that up :-)
