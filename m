Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYIQUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYIQUL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 16:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYIQULq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 16:11:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbYIQULp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 16:11:45 -0400
Date: Wed, 17 Sep 2008 13:11:33 -0700 (PDT)
Message-Id: <20080917.131133.135282530.davem@davemloft.net>
To: j@w1.fi
Cc: jouni.malinen@atheros.com, alex.williamson@hp.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking (WEXT events and 64/32 compat)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080917191128.GA23239@hostap.isc.org>
References: <20080908.204323.04156464.davem@davemloft.net>
	<20080909040525.GA26151@hostap.isc.org>
	<20080917191128.GA23239@hostap.isc.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jouni Malinen <j@w1.fi>
Date: Wed, 17 Sep 2008 12:11:28 -0700

> Would it be acceptable to ever enable use of IWEVASSOCREQIE /
> IWEVSSOCRESPIE in kernel if the workaround were available in new
> wpa_supplicant versions? Or should we try to add a new WEXT event
> type that uses fixed size for the length field and then replace the old
> IWEVCUSTOM with the new type since IWEVCUSTOM does not work with
> 64/32-bit case (wpa_supplicant just knows how to avoid processing that
> bogus event data)?

Moving to a new event with a strictly sized datastructure, instead of
one that has variable sized members like pointers and crap which are
impossible to compat layer'ify, is indeed my preference.

But in that case, we might as well make nl80211 usable instead.

We'll always have those existing wpa_supplicant binaries out there, we
can't break them.  And the size checks wpa_supplicant makes is a BOGUS
and REDICULIOUS way to get these malformed objects "supported" and
"usable".
