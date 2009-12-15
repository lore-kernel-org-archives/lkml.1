Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbZLOKUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbZLOKUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbZLOKUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:20:51 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:42581 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759657AbZLOKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:20:48 -0500
Date: Tue, 15 Dec 2009 18:20:35 +0800
From: Daniel Mack <daniel@caiaq.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       dcbw@redhat.com, m.hirsch@raumfeld.com, netdev@vger.kernel.org,
       libertas-dev@lists.infradead.org, stable@kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: wext: allocate space for NULL-termination
 for 32byte SSIDs
Message-ID: <20091215102035.GJ28375@buzzloop.caiaq.de>
References: <1260650850-16163-1-git-send-email-daniel@caiaq.de>
 <20091215.014308.77044043.davem@davemloft.net>
 <1260871411.3692.4.camel@johannes.local>
 <1260871634.3692.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260871634.3692.6.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:07:14AM +0100, Johannes Berg wrote:
> On Tue, 2009-12-15 at 11:03 +0100, Johannes Berg wrote:
> 
> > Since you indicate the kernel crashed, it is likely that libertas is
> > treating the buffer as a string, instead of an SSID.

Ok, I dodn't know that - thanks for pointing it out. In my setup here,
SSIDs are always valid alphanumeric strings, and I was mislead by the
comment that mentions the NULL-termination.

> drivers/net/wireless/libertas$ grep lbs_deb_ * | grep ssid|grep '%s'
> assoc.c:	lbs_deb_join("current SSID '%s', ssid length %u\n",
> assoc.c:	lbs_deb_join("requested ssid '%s', ssid length %u\n",
> assoc.c:	lbs_deb_join("ADHOC_START: SSID '%s', ssid length %u\n",
> scan.c:		lbs_deb_wext("set_scan, essid '%s'\n",

Those macros are stubbed out as nops in my setup, so they can
unfortunately not be the reason. I'll dig deeper :)

Thanks,
Daniel
