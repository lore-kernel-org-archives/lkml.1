Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZDFKYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZDFKYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 06:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZDFKYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 06:24:00 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56201 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZDFKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 06:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=QabSTAIgQ1997d8ciPUVBF8RCfoncTtZT5EqQEMXOx5+JZfawYGd2OmupG3xCESOZr
         yb52ewu5shcN0zQSOEyngJc5SQQAZGQtDxZzqNHX5a2aXBtWq4i7S4V1D3LhV+xoVfTl
         V0FpVFwGPiahbd+jUnM+IvMNBFF2WZuqbHk6s=
To: Michael Buesch <mb@bu3sch.de>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<87bprbif2f.fsf@litku.valot.fi>
	<200904060914.32245.helmut.schaa@gmail.com>
	<200904061217.31134.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 06 Apr 2009 13:23:53 +0300
In-Reply-To: <200904061217.31134.mb@bu3sch.de> (Michael Buesch's message of "Mon\, 6 Apr 2009 12\:17\:30 +0200")
Message-ID: <87tz52xepy.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch <mb@bu3sch.de> writes:

>> NetworkManager typically scans every 120 seconds and I can also trigger
>> the messages by a manual scan with iwlist. I did not dig any further but
>> the messages seem to appear right at the end of the scan. Tried with iwlagn
>> and both sw_scan and hw_scan.
>
> Yeah OK. While scanning it's expected to lose some frames.
>
> However, the driver should probably protect against this by using the
> scan notification callbacks. It could disable beacon-loss reporting
> while scanning.

That case is already covered. In sw_scan mac80211 will disable power
save and hence beacon filter is also disabled. With hw_scan the firmware
should be clever enough to not emit beacon loss events when scanning.

But ath9k nor iwlwifi don't support beacon filtering and this is a
problem in mac80211. We need to disable the beacon loss check in
mac80211, most probably by stopping the associated timer whenever
scanning.

-- 
Kalle Valo
