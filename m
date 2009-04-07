Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbZDGNwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbZDGNwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZDGNv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:51:56 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34606 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbZDGNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A1gmaUvDOVJkjvmpTN/qhvlRU2ffCFta7ajimuU2NMkWq5By14xO71hcaVeOFKBImD
         cRS+IW+gvnPMVWoA05f7fecF627EEU+PKgLPxYHBYKRdJui8vb8WLQs3fM9d6VohhQHm
         ZHl1msTEpAl5W+zaKMZC13/WkqLi4hv6y3uuE=
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239110860.4084.0.camel@johannes.local>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 16:51:50 +0300
Message-Id: <1239112310.15015.25.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 15:27 +0200, Johannes Berg wrote:
> On Tue, 2009-04-07 at 16:20 +0300, Maxim Levitsky wrote:
> 
> > > Of course, we can go back to dropping the scan request, but that
> > > wouldn't be very nice.
> > > 
> > > Is this creating any problems?
> 
> > Yep, but dropping the request won't help ether.
> 
> Indeed.
> 
> > Problem is that wpa_supplicant will attempt to scan before association,
> > scan fails (it doesn't know it is already running) thus it waits 10
> > seconds. (I patched it to wait 2 seconds).
> > 
> > It happens if user first disconnects, and then reconnects to a network
> > (typical test I do for time it takes to connect)
> > 
> > Now I patched it not to clear essid on disconnect, and this helped
> > reduce connect times by about 2 seconds.
> > 
> > now it takes just 3~4 seconds to connect to open network, and ~6 seconds
> > to WPA2 network.
> > 
> > (This is with patched dhclient, I reduced its timeouts, but this is
> > another story.... it seems that first DHCPREQUEST never succeeds, and I
> > tested this with 2 cards, and few wireless networks)
> 
> Have you tried with a new tree and wpa_supplicant's (from git) nl80211
> driver? Might be a lot better.
I use NM and wpa_supplicant from -git
Last time, I tried nl80211 wpa_supplicant driver it didn't work well,
but I try again soon I  hope.
 

Best regards,
	Maxim Levitsky
> 
> johannes

