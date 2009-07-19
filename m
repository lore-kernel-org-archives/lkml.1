Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbZGSWVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbZGSWVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 18:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZGSWVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 18:21:07 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35425 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbZGSWVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 18:21:06 -0400
Subject: Re: [PATCH] SOUND: OSS sequencer should be initialized after
 snd_seq_system_client_init
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1248020914.2471.4.camel@ht.satnam>
References: <1247861644.4513.15.camel@ht.satnam>
	 <s5h4ot8op0b.wl%tiwai@suse.de> <1248017194.2548.3.camel@ht.satnam>
	 <s5h1voclkz0.wl%tiwai@suse.de>  <1248020914.2471.4.camel@ht.satnam>
Content-Type: text/plain
Organization: ARM Ltd
Date: Sun, 19 Jul 2009 23:19:47 +0100
Message-Id: <1248041987.4302.6.camel@toshiba-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jul 2009 22:19:48.0462 (UTC) FILETIME=[071D58E0:01CA08BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-19 at 21:58 +0530, Jaswinder Singh Rajput wrote:
> [PATCH] SOUND: OSS sequencer should be initialized after snd_seq_system_client_init
> 
> When build SND_SEQUENCER in kernel then OSS sequencer(alsa_seq_oss_init)
> is initialized before System (snd_seq_system_client_init) which leads to
> memory leak :

Thanks for investigating this. I haven't looked at the code in detail
but I find it a bit weird that initialisation order fixes the memory
leak. Shouldn't the memory allocation logic change slightly to avoid the
leak as well (that's in case someone manually inserts the modules in the
wrong order)?

-- 
Catalin

