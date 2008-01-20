Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbYATSbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbYATSbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYATSa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:30:58 -0500
Received: from smtp.mermit.fi ([194.100.131.6]:47099 "EHLO smtp.mermit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYATSa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:30:58 -0500
X-Spam-Flag: NO
X-Spam-Score: -1.179
Message-ID: <47939363.8040603@kolumbus.fi>
Date: Sun, 20 Jan 2008 20:30:59 +0200
From: =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk> <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
In-Reply-To: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> + * This is how much memory *in addition to the memory covered up to
> + * and including _end* we need mapped initially.  We need one bit for
> + * each possible page, but only in low memory, which means
> + * 2^32/4096/8 = 128K worst case (4G/4G split.)
> + *
> + * Modulo rounding, each megabyte assigned here requires a kilobyte of
> + * memory, which is currently unreclaimed.
> + *
> + * This should be a multiple of a page.
> + */
> +#define INIT_MAP_BEYOND_END	(128*1024)
> +
> +/*
>   

You have dropped the requirement to map all of low memory (the boot 
allocator is used for instance to construct physical mem mapping). 
Either you should fix your INIT_MAP_BEYOND_END or make a big comment 
telling us why it isn't necessary anymore to map low mem.

--Mika
