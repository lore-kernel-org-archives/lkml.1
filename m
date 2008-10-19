Return-Path: <linux-kernel-owner+w=401wt.eu-S1751841AbYJSQdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbYJSQdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 12:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJSQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 12:33:00 -0400
Received: from hs-out-0708.google.com ([64.233.178.244]:31664 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbYJSQc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 12:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DaA6AV3FYg3eKeZRagUUvXjT4rIUmHUvS9LrqGqN02bWLJBbw/kZM0INat2NQkEKvQ
         +LnrnNKj3R9qljIDIoL41Q8Gn//J8q3/QGKSJ3cOvEbzhwnzaFl/J8Pwh6PcxFnhXKpg
         Z+fXItGLQFMvhL761tBscOpuvCLtc3rwg/AiM=
Message-ID: <83f9afec0810190932v7ca18936m1c1fdba9323159a4@mail.gmail.com>
Date: Sun, 19 Oct 2008 19:32:55 +0300
From: "Yauhen Kharuzhy" <jekhor@gmail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [PATCH] MMC: Fix race condition in resume/card detect code
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081019160422.GA16377@jeknote.loshitsa1.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224173376-25829-1-git-send-email-jekhor@gmail.com>
	 <20081018191147.00327019@mjolnir.drzeus.cx>
	 <20081019160422.GA16377@jeknote.loshitsa1.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/19 Yauhen Kharuzhy <jekhor@gmail.com>:
> On Sat, Oct 18, 2008 at 07:11:47PM +0200, Pierre Ossman wrote:
>> On Thu, 16 Oct 2008 19:09:36 +0300
>> Yauhen Kharuzhy <jekhor@gmail.com> wrote:
>>
>> > When device wakes up by card change interrupt and MMC_UNSAFE_RESUME is
>> > enabled then race condition between mmc_rescan() and
>> > mmc_resume()/mmc_sd_resume() appeared.
>> >
>> > Resume functions can sleep into mmc_remove_card() and at this time
>> > mmc_rescan() can be called by delayed work handler. Double-free of
>> > kobject or double-remove of host->card can be result of this.
>> >
>> > This patch adds an mutex which deny simultaneous executing of
>> > mmc_sd_resume()/mmc_resume() and mmc_rescan() functions. Probably, it is
>> > not right way.
>> >
>> > Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
>> > ---
>>
>> Can't we just ask the PM layer if this device is currently resuming,
>> and if so ignore card notifications from the driver?
>
> What about another idea: mmc_sd_resume() checks if host->detect is
> scheduled and if true then it don't try to reinitialize card.
> host->detect can be scheduled at this moment only in one case: if device has been waked up by
> card change interrupt.
Hmm... But it will cause a race condition if SD card change interrupt
will be raised during resume process.

-- 
Best regards,
    Yauhen Kharuzhy     jekhor_(at)_gmail.com

A: No
Q: Should I quote below my post?
