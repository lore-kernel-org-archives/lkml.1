Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbXBAGsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbXBAGsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 01:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161153AbXBAGsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 01:48:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:17178 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383AbXBAGsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 01:48:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WE5Bzi+CQEW1srVgA2lSAENOQgJ0fpnHwIi7XKpesK38b+8JsFs5NEx7dAUiy1rTlXHRE9uxYd1z+3OGvfIaMtJkLpXFI6EnmGGOmGaEXgPp2k+2FJjRZQBuoY7K94oWuPHvEzxQlkfLyCR4KkYMalTK68CNnxmXvpUsa4xvzeo=
Message-ID: <84144f020701312248r74007ea6je278adf4f27e2171@mail.gmail.com>
Date: Thu, 1 Feb 2007 08:48:16 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.20-rc7
Cc: "=?ISO-8859-1?Q?Pawe=C5_Sikora?=" <pluto@agmk.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Hellwig" <hch@lst.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Martin Peschke" <mp3@de.ibm.com>, "Andrew Morton" <akpm@osdl.org>,
       "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
	 <45C05150.6000802@agmk.net>
	 <Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org>
X-Google-Sender-Auth: 099369d1a62f66f5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> When do_tune_cpucache() is called at bootup, I'm not sure how safe it is
> to do the kzalloc() thing.

The kzalloc thing is safe as we have already successfully boostrapped
all kmalloc caches at that point. The per-CPU caches that are replaced
by do_tune_cpucache() point to boostrap-time array caches there (see
use of struct arraycache_init in setup_cpu_cache).
