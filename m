Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXEWVW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXEWVW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXEWVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:22:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43476 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754726AbXEWVWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:22:50 -0400
Date: Wed, 23 May 2007 23:22:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org
Subject: Re: Status of CONFIG_FORCED_INLINING?
Message-ID: <20070523212237.GH2098@stusta.de>
References: <200705231510.52932.rob@landley.net> <46549937.1030306@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46549937.1030306@linux.intel.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:42:47PM -0700, Arjan van de Ven wrote:
> Rob Landley wrote:
>> I notice that feature-removal-schedule.txt has CONFIG_FORCED_INLINING 
>> scheduled to go away most of a year ago.  My question is what replaces it:
>> Does #define inline __always_inline become the new standard and uses of 
>> __always_inline be removed, or should all instances of "inline" either be 
>> removed or replaced with __always_inline?  (Or are there going to be two 
>> keywords meaning exactly the same thing going forward?)
>
> it should be that we do not force gcc to inline on the "normal" inline 
> keyword, and we mark the cases that HAVE to be inlined for correctness 
> reasons as __always_inline.

What about performance reasons?
We habe "inline" code in header files that heavily relies on being 
nearly completely optimized away after being inlined.
Especially with -Os it could even sound logical for a compiler to never 
inline a non-forced "inline"'d three line function with 2 callers.

And we need only two different inline levels (__always_inline and
"let the compiler decide"), not three (__always_inline, inline and
"let the compiler decide").

The rules are simple:
- every static function in a header file must be __always_inline
- no function in a C file should be marked as __always_inline/inline
- in extreme rare cases there might be exceptions from the latter

Your suggestion is possible, but please also send a patch that turns 
every "inline" in header files into __always_inline...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

