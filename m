Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYIIEQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYIIEQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbYIIEOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:14:12 -0400
Received: from hostap.isc.org ([149.20.54.63]:59148 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045AbYIIEOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:14:10 -0400
Date: Mon, 8 Sep 2008 21:05:25 -0700
From: Jouni Malinen <j@w1.fi>
To: David Miller <davem@davemloft.net>
Cc: j@w1.fi, jouni.malinen@atheros.com, alex.williamson@hp.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20080909040525.GA26151@hostap.isc.org>
References: <48C5E2FC.4090304@atheros.com> <20080908.194627.169864643.davem@davemloft.net> <20080909025525.GB25148@hostap.isc.org> <20080908.204323.04156464.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908.204323.04156464.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 08:43:23PM -0700, David Miller wrote:

> If we're talking about the netlink emission of WEXT blobs, then such
> bits cannot be fixed unfortunately, because via netlink we don't know
> in the message generating context what kind of process will receive
> the message.

OK. Interesting point here is that the old code was using IWEVCUSTOM
which is defined as having header_type IW_HEADER_TYPE_POINT and so are
the new IWEVASSOCREQIE and IWEVASSOCRESPIE. The only difference is in
max_tokens specifying different maximum length for the data. Maybe the
old code was also broken, but wpa_supplicant handled the bogus data
without causing problems (text parsing failing instead of some
parameters being set based on bogus binary data).

> In fact, when broadcasting a netlink message, applications of different
> dispositions can want to receive the message.
> 
> So in essence netlink cases cannot be fixed for COMPAT handling,
> rather, netlink protocols must be designed to be COMPAT agnostic from
> the beginning, and use fixed sized types only.  WEXT was not.

I haven't looked how IW_HEADER_TYPE_POINT headers get encoded with
wireless_send_event(), but it sounds likely something there gets
different field size. It sounds like there is not really a good
solution for this with the current iw event types and should we want to
get the original issue fixed, something new would need to be
specified.. Would people be fine with extending wireless_send_event()
with new event types that use fixed sized fields or is someone going to
be interesting in providing a better replacement for this functionality?

-- 
Jouni Malinen                                            PGP id EFC895FA
