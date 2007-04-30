Return-Path: <linux-kernel-owner+w=401wt.eu-S1423293AbXD3Orz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423293AbXD3Orz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423328AbXD3Orz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:47:55 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48444 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423293AbXD3Ory (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:47:54 -0400
Date: Mon, 30 Apr 2007 16:45:18 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Jaroslav Kysela <perex@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Subject: Re: [PATCH 28/36] Use menuconfig objects II - sound
In-Reply-To: <1177942754.5102.76.camel@johannes.berg>
Message-ID: <Pine.LNX.4.61.0704301641010.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704301350460.29151@yvahk01.tjqt.qr> <1177942754.5102.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 16:19, Johannes Berg wrote:
>
>> --- linux-2.6.21-mm_20070428.orig/sound/aoa/Kconfig
>> +++ linux-2.6.21-mm_20070428/sound/aoa/Kconfig
>> @@ -1,9 +1,12 @@
>[...]
>
>For the aoa bits this ends up having two "Apple Onboard Audio driver"
>bits which is a bit confusing.

What, where? Oh damn.

> How about this instead? SND_AOA was
>pretty much a generic symbol to start with since it will cause snd-aoa
>to be compiled but is pretty much useless on it's own. This hence makes
>the core bits an invisible symbol.
>
>--- wireless-dev.orig/sound/aoa/Kconfig	2006-10-08 19:56:35.000000000 +0200
>+++ wireless-dev/sound/aoa/Kconfig	2007-04-30 16:18:12.935651366 +0200
>@@ -1,13 +1,15 @@
>+menuconfig SND_AOA
>+	bool "Apple Onboard Audio driver"
>+	depends on PPC_PMAC
> 	select SND_PCM
>-	---help---
>-	This option enables the new driver for the various
>-	Apple Onboard Audio components.
>+	help
>+	  This option enables the new driver for the various
>+	  Apple Onboard Audio components.
>+
>+if SND_AOA
>+
>+config SND_AOA_CORE
>+	tristate

Why the extra AOA_CORE? Are there some options that require only AOA
but not AOA_CORE?


Jan
-- 
