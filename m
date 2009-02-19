Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZBSLW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZBSLW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZBSLWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:22:48 -0500
Received: from cs20.apochromatic.org ([204.152.189.161]:58375 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbZBSLWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:22:47 -0500
Date: Thu, 19 Feb 2009 11:22:43 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_core: fix data timeout for SEND_EXT_CSD
Message-ID: <20090219112243.GB25903@console-pimps.org>
References: <4991A00B.8040002@nokia.com> <20090211133004.GH478@console-pimps.org> <4992D90E.10506@nokia.com> <4992E597.2030404@nokia.com> <20090218211627.7c16339a@mjolnir.ossman.eu> <499D0B5C.4000005@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499D0B5C.4000005@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 19, 2009 at 09:33:48AM +0200, Adrian Hunter wrote:
> ext Pierre Ossman wrote:
>>
>> I'm confused. Where did the 64 come from in the first place? That
>> function will not be called for CID/CSD when !SPI. So the way I see it
>> the code should be:
>>
>> if ((opcode == MMC_SEND_CSD) || (opcode == (MMC_SEND_CID)) {
>>         data.timeout_ns = 0;
>>         data.timeout_clks = 8;
>> } else {
>>         mmc_set_data_timeout(&data, card);
>> }
>
> Theoretically yes, it should be 8 not 64 - if all the SPI devices obey
> the standard.  As I do not have an SPI device I did not feel comfortable
> changing it.  Also 64 clocks is not a long time anyway, so it did not
> seem to do any harm.

When I wrote the code, I got the 64 clock cycle timeout from the MMC
spec that I was looking at. Unfortunately, I don't have the spec in
front of me at the moment. It is possible that I read the timeout for
the !SPI case, though.
