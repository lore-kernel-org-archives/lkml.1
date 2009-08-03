Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZHCRcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZHCRcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZHCRca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:32:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:26178 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZHCRc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:32:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,315,1246863600"; 
   d="scan'208";a="435737909"
From: "Othman, Ossama" <ossama.othman@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 3 Aug 2009 10:32:28 -0700
Subject: RE: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Thread-Topic: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
Thread-Index: AcoSegIByrRWy/lWS6aKpXQaEe8vXwB5JZdg
Message-ID: <A5FE05C4C76E4C4CAB15D9962B96FC950C7957A872@orsmsx510.amr.corp.intel.com>
References: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
 <20090801073053.GA30389@merkur.ravnborg.org>
In-Reply-To: <20090801073053.GA30389@merkur.ravnborg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

>Please use:
>+ memrar-y := memrar_allocator.o memrar_handler.o
>
>The foo-objs syntax is deprecated.

Thanks!  I'll make that change.

The file `Documentation/kbuild/makefiles.txt' doesn't mention the deprecation, AFAICT.  Can you tell me where it is documented?

>> +
>> +
>> +#include "memrar_allocator.h"
>> +#include <linux/slab.h>
>> +#include <linux/bug.h>
>
><linux/...> comes _before_ you own includes.
>And an empty line in between.

Will do!

This guideline doesn't appear in Documentation/CodingStyle.  Should it?
 
>> +
>> +
>> +struct memrar_allocator *memrar_create_allocator(unsigned long base,
>> +						 size_t capacity,
>> +						 size_t block_size)
>> +{
>> +	struct memrar_allocator *allocator = 0;
>
>It is recommended to separate definition,
>and assignment.
>So this should look like this:
>
>	struct memrar_allocator *allocator;
>
>	allocator = 0;

Okay, I'll fix that, too.  Should this go into Documentation/CodingStyle, too?

>> +
>> +	/* Validate parameters. */
>> +	if (/*
>> +	     * Make sure we can allocate the entire memory allocator
>> +	     * space.
>> +	     */
>> +		ULONG_MAX - capacity >= base
>> +
>> +		/* Zero capacity or block size are obviously invalid. */
>> +		&& capacity != 0
>> +		&& block_size != 0) {
>
>Very ugly way to comment your if (..) IMHO
>Put the comment abvoe the if.

You're not the only that has mentioned that :).  I'll fix this in the next revision, as well.

>I'm short on time - so this is the comments for today...

Thanks a lot for the feedback, Sam!  I'll address all of your comments in the next revision!

-Ossama
