Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZDFLGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZDFLGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 07:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbZDFLFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 07:05:52 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:60583 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZDFLFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 07:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LPLa0LlNoap1DjDf4yP9IDWOCmpldOh627+qhQ4diU2hSgDemg8y2npmpHROn5DUZ0
         /njk0nUz+oRk/EyHOlzSn2v87pSj9Q6ZrJ9W0yaGmhr2I+V7BfuDuPZ1Y+JSTy2Uo4WC
         VmsFN0wtxCBCFjLA1qxIV4Ivo35JBP/BrLChE=
MIME-Version: 1.0
In-Reply-To: <200904061251.10965.helmut.schaa@gmail.com>
References: <1238923439.4120.9.camel@localhost.localdomain>
	 <200904061217.31134.mb@bu3sch.de> <87tz52xepy.fsf@litku.valot.fi>
	 <200904061251.10965.helmut.schaa@gmail.com>
Date: Mon, 6 Apr 2009 14:05:46 +0300
X-Google-Sender-Auth: 266aaf6c979ff1b0
Message-ID: <da94abde0904060405k280b3094jc20d0f7a4e6e759d@mail.gmail.com>
Subject: Re: ath9k becon loss messages
From: Kalle Valo <kalle.valo@iki.fi>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 1:51 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Montag, 6. April 2009 schrieb Kalle Valo:
>
>> But ath9k nor iwlwifi don't support beacon filtering and this is a
>> problem in mac80211. We need to disable the beacon loss check in
>> mac80211, most probably by stopping the associated timer whenever
>> scanning.
>
> Yeah, but the first execution of the timer will then also detect
> beacon loss:
>
> 1006   if (!((local->hw.flags & IEEE80211_HW_BEACON_FILTER) &&
> 1007         (local->hw.conf.flags & IEEE80211_CONF_PS)) &&
> 1008       time_after(jiffies,
> 1009            ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {
>
> If the scan took longer then IEEE80211_MONITORING_INTERVAL (=2 sec) this
> condition will apply just after the scan finished.

Not if we do "mod_timer(&ifmgd->timer, jiffies +
IEEE80211_MONITORING_INTERVAL)" after the scan has finished. That way
there's enought time to receive beacons before the timer triggers.

> Maybe this issue could be
> avoided by making the beacon loss detection smarter then just checking if no
> beacon was received within the last two seconds.

Definitely the beacon loss logic should be smarter, but I think that
should be improved separately. I just have tried to do small changes
at a time to avoid regressions and I didn't even consider improving
the beacon loss logic.

Kalle
