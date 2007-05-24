Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbXEXRNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbXEXRNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXEXRND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:13:03 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44608 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949AbXEXRNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:13:01 -0400
Date: Thu, 24 May 2007 19:12:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
Message-ID: <20070524171254.GB4470@stusta.de>
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com> <20070523212237.GH2098@stusta.de> <4654B2B5.4080207@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4654B2B5.4080207@linux.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 02:31:33PM -0700, Arjan van de Ven wrote:
> Adrian Bunk wrote:
>> What about performance reasons?
>> We habe "inline" code in header files that heavily relies on being nearly 
>> completely optimized away after being inlined.
>
> fair
>
>> Especially with -Os it could even sound logical for a compiler to never 
>> inline a non-forced "inline"'d three line function with 2 callers.
>
> but you said "I Care about size more than performance". Your argument is 
> thus absolutely incorrect.

Theoretically, you are right.

Practically, this would imply removing the CONFIG_CC_OPTIMIZE_FOR_SIZE 
option several distributions currently enable by default since it has 
been shown that it often generates faster code...

>> The rules are simple:
>> - every static function in a header file must be __always_inline
>
> wrong.
>
>> Your suggestion is possible, but please also send a patch that turns every 
>> "inline" in header files into __always_inline...
>
> this is 1) insane and 2) if inlines in headers are so big gcc decides to 
> not inline them.. they're too big and don't belong in the header.

Exactly.

So there's no point in having a non-forced inline.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

