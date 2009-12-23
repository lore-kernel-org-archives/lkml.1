Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZLWBQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZLWBQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZLWBQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:16:47 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:48849 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZLWBQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:16:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=WD6zT1Vp0JFra41pm5gcvmXrpsNdlUlkqXucvzR2/s8VQqrWr+K1u6TaNjY9O7EjBC
         5W5zbuSaNPbql1NAaF68sMSrjDgeOpLxV6np+UW9g7/fxmyzLmRTjflor5WdYv6uaWOt
         ZDW//9yzAkUJkWp+Y8mgg2ixQkfaPzRrdwLos=
MIME-Version: 1.0
In-Reply-To: <20091222175939.GF4385@tux>
References: <20091222022355.GA32508@bombadil.infradead.org> 
	<19248.19829.293087.367661@gargle.gargle.HOWL> <20091222155005.GA4385@tux> 
	<20091222162055.GC4385@tux> <20091222165528.GE4385@tux> <20091222175939.GF4385@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 22 Dec 2009 17:16:25 -0800
X-Google-Sender-Auth: ebad867abea153d2
Message-ID: <43e72e890912221716r64ea4542qd747302b536a3156@mail.gmail.com>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Jonathan May <jonathan.may@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK I have to go now but I managed to get this working without the
issue coming up. At this point I am not sure if all of these are
required but I cherry picked 2 patches from wireless-testing and then
added 4, one based on sujith's suggestion.

http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0001-mac80211-fix-resume.patch
http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0002-mac80211-fix-WMM-AP-settings-application.patch

http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0003-ath9k-set-and-restore-ps-prior-to-stop-and-interface.patch
http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0004-ath9k-ensure-hardware-is-awake-during-ampdu-TX-actio.patch

http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0005-ath9k-synch-TX-DMA-buffer-upon-TX-cancelation.patch
http://bombadil.infradead.org/~mcgrof/patches/pm-stuff/0006-ath9k-do-not-wake-up-device-if-it-hasn-t-been-starte.patch

Its likely only patch 3, 4, and 6 are the only ones required. In fact
maybe even 6 will fix it, but I just gotta go so cannot test that. I
was able to resume about 10 times consecutively which I was unable to
do before.

  Luis
