Return-Path: <linux-kernel-owner+w=401wt.eu-S1764507AbXETJyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764507AbXETJyt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 05:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbXETJyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 05:54:38 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:2803 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbXETJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 05:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=i3TrmB5nGhXulUDBZ9e7pDOAt8jX1BAivFrxzHPlkwcoZTRren6nWiQQRykrZmz3zCVvHArmWPi376EE8hzh+9oPfr60VBfNx5TFygxf5y6E6UPBuPzJDxeK6Zw0xkdwzZ7fsvkQI+D8fb0jy7/1Gwt0tRfPh3pdnyg5FrQsjMg=
Message-ID: <46501ACF.6020702@gmail.com>
Date: Sun, 20 May 2007 11:54:23 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Paul Mundt <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
Subject: Re: sd_resume redundant?  [was: [PATCH] libata: implement      ata_wait_after_reset()]
References: <20070510072005.GA27316@linux-sh.org>    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>    <20070511005217.GA23186@li <464B3505.20004@gmail.com>    <2229.81.207.0.53.1179592754.squirrel@secure.samage.net>    <464F4548.6020101@gmail.com> <464F4A58.2050607@gmail.com> <4764.81.207.0.53.1179613997.squirrel@secure.samage.net>
In-Reply-To: <4764.81.207.0.53.1179613997.squirrel@secure.samage.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> On Sat, May 19, 2007 21:04, Tejun Heo wrote:
>> Tejun Heo wrote:
>>> Yeah, if SCR registers are accessible, 0xff doesn't indicate the device
>>> isn't there, so the whole skip-0xff logic probably shouldn't apply in
>>> such cases, but we can also achieve pretty good result by just making
>>> the first reset tries a bit more aggressive.
>> So, here's the patch.
>>
>> Paul, can you please test this patch without the previous patch?  Indan,
>> this should reduce the resume delay.  Please test.  But you'll still
>> feel some added delay compared to 2.6.20 due to the mentioned
>> suspend/resume change.
> 
> This removed the COMRESET errors indeed, and with sd_resume()
> disabled everything is speedy again (2s or so. Still a desktop pc).
> I didn't try with sd_resume enabled.

Can you try to measure with sd_resume in place?

> Everything seems to work fine without sd_resume(), so why is it needed?

Because not all disks spin up without being told to do so and like it or
not spinning disks up on resume is the default behavior.  As I wrote in
the other reply, it would be worthwhile to make it configurable.

-- 
tejun
