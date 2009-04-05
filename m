Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZDEKNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZDEKNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 06:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZDEKNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 06:13:19 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39362 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbZDEKNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 06:13:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=FCB2x/pqQ9P1/kJZ6VLteSGFmIzbIWoNmGZBrwA5JgprXybS67c2aMbma0culmIpv8
         Uu6rCroVNY1AmLz6r25uczchrdvE0nxGYg5+XU80UuI3SCl6VI1sbqSLzMd8BpdkaivR
         1vj4XXYVsxJAFUR6JjxpxgVsemj8ir9j1VyCQ=
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>, Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<200904051129.38904.mb@bu3sch.de>
	<1238925174.4120.12.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 05 Apr 2009 13:13:12 +0300
In-Reply-To: <1238925174.4120.12.camel@localhost.localdomain> (Jaswinder Singh Rajput's message of "Sun\, 05 Apr 2009 15\:22\:54 +0530")
Message-ID: <87bprbif2f.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

>> And besides that, I think one can easily remotely trigger this
>> message and flood the logs. So it should probably _also_ be
>> ratelimited.
>
> normally it prints after 120 seconds:
>
> [ 1078.848434] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> [ 1198.822913] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> [ 1318.824931] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request

Then there is something happening in ath9k or your AP which prevents
ath9k from receiving beacons. Try pinging your AP with 100 ms
interval. Do you see anything happening in 120 s intervals?

If ath9k can't receive beacons in a 120 s interval, I would expect to
see delays also in the data path at the same time.

-- 
Kalle Valo
