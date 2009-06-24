Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZFXKGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZFXKGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 06:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZFXKGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 06:06:41 -0400
Received: from mail.open.by ([193.232.92.17]:50981 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562AbZFXKGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 06:06:40 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8821 [Jun 24 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Wed, 24 Jun 2009 13:08:09 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: kmemleak: Early log buffer exceeded
Message-ID: <20090624100809.GA3299@localdomain.by>
References: <20090623212648.GA9502@localdomain.by>
 <1245836105.16283.13.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245836105.16283.13.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/24/09 10:35), Catalin Marinas wrote:
> > So, my questions are:
> > 1. Is 200 really enough? Why 200 not 512, 1024 (for example)?
> 
> It seems that in your case it isn't. It is fine on the machines I tested
> it on but choosing this figure wasn't too scientific.
> 
> I initially had it bigger and marked with the __init attribute to free
> it after initialisation but this was causing (harmless) section mismatch
> warnings.
>
Hello. 

Why not configure it?

//EXAMPLE
config DEBUG_KMEMLEAK_EARLY_LOG_SIZE
	int "Maximum early log entries"
	range 200 2000
	default "300"
	depends on DEBUG_KMEMLEAK
	help
	  Specify early_log size (200,400,etc.).

kmemleak.c
static struct early_log early_log[CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE];

(Well, CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE is a bit ugly.)


> What kind of hardware do you have?
>
Most of time - ASUS F3Jc laptop.

 
> > 2. When (crt_early_log >= ARRAY_SIZE(early_log)) == 1 we just can see stack.
> > Since we have "full" early_log maybe it'll be helpfull to see it?
> 
> I recall allocating this dynamically didn't work properly but I'll give
> it another try. Otherwise, I can make it configurable and print a better
> message (probably without the stack dump).
> 
> -- 
> Catalin
> 

	Sergey
