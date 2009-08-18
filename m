Return-Path: <linux-kernel-owner+w=401wt.eu-S1751078AbZHREze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbZHREze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 00:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZHREze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 00:55:34 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36359 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbZHREzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 00:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=GxhsUWZuLH66yaGq8mVsCLABLk8g47th0Yxu5JzQRtHglIYSXI8rLI/cJbR5kj6QS6
         mZDVx3WYwixaTjuaQ/3XDjl27g3+XOyZ6/wQAFhqWLNbv4fcSHf2zxboQ72hwDCNCpL+
         eGgnunkIJd89BTfadCeABtMiBSCki5U0VLqD0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: new ipdelay= option for faster netboot
Date: Tue, 18 Aug 2009 06:56:53 +0200
User-Agent: KMail/1.8.2
Cc: tim.bird@am.sony.com, r.schwebel@pengutronix.de,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       arjan@linux.intel.com, kernel@pengutronix.de, netdev@vger.kernel.org
References: <4A89DB15.6060101@am.sony.com> <4A8A02CA.7040305@am.sony.com> <20090817.182754.50348941.davem@davemloft.net>
In-Reply-To: <20090817.182754.50348941.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908180656.54011.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 August 2009 03:27, David Miller wrote:
> From: Tim Bird <tim.bird@am.sony.com>
> Date: Mon, 17 Aug 2009 18:24:26 -0700
> 
> > David Miller wrote:
> >> I have card/switch combinations that take up to 10 seconds to
> >> negotiate a proper link.
> > 
> > What types of delays are these timeouts supposed to
> > cover?
> 
> The problem is that if you don't first give at least some time for the
> link to come up, the remaining time it takes the link to come up will
> end up chewing into the actual bootp/dhcp protocol timeouts.  And
> that's what we're trying to avoid.

But in this case, they assign a static IP. They do not use DHCP.
So they pay this time penalty even if they wouldn't use networking
until sometime later (or never).

Since DHCP and any other networking activity like TCP connects
accomodate packet loss, things should work even without any delay
in kernel IP config code. The delay will be just shifted to the
moment when first DHCP/TCP/whatever negotiation happens.

If dropping delays altogether sounds too big a change,
then it makes sense at least to allow people to tweak it with
ipdelay=TIME_IN_MS

-- 
vda

