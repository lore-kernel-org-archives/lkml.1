Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZDGMvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZDGMvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZDGMvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:51:38 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:59541 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZDGMvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:51:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BMS/q9QsUiVP5+MJXV8FQzd+MhUKKM92+BbIk6Nz0BOgowc1183z3oVpgfm/G+QAxk
         STWwLOyGXUYhgRBew0eDP5qrHF92/YFgYo0bVM7I0dckRKkcplO9YL7QaroP0Qr2mYhQ
         c3VrfRI96xWIUW1DdcJeyAjHJV0moSoqh+MG0=
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239092296.22453.1.camel@johannes.local>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 15:51:29 +0300
Message-Id: <1239108689.15015.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 10:18 +0200, Johannes Berg wrote:
> On Tue, 2009-04-07 at 03:00 +0300, Maxim Levitsky wrote:
> 
> > I noticed that always first attempt at scan fails when NM asks for scan.
> > I also noticed that this happens with quite recent kernels (I think
> > 2,6.28) didn't have this behavior.
> 
> I'm pretty sure it did.
I am sure that on older kernel there was no -EBUSY error returned to
userspace. It probably just stalled the client.


> 
> > Looking a bit deeper I discovered that each time NM disconnects from a
> > networks it sets random ssid/essid to the card (using wireless
> > extensions)
> 
> This forces a scan
> 
> > After that scan fails for some time.
> > 
> > as a NM free example you can run 
> > 
> > iwconfig wlan0 essid dummy
> > iwlist scan
> 
> and then this fails with EBUSY.
Thanks for explanation.
Since NM has its reasons to clear essid (to prevent unwanted
association), then what can be  done to prevent this (and still use
wireless extensions, since nl80211 support isn't yet mature)?


Best regards,
	Maxim Levitsky

