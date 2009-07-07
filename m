Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbZGGV3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbZGGV3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbZGGV3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:29:40 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45664 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759056AbZGGV3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:29:39 -0400
Subject: Re: Possible memory leak in net/wireless/scan.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1246986768.4755.43.camel@johannes.local>
References: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
	 <1246986768.4755.43.camel@johannes.local>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 07 Jul 2009 22:29:28 +0100
Message-Id: <1247002168.5710.1.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 21:29:30.0053 (UTC) FILETIME=[030BAF50:01C9FF4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 19:12 +0200, Johannes Berg wrote:
> On Tue, 2009-07-07 at 18:04 +0100, Catalin Marinas wrote:
> 
> > diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> > index e95b638..f8e71b3 100644
> > --- a/net/wireless/scan.c
> > +++ b/net/wireless/scan.c
> > @@ -366,7 +366,6 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
> >  	found = rb_find_bss(dev, res);
> >  
> >  	if (found) {
> > -		kref_get(&found->ref);
> >  		found->pub.beacon_interval = res->pub.beacon_interval;
> >  		found->pub.tsf = res->pub.tsf;
> >  		found->pub.signal = res->pub.signal;
> > 
> > I'll try this later today to see if it fixes the leak. If that's not
> > correct, I'll post more information about the content of the reported
> > object (in general, it shouldn't be on any valid list or rb tree since
> > kmemleak can't find it).
> 
> I have already sent that exact patch.

OK. I can now confirm that it fixes the memory leak.

Thanks.

-- 
Catalin

