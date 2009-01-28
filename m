Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZA1IWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZA1IWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZA1IWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:22:33 -0500
Received: from smtp.nokia.com ([192.100.122.230]:33940 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZA1IWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:22:31 -0500
Message-ID: <498018BD.2000806@nokia.com>
Date: Wed, 28 Jan 2009 10:35:09 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: "tony@atomide.com" <tony@atomide.com>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP HSMMC: fix MMC3 dma
References: <1233052573-6223-1-git-send-email-notasas@gmail.com>	 <497EF7E2.7010906@nokia.com> <6ed0b2680901270900t24838c73l3aa8edca62c91710@mail.gmail.com>
In-Reply-To: <6ed0b2680901270900t24838c73l3aa8edca62c91710@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2009 08:21:57.0850 (UTC) FILETIME=[7C71B3A0:01C98121]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grazvydas Ignotas wrote:
> On Tue, Jan 27, 2009 at 2:02 PM, Adrian Hunter
> <ext-adrian.hunter@nokia.com> wrote:
>> Grazvydas Ignotas wrote:
>>> Data transfers on third OMAP3 MMC controller don't work
>>> because DMA line numbers are only defined for MMC1 and MMC2.
>>> Fix that and store line numbers in mmc_omap_host structure
>>> to reduce code size.
>>> Tested on OMAP3 pandora board.
>>>
>>> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>>> ---
>>>  drivers/mmc/host/omap_hsmmc.c |   31 +++++++++++++++++++++++--------
>>>  1 files changed, 23 insertions(+), 8 deletions(-)
>>>
>> Have you considered using the scatter-gather emulation patch:
>>
>>        http://marc.info/?l=linux-omap&m=122726069922195&w=2
>>
>> It was reverted:
>>
>>        http://marc.info/?l=linux-omap&m=122904725322787&w=2
>>
>> because of a hardware problem with OMAP3430 before ES3.0, but applying:
>>
>>
>>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6a79e391df295bd7c2aa1309ea5031f361c197fd
>>
>> seems to overcome even that.
> 
> Hmm, but it still doesn't know about MMC3. But in case that SG patch
> goes first, I can resend.

I just meant, you might be interested because it gives better performance.

No, it doesn't know about MMC3, but it does hit some of the same lines of
code.

