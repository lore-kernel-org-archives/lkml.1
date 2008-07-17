Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbYGQXoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbYGQXoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbYGQXoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:44:10 -0400
Received: from jade.aracnet.com ([216.99.193.136]:43174 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbYGQXoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:44:09 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 19:44:09 EDT
Message-ID: <487FD74C.4080603@BitWagon.com>
Date: Thu, 17 Jul 2008 16:35:40 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nathan Lynch <ntl@pobox.com>, benh@kernel.crashing.org,
       torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, roland@redhat.com
Subject: Re: [PATCH v3] elf loader support for auxvec base platform string
References: <1216166331-14810-1-git-send-email-ntl@pobox.com>	<1216166331-14810-2-git-send-email-ntl@pobox.com>	<1216276539.7740.309.camel@pasglop>	<20080717000951.5f8cab37.akpm@linux-foundation.org>	<20080717221932.GL9594@localdomain> <20080717154218.8981035c.akpm@linux-foundation.org>
In-Reply-To: <20080717154218.8981035c.akpm@linux-foundation.org>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 17 Jul 2008 17:19:32 -0500
> Nathan Lynch <ntl@pobox.com> wrote:
> 
> 
>> [snip]
>> A new aux vector entry, AT_BASE_PLATFORM, will denote the actual hardware.
[snip]

> OK.
> 
> But it conflicts directly with the already-queued
> execve-filename-document-and-export-via-auxiliary-vector.patch

[snip]

It seems to me that most of the patch conflicts are mechanical
and could be merged mechanically.

However I believe that the documentation change to this comment is important:
-----
>  #ifdef __KERNEL__
> -#define AT_VECTOR_SIZE_BASE (14 + 2) /* NEW_AUX_ENT entries in auxiliary table */
> +#define AT_VECTOR_SIZE_BASE 17 /* NEW_AUX_ENT entries in auxiliary table */
> +  /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
>  #endif
-----
I scratched my head for a while to figure out that AT_NOTELF also was
a subtraction as far as AT_VECTOR_SIZE_BASE was concerned.


-- 
John Reiser, jreiser@BitWagon.com
