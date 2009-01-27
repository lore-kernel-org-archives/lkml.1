Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZA0LuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZA0LuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZA0Ltx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:49:53 -0500
Received: from smtp.nokia.com ([192.100.122.230]:63472 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbZA0Ltw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:49:52 -0500
Message-ID: <497EF7E2.7010906@nokia.com>
Date: Tue, 27 Jan 2009 14:02:42 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: "tony@atomide.com" <tony@atomide.com>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP HSMMC: fix MMC3 dma
References: <1233052573-6223-1-git-send-email-notasas@gmail.com>
In-Reply-To: <1233052573-6223-1-git-send-email-notasas@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2009 11:49:33.0644 (UTC) FILETIME=[524348C0:01C98075]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grazvydas Ignotas wrote:
> Data transfers on third OMAP3 MMC controller don't work
> because DMA line numbers are only defined for MMC1 and MMC2.
> Fix that and store line numbers in mmc_omap_host structure
> to reduce code size.
> Tested on OMAP3 pandora board.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   31 +++++++++++++++++++++++--------
>  1 files changed, 23 insertions(+), 8 deletions(-)
> 

Have you considered using the scatter-gather emulation patch:

	http://marc.info/?l=linux-omap&m=122726069922195&w=2

It was reverted:

	http://marc.info/?l=linux-omap&m=122904725322787&w=2

because of a hardware problem with OMAP3430 before ES3.0, but applying:

	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6a79e391df295bd7c2aa1309ea5031f361c197fd

seems to overcome even that.
