Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYE2D2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYE2D2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYE2D15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:27:57 -0400
Received: from saeurebad.de ([85.214.36.134]:39522 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbYE2D14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:27:56 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: James Kosin <jkosin@beta.intcomgrp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: optimizing out inline functions
References: <ayzYV-7mv-5@gated-at.bofh.it> <ayA8E-89e-29@gated-at.bofh.it>
	<483DC28B.4060001@support.intcomgrp.com>
Date: Thu, 29 May 2008 05:27:23 +0200
In-Reply-To: <483DC28B.4060001@support.intcomgrp.com> (James Kosin's message
	of "Wed, 28 May 2008 16:37:31 -0400")
Message-ID: <87lk1trdr8.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

James Kosin <jkosin@beta.intcomgrp.com> writes:

> Sam Ravnborg wrote:
>> On Wed, May 28, 2008 at 02:51:02PM -0500, Steve French wrote:
>>> In trying to remove some macros, I ran across another kernel style
> <<--SNIP-->>
>> With reference to a recent thread about kconfig
>> I would prefer:
>> static inline void some_debug_function(var1)
>> {
>> 	if (KCONFIG_DEBUG_SOMETHING) {
>> 		something = var1;
>> 		printk(some debug text);
>> 	}
>> }
>>
>>
>> But we do not have KCONFIG_DEBUG_SOMETHING available
>> so the second best is to use an empty function
>> to keep the typechecking in place.
>>
>> IIRC gcc optimize both away.
>
> Another way would be to have:
>
> static inline void some_debug_function(var1)
> {
>    #ifdef KCONFIG_DEBUG_SOMETHING
>       something = var1;
>       printk(some debug text);
>    #endif
> }
>
> BUT, this probably violates some styling rules.

Without indenting the ifdefs, I think this solution is the best.

It gives you the advantages of type checking but saves a superfluous
prototype.

	Hannes
