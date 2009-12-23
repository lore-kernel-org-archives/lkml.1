Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZLWTT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZLWTT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZLWTT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:19:56 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:50806 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZLWTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:19:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=fxthiLSv5/lj30KupS1vt7O/KavolxE2LtOHY1Hk65wFbBiNFqIhT+DEGyXh4Ib/4a
         HGKRE4HdL7Y+1g5+btYUW6g3hHbsI+WqA/H+kvP4OnPjpKVTVSYTF3sE6tZbLm5YaUZw
         omEL5Mce/t5ZOCJsHA2T5vv8r/A41zqWJheeo=
MIME-Version: 1.0
In-Reply-To: <1261595489.27798.0.camel@johannes.local>
References: <20091222022355.GA32508@bombadil.infradead.org> 
	<20091222193010.GB30201@bombadil.infradead.org> <1261570081.25008.1.camel@johannes.local> 
	<20091223162813.GB2609@tux> <1261586828.7304.13.camel@johannes.local> 
	<20091223190840.GI2609@tux> <1261595489.27798.0.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 23 Dec 2009 11:19:33 -0800
X-Google-Sender-Auth: 053ca2694cc848c1
Message-ID: <43e72e890912231119l79ef5a99h6b57362e38f189ed@mail.gmail.com>
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend 
	issue and mac80211 suspend corner) case
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 11:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-12-23 at 11:08 -0800, Luis R. Rodriguez wrote:
>
>> So you want drivers to handle start() failures (even if its not for
>> resume) with an unregistration to mac80211?
>
> Not necessarily. If it's a temporary error, that's fine, of course, but
> if the hardware is suddenly inaccessible for whatever reason then yes,
> of course, unregistering is the only good choice no matter when it
> happens.

Reason for me suggesting for mac80211 to deal with this is drivers
won't know if their failed start() call will have been from resume and
we likely won't add a bool to start() callback since we already
debated this a while back.

I don't really care about hardware failures in other cases right now,
and do think resume is reasonable enough to check for and handle on
mac8021 alone. Since stop() would have stopped everything in the
driver and is documented as such I don't see why it would be
complicated to unregister it instead from mac80211.

  Luis
