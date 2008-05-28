Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYE1VB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYE1VB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbYE1VBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:01:22 -0400
Received: from intcomgrp.com ([216.54.13.120]:37675 "EHLO beta.intcomgrp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbYE1VBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:01:21 -0400
X-Greylist: delayed 1351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2008 17:01:21 EDT
Message-ID: <483DC28B.4060001@support.intcomgrp.com>
Date: Wed, 28 May 2008 16:37:31 -0400
From: James Kosin <jkosin@beta.intcomgrp.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: optimizing out inline functions
References: <ayzYV-7mv-5@gated-at.bofh.it> <ayA8E-89e-29@gated-at.bofh.it>
In-Reply-To: <ayA8E-89e-29@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Wed, May 28, 2008 at 02:51:02PM -0500, Steve French wrote:
>> In trying to remove some macros, I ran across another kernel style
<<--SNIP-->>
> With reference to a recent thread about kconfig
> I would prefer:
> static inline void some_debug_function(var1)
> {
> 	if (KCONFIG_DEBUG_SOMETHING) {
> 		something = var1;
> 		printk(some debug text);
> 	}
> }
> 
> 
> But we do not have KCONFIG_DEBUG_SOMETHING available
> so the second best is to use an empty function
> to keep the typechecking in place.
> 
> IIRC gcc optimize both away.

Another way would be to have:

static inline void some_debug_function(var1)
{
    #ifdef KCONFIG_DEBUG_SOMETHING
       something = var1;
       printk(some debug text);
    #endif
}

BUT, this probably violates some styling rules.

James
}
