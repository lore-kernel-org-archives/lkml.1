Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZFEOFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZFEOFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:05:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZFEOEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:04:53 -0400
Received: from nbd.name ([88.198.39.176]:47111 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZFEOEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:04:53 -0400
Message-ID: <4A2925F8.6060602@openwrt.org>
Date: Fri, 05 Jun 2009 16:04:40 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, rathamahata@gmail.com,
       ognjen.maric@gmail.com, rjw@sisk.pl, stable@kernel.org
Subject: Re: [PATCH] mac80211: fix minstrel single-rate memory corruption
References: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland wrote:
> The minstrel rate controller periodically looks up rate indexes in
> a sampling table.  When accessing a specific row and column, minstrel
> correctly does a bounds check which, on the surface, appears to handle
> the case where mi->n_rates < 2.  However, mi->sample_idx is actually
> defined as an unsigned, so the right hand side is taken to be a huge
> positive number when negative, and the check will always fail.
> 
> Consequently, the RC will overrun the array and cause random memory
> corruption when communicating with a peer that has only a single rate.
> The max value of mi->sample_idx is around 25 so casting to int should
> have no ill effects.
> 
> Without the change, uptime is a few minutes under load with an AP
> that has a single hard-coded rate, and both the AP and STA could
> potentially crash.  With the change, both lasted 12 hours with a
> steady load.
> 
> Thanks to Ognjen Maric for providing the single-rate clue so I could
> reproduce this.
> 
> This fixes http://bugzilla.kernel.org/show_bug.cgi?id=12490 on the
> regression list (also http://bugzilla.kernel.org/show_bug.cgi?id=13000).
> 
> Cc: stable@kernel.org
> Reported-by: Sergey S. Kostyliov <rathamahata@gmail.com>
> Reported-by: Ognjen Maric <ognjen.maric@gmail.com>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> 
> John & Felix, the patch itself may be too subtle so feel free to do it a
> different way.  However this is as minimal as it gets so I hope it can
> be applied quickly to stable, and mainline if not too late.
How about changing the type of sample_idx to signed instead of casting
it? It's just a cosmetic thing, so even if you leave at this you get my
Acked-by: Felix Fietkau <nbd@openwrt.org>

- Felix
